function findNose(handles,sfn,efn,erase)

M.R = handles.md.resultsMF.R;
M.Ro = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
masksMap = getParameter(handles,'Masks Order');
tags = M.tags;
zw = M.zw;

global frames;
global cmasks;
% sfn = 1;
% efn = length(frames);
frameNums = sfn:efn;
if sfn == 1 && efn == length(frames)
    allFrames = 1;
else
    allFrames = 0;
end
indexC = strfind(M.tags,'Nose');
tag = find(not(cellfun('isempty', indexC)));
if exist('erase','var') | get(handles.checkbox_over_write,'Value')
    if allFrames
        if ~isempty(M.R)
            Lia = ismember(M.R(:,2),tag(1),'rows');
            if any(Lia)
                M.R(Lia,:) = [];
            end
        end
        if ~isempty(M.P)
            Lia = ismember(M.P(:,2),tag(1),'rows');
            if any(Lia)
                M.P(Lia,:) = [];
            end
        end
    else
        if ~isempty(M.R)
            LiaR = zeros(size(M.R,1),1);
            LiaP = zeros(size(M.P,1),1);
            quit = 0;
            for ii = 1:length(frameNums)
                if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
                    quit = 1;
                    break;
                end
                tic
                fn = frameNums(ii);
                Lia = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
                LiaR = LiaR | Lia;
                LiaP = LiaP | ismember(M.P(:,[1 2]),[fn tag(1)],'rows');
                displayMessage(handles,sprintf('Erasing %s ... Processing frame %d - %d/%d ... time remaining %s','nose',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
            end
            M.R(LiaR,:) = [];
            M.P(LiaP,:) = [];
        end
    end
end
if exist('erase','var')
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
        disp('Erased body fit');
    end
    return;
end

% hWaitBar = waitbar(0,sprintf('Processing Frame -'));

Rb = [];
P = [];
try
for ii = 1:length(frameNums)
    tic
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        break;
    end
    fn = frameNums(ii);
    if ~isempty(M.Ro)
        Lia = ismember(M.Ro(:,[1 2]),[fn tag(1)],'rows');
        if any(Lia) & ~get(handles.checkbox_over_write,'Value')
            displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... found existing ... time remaining %s','body',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
            continue;
        end
    end
    set(handles.pushbutton_stop_processing,'userdata',fn);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     if get(handles.checkbox_useSimpleMasks,'Value')
%         tMasks = find_masks(handles,thisFrame);
%     else
        tMasks = get_masks_KNN(handles,fn);
    if sum(tMasks.In(:)) == 0
        displayMessageBlinking(handles,sprintf('Can not find %s ... No mask found ... Processing frame %d - %d/%d ... time remaining %s','Nose',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)),{'ForegroundColor','r'},3);
        continue;
    end
%     end
%     tMasks = get_masks_KNN(handles,fn);
    Cs{1} = getRegions(handles,fn,masksMap{1});
    if fn > 1
        Cs{2} = getRegions(handles,fn-1,masksMap{5});
    end
    C = find_centroids(M,fn,'nose',tMasks,thisFrame,Cs);
    
    if ~isempty(C)
%         C.xb = downsample(C.xb,2);
%         C.yb = downsample(C.yb,2);
        indexC = strfind(tags,'Nose');
        tag = find(not(cellfun('isempty', indexC)));
        Rb = [Rb;[fn tag(1) C.Centroid(1)+zw(1) C.Centroid(2)+zw(2) 0]];
        
        pixels = [(C.xb + zw(1)-1) (C.yb + zw(2)-1)];
        pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
        P = [P;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag(1) pixelsI]];
        
        if get(handles.checkbox_updateDisplay,'Value')
            figure(100);clf;
            imagesc(thisFrame);axis equal;
            hold on;
            plot(C.Ellipse_xs,C.Ellipse_ys,'g');
            plot(C.xb,C.yb,'r');
            title(fn);
        end
        saveRegionsMask(handles,C,fn,masksMap{5});
    else
        display(sprintf('Could not find for frame %d',fn));
    end
    displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','nose',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
end
catch
%     displayMessage(handles,sprintf('Error occured in %d - %d/%d ... saving processed data',fn,ii,length(frameNums)));
    displayMessageBlinking(handles,sprintf('Error occured in %d - %d/%d ... saving processed data',fn,ii,length(frameNums)),{'ForegroundColor','r'},5);
end
% close(hWaitBar);
if ~isempty(Rb)
    M.R = [M.R;Rb];
    M.P = [M.P;P];
    handles.md.resultsMF.R = M.R;
    handles.md.cmasksMF.cmasks = cmasks;
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
disp('Done with nose fit');
displayMessage(handles,sprintf('Done processing frames from %d to %d',sfn,sfn+ii-1));
