function findEars(handles,sfn,efn,erase)
global frames;
global cmasks;

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
M.TouchingHandsArea = getParameter(handles,'Touching Hands Area');
masksMap = getParameter(handles,'Masks Order');
tags = M.tags;
zw = M.zw;

% sfn = 1;
% efn = length(frames);
frameNums = sfn:efn;
if sfn == 1 && efn == length(frames)
    allFrames = 1;
else
    allFrames = 0;
end
indexC = strfind(M.tags,'Left Ear');
tagL = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Right Ear');
tagR = find(not(cellfun('isempty', indexC)));

if exist('erase','var')
    if allFrames
        if ~isempty(M.R)
            LiaL = ismember(M.R(:,2),tagL,'rows');
            if any(LiaL)
                M.R(LiaL,:) = [];
            end
            LiaR = ismember(M.R(:,2),tagR,'rows');
            if any(LiaR)
                M.R(LiaR,:) = [];
            end
            if ~isempty(M.P)
                LiaL = ismember(M.P(:,2),tagL,'rows');
                if any(LiaL)
                    M.P(LiaL,:) = [];
                end
            end
            if ~isempty(M.P)
                LiaR = ismember(M.P(:,2),tagR,'rows');
                if any(LiaR)
                    M.P(LiaR,:) = [];
                end
            end
        end
    else
        if ~isempty(M.R)
            quit = 0;
            for ii = 1:length(frameNums)
                if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
                    quit = 1;
                    break;
                end
                tic
                fn = frameNums(ii);
                LiaL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
                LiaR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
                M.R(LiaL | LiaR,:) = [];
                LiaL = ismember(M.P(:,[1 2]),[fn tagL],'rows');
                LiaR = ismember(M.P(:,[1 2]),[fn tagR],'rows');
                M.P(LiaL | LiaR,:) = [];
                displayMessage(handles,sprintf('Erasing %s ... Processing frame %d - %d/%d ... time remaining %s','ears',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
            end
        end
    end
    if quit == 0
        handles.md.resultsMF.R = M.R;
        handles.md.resultsMF.P = M.P;
    end
    if sfn==efn
        fn = round(get(handles.slider1,'Value'));
        displayFrames(handles,fn,sfn);
    else
        displayFrames(handles,sfn);
    end
    if quit == 0
        disp('Erased Ears');
    end
    return;
end

RR = []; RL = [];
R1 = [];
P1 = [];
PL = [];
PR = [];
props = {'FontSize',9,'ForegroundColor','b'};
status = 0;
tic
t = toc;
for ii = 1:length(frameNums)
    tic
    fn = frameNums(ii);
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        break;
    end
    if ~isempty(M.R)
        tic
        LiaL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
        LiaR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
        Lia = LiaL | LiaR;
        if any(Lia) & ~get(handles.checkbox_over_write,'Value')
%             RL = [RL;M.R(LiaL,:)];
%             RR = [RR;M.R(LiaR,:)];
%             LiaL = ismember(M.Po(:,[1 2]),[fn tagL],'rows');
%             LiaR = ismember(M.Po(:,[1 2]),[fn tagR],'rows');
%             PL = [PL;M.Po(LiaL,:)];
%             PR = [PR;M.Po(LiaR,:)];
            continue;
        end
    end
    set(handles.pushbutton_stop_processing,'userdata',fn);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    if get(handles.checkbox_useSimpleMasks,'Value')
        tMasks = find_masks(handles,thisFrame);
    else
        tMasks = get_masks_KNN(handles,fn);
    end
    
    if sum(tMasks.Ie(:)) == 0
        displayMessageBlinking(handles,sprintf('Can not find %s ... No mask found ... Processing frame %d - %d/%d ... time remaining %s','Ears',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)),{'ForegroundColor','r'},3);
        continue;
    end
    
%     tMasks = get_masks_KNN(handles,fn);
    Cs = [];
%     Cs{1} = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
    Cs{1} = getRegions(handles,fn,masksMap{1});
    if isempty(Cs{1})
        displayMessageBlinking(handles,sprintf('Can not find %s ... find body first ... Processing frame %d - %d/%d ... time remaining %s','Ears',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)),{'ForegroundColor','r'},3);
        continue;
    end
    if fn > 1
        Cs{2} = getRegions(handles,fn-1,masksMap{2});
    else
        Cs{2} = [];
    end
    try
        Ce = find_centroids(M,fn,'ears',tMasks,thisFrame,Cs);
        CL = []; CR = [];
        for ee = 1:length(Ce)
            C = Ce(ee);
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,C.ear);
            tag = find(not(cellfun('isempty', indexC)));
            R1 = [R1;[fn tag x y C.Area]];
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
            P1 = [P1;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag pixelsI]];
            M.R1 = R1;
            if strcmp(C.ear,'Left Ear')
                CL = C;
            end
            if strcmp(C.ear,'Right Ear')
                CR = C;
            end
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
        saveRegionsMask(handles,Ce,fn,masksMap{2});
        
%         if length(Ce) > 1
%             try
%                 C = Ce(2);%find_centroids(M,fn,'Left Ear');
%                 CL = [];
%                 if isfield(C,'Area')
%                     if ~isempty(C.Area)
%                         C = findBoundary(C,size(thisFrame));
%                         CL = C;
%                         x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%                         indexC = strfind(tags,'Left Ear');
%                         tag = find(not(cellfun('isempty', indexC)));
%                         RL = [RL;[fn tag x y C.Area]];
%                         pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
%                         pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
%                         PL = [PL;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag pixelsI]];
%                         M.RL = RL;
%                     end
%         %             saveMP(handles,fn,tag,pixelsI);
%         %             saveMR(handles,fn,tag,x,y,0);
%                 end
%                 C = Ce(1); % right ear
%                 CR = [];
%                 if isfield(C,'Area')
%                     if ~isempty(C.Area)
%                         C = findBoundary(C,size(thisFrame));
%                         CR = C;
%                         x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%                         indexC = strfind(tags,'Right Ear');
%                         tag = find(not(cellfun('isempty', indexC)));
%                         RR = [RR;[fn tag x y C.Area]];
%                         pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
%                         pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
%                         PR = [PR;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag pixelsI]];
%                         M.RR = RR;
%                     end
%                 end
% 
%                 if get(handles.checkbox_updateDisplay,'Value')
%                     figure(100);clf;
%                     imagesc(thisFrame);axis equal;
%                     hold on;
%                     if ~isempty(CL)
%                         plot(CL.xb,CL.yb,'r');
%                     end
%                     if ~isempty(CR)
%                         plot(CR.xb,CR.yb,'b');
%                     end
% 
%                     title(fn);
%                 end
%                 saveRegionsMask(handles,Ce,fn,masksMap{2});
%             catch
%                 display(sprintf('Could not find for frame %d',fn));
% %                 displayMessage(handles,sprintf('Finding %s ... Processing frame %d - %d/%d ... time remaining %s ... not found','Ears',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
% %                 pause(0.5);
%                 continue;
%             end
%         else
%             display(sprintf('Could not find for frame %d',fn));
% %             displayMessage(handles,sprintf('Finding %s ... Processing frame %d - %d/%d ... time remaining %s ... not found','Ears',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
% %             pause(0.5);
%         end
        displayMessage(handles,sprintf('Finding %s ... Processing frame %d - %d/%d ... time remaining %s','Ears',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
    catch
        displayMessage(handles,sprintf('Sorry ... :-( ... error occurred in frame %d ... see detailed error in Matlab Window',fn),props);
        status = 1;
        break;
    end
end
if ~isempty(R1)% | ~isempty(RL)
    M.R = [M.R;R1];%[M.R;RR;RL];
    M.P = [M.P;P1];%[M.P;PR;PL];
    handles.md.resultsMF.R = M.R;
    handles.md.resultsMF.P = M.P;
    global cmasks;
    handles.md.cmasksMF.cmasks = cmasks;
else
    if status
        rethrow(lasterror);
    end
    return;
end
if status == 0
    if sfn==efn
        fn = round(get(handles.slider1,'Value'));
        displayFrames(handles,fn,sfn);
    else
        displayFrames(handles,sfn);
    end
    disp('Done with finding ears');
    displayMessage(handles,sprintf('Done processing frames from %d to %d',sfn,sfn+ii-1));
else
    rethrow(lasterror);
end