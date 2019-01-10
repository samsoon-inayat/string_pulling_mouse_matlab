function findBody(handles,sfn,efn,erase)

M.R = handles.md.resultsMF.R;
M.Ro = handles.md.resultsMF.R;
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
indexC = strfind(M.tags,'Subject');
tag = find(not(cellfun('isempty', indexC)));
if exist('erase','var') | get(handles.checkbox_over_write,'Value')
    if allFrames
        if ~isempty(M.R)
            Lia = ismember(M.R(:,2),tag(1),'rows');
            if any(Lia)
                M.R(Lia,:) = [];
            end

            Lia = ismember(M.R(:,2),tag(2),'rows');
            if any(Lia)
                M.R(Lia,:) = [];
            end
        end
    else
        if ~isempty(M.R)
            for ii = 1:length(frameNums)
                fn = frameNums(ii);
                Lia = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
                Lia = Lia | ismember(M.R(:,[1 2]),[fn tag(2)],'rows');
                M.R(Lia,:) = [];
            end
        end
    end
end
if exist('erase','var')
    handles.md.resultsMF.R = M.R;
    if sfn==efn
        fn = round(get(handles.slider1,'Value'));
        displayFrames(handles,fn,sfn);
    else
        displayFrames(handles,sfn);
    end
    disp('Erased body fit');
    return;
end

% hWaitBar = waitbar(0,sprintf('Processing Frame -'));

Rb = [];
for ii = 1:length(frameNums)
    tic
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        break;
    end
    fn = frameNums(ii);
    if ~isempty(M.Ro)
        Lia = ismember(M.Ro(:,[1 2]),[fn tag(1)],'rows');
        if any(Lia) & ~get(handles.checkbox_over_write,'Value')
            displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... found existing ... time remaining %s','body',ii,fn,length(frameNums),getTimeRemaining(length(frameNums),ii)));
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
    C = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
    if ~isempty(C)
        indexC = strfind(tags,'Subject');
        tag = find(not(cellfun('isempty', indexC)));
        Rb = [Rb;[fn tag(1) C.Centroid(1)+zw(1) C.Centroid(2)+zw(2) 0]];
        indexC = strfind(tags,'Subject Props');
        tag = find(not(cellfun('isempty', indexC)));
        Rb = [Rb;[fn tag C.MajorAxisLength C.MinorAxisLength C.Orientation]];
    else
        display(sprintf('Could not find for frame %d',fn));
    end
    displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',ii,fn,length(frameNums),getTimeRemaining(length(frameNums),ii)));
end
% close(hWaitBar);
if ~isempty(Rb)
    M.R = [M.R;Rb];
    handles.md.resultsMF.R = M.R;
else
    return;
end
if sfn==efn
    fn = round(get(handles.slider1,'Value'));
    displayFrames(handles,fn,sfn);
else
    displayFrames(handles,sfn);
end
disp('Done with body fit');
displayMessage(handles,sprintf('Done processing frames from %d to %d',sfn,sfn+ii-1));
