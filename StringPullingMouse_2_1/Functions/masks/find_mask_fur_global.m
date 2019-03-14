function mask = find_mask_fur_global (handles,frame)
% hsvMean = selectPixelsAndGetHSV(frame(425:600,150:325,:),5)

MMT = 5;%str2double(get(handles.edit_mouseMaskTol,'String'));
% EMT = str2double(get(handles.edit_earMaskTol,'String'));
EMT = MMT;
hsvFrame = rgb2hsv(frame);
rgbFrame = double(frame);


mouseColors = getParameter(handles,'Fur Color');
mouseColors = getOldColorFormat(mouseColors,0);
earColors = getParameter(handles,'Ears Color');
earColors = getOldColorFormat(earColors,0);


% if ~get(handles.text_fur,'userdata')
    Im = colorDetectHSV(rgb2hsv(hsvFrame),mouseColors(1,:),MMT*mouseColors(2,:));
    Ie = colorDetectHSV(rgb2hsv(hsvFrame),earColors(1,:),EMT*earColors(2,:));

%     masks.ImTitle = 'Fur HSV';
% else
%     Im = colorDetectHSV(rgbFrame,mouseColors(3,:),MMT*mouseColors(4,:));
%     Ie = colorDetectHSV(rgbFrame,earColors(3,:),EMT*earColors(4,:));
% %     masks.ImTitle = 'Fur RGB';
% end
mask = Im | Ie;% | Iel;
% Im = imfill(Im);
% Im = bwareaopen(Im,100);
% Im = bwconvhull(Im,'objects',4);

