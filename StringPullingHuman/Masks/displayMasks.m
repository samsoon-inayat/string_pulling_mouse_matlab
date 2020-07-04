
function displayMasks(handles,fn,allCs)
frames = get_frames(handles);
zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;
thisFrame = frames{fn};
if isempty(thisFrame)
    return;
end
if ~isempty(zw)
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
end
try
%     masksMap = {'body','ears','hands','nose','string','hands_bd','background'};
    tMasks = get_mask(handles,fn,[1 2 3 4 5]);
catch Err
%     rethrow(Err);
    display('Could not compute masks ... check if colors are selected for body parts or selected different thresholds');
    return;
end
rows = 2; cols = 3;
hf = figure(1000);clf;
add_window_handle(handles,hf);
set(hf,'Name','Masks Window');
subplot(rows,cols,1);
imagesc(thisFrame);axis equal;
title(fn);
subplot(rows,cols,2);
imagesc(tMasks(:,:,1));axis equal;%body
title('Body');
subplot(rows,cols,3);
imagesc(tMasks(:,:,2));axis equal;
title('Ears');
subplot(rows,cols,4);
imagesc(imoverlay(thisFrame,tMasks(:,:,3)));axis equal;
title('Hands');
subplot(rows,cols,5);
imagesc(imoverlay(thisFrame,tMasks(:,:,4)));axis equal;
title('Nose');
subplot(rows,cols,6);
imagesc(tMasks(:,:,5));axis equal;
title('String');

set(hf,'userdata',fn);
