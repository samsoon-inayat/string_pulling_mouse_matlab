function findBody_Coarse(handles,sfn,efn,erase)

% M.R = handles.md.resultsMF.R;
% M.Ro = handles.md.resultsMF.R;
% M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Zoom Window');
M.scale = getParameter(handles,'Scale');
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
frameNums1 = frameNums(1:3:length(frameNums));
igTF = zeros([handles.md.frameSize]);
% sgTF = igTF(zw(2):zw(4),zw(1):zw(3));
igTF = igTF(zw(2):zw(4),zw(1):zw(3));
igTF = repmat(igTF,1,1,length(frameNums));
hf = figure(100);clf;
set(hf,'units','normalized','outerposition',[0 0 1 1])
for ii = 1:length(frameNums1)
    tic
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        return;
    end
    fn = frameNums1(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     mask = find_mask_fur_global(handles,thisFrame);
    mask = compute_masks_KNN(handles,thisFrame,'body');
    gTF = rgb2gray((thisFrame));
    temp = edge(uint8(mask).*gTF);
    igTF(:,:,ii) = temp;
%     temp1 = edge(gTF);
%     sgTF = sgTF + temp1;
    if get(handles.checkbox_updateDisplay,'Value')
        figure(100);
        imagesc(temp);axis equal;
        title(fn);
%         pause(0.01);
    end
    displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
end
mask = max(igTF,[],3) - mean(igTF,3);
hf = figure(100);clf;
imagesc(mask);axis equal;
title('Draw a rectangle around the region of interest which covers all mouse projections');
set(hf,'WindowStyle','modal');
hrect = imrect(gca);
set(hf,'WindowStyle','normal');
if isempty(hrect)
    return;
end
pos = round(hrect.getPosition);
close(hf);
left = pos(1)+zw(1);
if left <= 0
    left = 1;
end
top = pos(2)+zw(2);
if top <= 0
    top = 1;
end
global v;
right = left+pos(3);
if right > v.Width
    right = v.Width;
end
bottom = top + pos(4);
if bottom > v.Height
    bottom = v.Height;
end
% handles.md.resultsMF.zoomWindow = [left top right bottom];
zoomWindow = [left top right-left+1 bottom-top+1];
setParameter(handles,'Auto Zoom Window',[left top right bottom]);
zw = zoomWindow;
set(handles.text_autoZoomWindow,'String',sprintf('[%d %d %d %d]',zw(1),zw(2),zw(4),zw(3)),'userdata',zw,'ForegroundColor','b');
return;

% Rb = [];
% for ii = 1:length(frameNums)
%     tic
%     if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
%         return;
%     end
%     fn = frameNums(ii);
%     if ~isempty(M.Ro)
%         Lia = ismember(M.Ro(:,[1 2]),[fn tag(1)],'rows');
%         if any(Lia) & ~get(handles.checkbox_over_write,'Value')
%             displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... found existing ... time remaining %s','body',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
%             continue;
%         end
%     end
%     set(handles.pushbutton_stop_processing,'userdata',fn);
%     thisFrame = frames{fn};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     
%     mask = find_mask_fur_global(handles,thisFrame);
%     C = find_centroids_fur(mask);
%     if get(handles.checkbox_updateDisplay,'Value')
%         figure(100);clf;
%         Im = imoverlay(thisFrame,mask);
%         imagesc(Im);axis equal;
%         hold on;
%         plot(C.Ellipse_xs,C.Ellipse_ys,'g');
%         title(fn);
%     end
%     tempxs = C.Ellipse_xs + zw(1);
%     tempys = C.Ellipse_ys + zw(2);
%     corners(ii,:) = [min(tempxs) max(tempxs) min(tempys) max(tempys)];
% %     if get(handles.checkbox_useSimpleMasks,'Value')
% %         tMasks = find_masks(handles,thisFrame);
% %     else
% %         tMasks = get_masks_KNN(handles,fn);
% %     end
% % %     tMasks = get_masks_KNN(handles,fn);
% %     Cs = [];
% %     C = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
%     if ~isempty(C)
%         indexC = strfind(tags,'Subject');
%         tag = find(not(cellfun('isempty', indexC)));
%         Rb = [Rb;[fn tag(1) C.Centroid(1)+zw(1) C.Centroid(2)+zw(2) 0]];
%         indexC = strfind(tags,'Subject Props');
%         tag = find(not(cellfun('isempty', indexC)));
%         Rb = [Rb;[fn tag C.MajorAxisLength C.MinorAxisLength C.Orientation]];
%     else
%         display(sprintf('Could not find for frame %d',fn));
%     end
%     displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',ii,fn,length(frameNums),getTimeRemaining(length(frameNums),ii)));
% end
% % close(hWaitBar);
% if ~isempty(Rb)
%     M.R = [M.R;Rb];
%     handles.md.resultsMF.R = M.R;
% else
%     return;
% end
% if sfn==efn
%     fn = round(get(handles.slider1,'Value'));
%     displayFrames(handles,fn,sfn);
% else
%     displayFrames(handles,sfn);
% end
% disp('Done with body fit');
% displayMessage(handles,sprintf('Done processing frames from %d to %d',sfn,sfn+ii-1));
% zoomWindow = floor([min(corners(:,1)) min(corners(:,3)) max(corners(:,2)) max(corners(:,4))])+[-50 -50 50 50];
% if zoomWindow(1) < 1
%     zoomWindow(1) = 1;
% end
% if zoomWindow(2) < 1
%     zoomWindow(2) = 1;
% end
% if zoomWindow(3) > handles.md.frameSize(2)
%     zoomWindow(3) = handles.md.frameSize(2);
% end
% if zoomWindow(4) > handles.md.frameSize(1)
%     zoomWindow(4) = handles.md.frameSize(1);
% end
% setParameter(handles,'Auto Zoom Window',zoomWindow);
% 
% 
