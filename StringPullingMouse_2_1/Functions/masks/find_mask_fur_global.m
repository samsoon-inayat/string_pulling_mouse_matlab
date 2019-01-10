function Im = find_masks (handles,frame)
% hsvMean = selectPixelsAndGetHSV(frame(425:600,150:325,:),5)

MMT = str2double(get(handles.edit_mouseMaskTol,'String'));
hsvFrame = rgb2hsv(frame);
rgbFrame = double(frame);


mouseColors = getParameter(handles,'Fur Color');
mouseColors = getOldColorFormat(mouseColors,0);

if ~get(handles.text_fur,'userdata')
    Im = colorDetectHSV(rgb2hsv(hsvFrame),mouseColors(1,:),MMT*mouseColors(2,:));
%     masks.ImTitle = 'Fur HSV';
else
    Im = colorDetectHSV(rgbFrame,mouseColors(3,:),MMT*mouseColors(4,:));
%     masks.ImTitle = 'Fur RGB';
end
Im = imfill(Im);
Im = bwareaopen(Im,100);
Im = bwconvhull(Im,'objects',4);

