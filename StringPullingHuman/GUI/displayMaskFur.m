function displayMaskFur(handles,fn)
frames = get_frames(handles);
thisFrame = frames{fn};
if isempty(thisFrame)
    return;
end
zw = getParameter(handles,'Zoom Window');
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
try
    mask = find_mask_fur_global(handles,thisFrame);
%     mask = compute_masks_KNN(handles,thisFrame,'background',1);
%     mask = compute_masks_KNN(handles,thisFrame,'body',1);
catch Err
    display('Could not compute masks ... check if colors are selected for body parts or select different thresholds');
    rethrow(Err);
    return;
end

% L = superpixels(thisFrame,500);
% [featureVector,hogVisualization] = extractHOGFeatures(thisFrame);
% 
% BW = graphcuts(rgb2gray(thisFrame),3,255);
rows = 1; cols = 2;
hf = figure(100);clf;
set(hf,'Name','Masks Window');
subplot(rows,cols,1);
imagesc(thisFrame);axis equal;
title(fn);
subplot(rows,cols,2);

imagesc(mask);axis equal;
% colorbar
title('Body');

