function Ih = find_masks_hand (handles,frame)
% hsvMean = selectPixelsAndGetHSV(frame(425:600,150:325,:),5)
HMT = str2num(get(handles.edit_handMaskTol,'String'));

hsvFrame = rgb2hsv(frame);
rgbFrame = double(frame);


handColors = getParameter(handles,'Hands Color');
% handColors = getOldColorFormat(handColors);
hc = handColors(:,4:6);

nrows = size(frame,1);
ncols = size(frame,2);
% Ih = colorDetectHSV(rgbFrame,handColors(3,:),3*handColors(4,:));
Ih = getThisMask(frame,hc,nrows,ncols,500);
% Ih = compute_masks_KNN(handles,rgbFrame,'hands');
% Ih = imfill(Ih);
% Ih = bwareaopen(Ih,100);
