function findEars(handles,sfn,efn,erase)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = handles.md.resultsMF.zoomWindow;
M.scale = handles.md.resultsMF.scale;
M.frameSize = handles.d.frameSize;
tags = M.tags;
zw = M.zw;
global frames;
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
            for ii = 1:length(frameNums)
                fn = frameNums(ii);
                LiaL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
                LiaR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
                M.R(LiaL | LiaR,:) = [];
                LiaL = ismember(M.P(:,[1 2]),[fn tagL],'rows');
                LiaR = ismember(M.P(:,[1 2]),[fn tagR],'rows');
                M.P(LiaL | LiaR,:) = [];
            end
        end
    end
    handles.md.resultsMF.R = M.R;
    handles.md.resultsMF.P = M.P;
    if sfn==efn
        fn = round(get(handles.slider1,'Value'));
        displayFrames(handles,fn,sfn);
    else
        displayFrames(handles,sfn);
    end
    disp('Erased Ears');
    return;
end

RR = []; RL = [];
PL = [];
PR = [];
tic
t = toc;
for ii = 1:length(frameNums)
    tic
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        break;
    end
    fn = frameNums(ii);
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
%     tMasks = get_masks_KNN(handles,fn);
    Cs = [];
    Cs{1} = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
    Cs{2} = find_centroids(M,fn,'ears',tMasks,thisFrame,Cs);
    if length(Cs{2}) > 1
        try
            C = Cs{2}(2);%find_centroids(M,fn,'Left Ear');
            CL = [];
            if isfield(C,'Area')
                C = findBoundary(C,size(thisFrame));
                CL = C;
                x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
                indexC = strfind(tags,'Left Ear');
                tag = find(not(cellfun('isempty', indexC)));
                RL = [RL;[fn tag x y C.Area]];
                pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
                pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
                PL = [PL;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag pixelsI]];
    %             saveMP(handles,fn,tag,pixelsI);
    %             saveMR(handles,fn,tag,x,y,0);
            end
            C = Cs{2}(1); % right ear
            CR = []
            if isfield(C,'Area')
                C = findBoundary(C,size(thisFrame));
                CR = C;
                x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
                indexC = strfind(tags,'Right Ear');
                tag = find(not(cellfun('isempty', indexC)));
                RR = [RR;[fn tag x y C.Area]];
                pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
                pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
                PR = [PR;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag pixelsI]];
    %             saveMR(handles,fn,tag,x,y,0);
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
        catch
            display(sprintf('Could not find for frame %d',fn));
            continue;
        end
    else
        display(sprintf('Could not find for frame %d',fn));
    end
    displayMessage(handles,sprintf('Finding %s ... Processing frame %d - %d/%d ... time remaining %s','Ears',ii,fn,length(frameNums),getTimeRemaining(length(frameNums),ii)));
end
if ~isempty(RR)
    M.R = [M.R;RR;RL];
    M.P = [M.P;PR;PL];
    handles.md.resultsMF.R = M.R;
    handles.md.resultsMF.P = M.P;
else
    return;
end
if sfn==efn
    fn = round(get(handles.slider1,'Value'));
    displayFrames(handles,fn,sfn);
else
    displayFrames(handles,sfn);
end
disp('Done with finding ears');
displayMessage(handles,sprintf('Done processing frames from %d to %d',sfn,sfn+ii-1));
