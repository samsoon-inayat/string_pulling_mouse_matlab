function findHands(handles,sfn,efn,erase)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
masksMap = getParameter(handles,'Masks Order');
tags = M.tags;


global frames;

if sfn == 1 && efn == length(frames)
    allFrames = 1;
else
    allFrames = 0;
end

tags = handles.md.tags;
numFrames = length(sfn:efn);
frameNums = sfn:efn;

indexC = strfind(tags,'Left Hand');
tag(1) = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Right Hand');
tag(2) = find(not(cellfun('isempty', indexC)));
if exist('erase','var')
    if allFrames
        if ~isempty(M.R)
            LiaL = ismember(M.R(:,2),tag(1),'rows');
            if any(LiaL)
                M.R(LiaL,:) = [];
            end
            LiaR = ismember(M.R(:,2),tag(2),'rows');
            if any(LiaR)
                M.R(LiaR,:) = [];
            end
            if ~isempty(M.P)
                LiaL = ismember(M.P(:,2),tag(1),'rows');
                if any(LiaL)
                    M.P(LiaL,:) = [];
                end
            end
            if ~isempty(M.P)
                LiaR = ismember(M.P(:,2),tag(2),'rows');
                if any(LiaR)
                    M.P(LiaR,:) = [];
                end
            end
        end
    else
        if ~isempty(M.R)
            for ii = 1:length(frameNums)
                tic
                fn = frameNums(ii);
                LiaL = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
                LiaR = ismember(M.R(:,[1 2]),[fn tag(2)],'rows');
                M.R(LiaL | LiaR,:) = [];
                LiaL = ismember(M.P(:,[1 2]),[fn tag(1)],'rows');
                LiaR = ismember(M.P(:,[1 2]),[fn tag(2)],'rows');
                M.P(LiaL | LiaR,:) = [];
                displayMessage(handles,sprintf('Erasing %s ... Processing frame %d - %d/%d ... time remaining %s','hands',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
            end
        end
    end

    handles.md.resultsMF.R = M.R;
    if sfn==efn
        fn = round(get(handles.slider1,'Value'));
        displayFrames(handles,fn,sfn);
    else
        displayFrames(handles,sfn);
    end
    disp('Erased Hands');
    return;
end


RR = []; RL = [];
PL = [];
PR = [];
status = 0;
zw = getParameter(handles,'Auto Zoom Window');
stopped = 0;
for ii = 1:numFrames
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        stopped = 1;
        break;
    end
    fn = frameNums(ii);
    if fn == 449
        n = 0;
    end
    if ~isempty(M.R)
        LiaL = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
        LiaR = ismember(M.R(:,[1 2]),[fn tag(2)],'rows');
        Lia = LiaL | LiaR;
        if any(Lia) & ~get(handles.checkbox_over_write,'Value')
            continue;
        end
    end
     
    displayMessage(handles,sprintf('Finding hands ... Processing frame %d',fn));
    set(handles.pushbutton_stop_processing,'userdata',fn);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    allCs = find_all_centroids(handles,fn,thisFrame);
    if ~isstruct(allCs{3})
        if allCs{3} < 0
            set(handles.pushbutton_stop_processing,'visible','off');
            displayMessageBlinking(handles,'Select at least one method in Hands Identification Parameters Panel',{'ForegroundColor','r'},3);
            status = 1;
            continue;
        end
    end
    CL = []; CR = [];
    if ~isempty(allCs{3})
        Cs = allCs{3};%find_centroids(M,fn,'Right Hand_A');
        if strcmp(Cs(1).Hand,'Left Hand')
            C = Cs(1);
        else
            C = Cs(2);
        end
        if ~isempty(C)
            CL = C;
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%             indexC = strfind(tags,'Left Hand');
%             tag = find(not(cellfun('isempty', indexC)));
%             RL = [RL;[fn tag(1) x y C.manual]];
            saveMR(handles,fn,tag(1),x,y,C.manual);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
%             PL = [PL;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag(1) pixelsI]];
            saveMP(handles,fn,tag(1),pixelsI);
        end
        % C = find_centroids(M,fn,'Right Hand_A');
        if strcmp(Cs(1).Hand,'Right Hand')
            C = Cs(1);
        else
            C = Cs(2);
        end
        if ~isempty(C)
            CR = C;
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%             indexC = strfind(tags,'Right Hand');
%             tag = find(not(cellfun('isempty', indexC)));
%             RR = [RR;[fn tag(2) x y C.manual]];
            saveMR(handles,fn,tag(2),x,y,C.manual);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
%             PR = [PR;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag(2) pixelsI]];
            saveMP(handles,fn,tag(2),pixelsI);
        end
        if get(handles.checkbox_updateDisplay,'Value')
            figure(100);clf;
            imagesc(thisFrame);axis equal;
            hold on;
            if ~isempty(CL)
                plot(CL.xb,CL.yb,'r');
            end
            if ~isempty(CR)
                plot(CR.xb,CR.yb,'b');
            end
            title(fn);
        end
        saveRegionsMask(handles,Cs,fn,masksMap{4});
    end
%     if numFrames > 1 & mod(ii,5) == 0
%         displayFrames(handles,sfn);
%     end
    pause(0.1);
end
global cmasks;
handles.md.cmasksMF.cmasks = cmasks;
% if ~isempty(RR)
%     M.R = [M.R;RR;RL];
%     M.P = [M.P;PR;PL];
%     handles.md.resultsMF.R = M.R;
%     handles.md.resultsMF.P = M.P;
% else
%     return;
% end
if status == 0
    if sfn==efn
        fn = round(get(handles.slider1,'Value'));
        displayFrames(handles,fn,sfn);
    else
        displayFrames(handles,sfn);
    end
    displayMessage(handles,sprintf('Done processing frames from %d to %d',sfn,sfn+ii-1));
end