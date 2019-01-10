function displayMaskFur(handles,fn)
global frames;
thisFrame = frames{fn};
if isempty(thisFrame)
    return;
end
zw = handles.md.resultsMF.zoomWindow;
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
try
    mask = find_mask_fur_global(handles,thisFrame);
catch Err
%     rethrow(Err);
    display('Could not compute masks ... check if colors are selected for body parts or select different thresholds');
    return;
end

% L = superpixels(thisFrame,500);
% [featureVector,hogVisualization] = extractHOGFeatures(thisFrame);
% 
% BW = graphcuts(rgb2gray(thisFrame),3,255);
rows = 1; cols = 2;
hf = figure(1000);clf;
set(hf,'Name','Masks Window');
subplot(rows,cols,1);
imagesc(thisFrame);axis equal;
title(fn);
subplot(rows,cols,2);

imagesc(mask);axis equal;
title('Body');
hold on;
C = find_centroids_fur(mask);
plot(C.Ellipse_xs,C.Ellipse_ys,'g');
n = 0;
