function mask = compute_masks_KNN_hands(handles,frame)
rgb = 1;
if rgb
    colorCols = 4:6;
    hsvFrame = frame;
else
    colorCols = 1:3;
    hsvFrame = rgb2hsv(frame);
    hsvFrame = rgb2hsv(hsvFrame);
end
nrows = size(frame,1);
ncols = size(frame,2);

handColors = getParameter(handles,'Hands Color');
hc = handColors(:,colorCols);
mask = getThisMask(hsvFrame,findValsAroundMean(hc),nrows,ncols,100);
% Ih = imfill(Ih);
% Ih = bwareaopen(Ih,100);
% mask = Ih;

