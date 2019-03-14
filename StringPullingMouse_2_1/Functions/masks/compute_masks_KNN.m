function mask = compute_masks_KNN(handles,frame,object)

MMT = str2double(get(handles.edit_mouseMaskTol,'String'));
if get(handles.checkbox_useSimpleMasks,'Value')
    sm = 1;
    rgb = 0;
else
    sm = 0;
    rgb = 1;
end

if rgb
    colorCols = 4:6;
    hsvFrame = frame;
else
    colorCols = 1:3;
    hsvFrame = rgb2hsv(frame);
%     hsvFrame = rgb2hsv(hsvFrame);
end
nrows = size(frame,1);
ncols = size(frame,2);
numberOfPoints = 300;
% rgbFrame = double(frame);
% typeParamName = {'Hands Diff Color', 'String Diff Color', 'Hands-String Diff Color'};
if strcmp(object,'body')
%     mouseColors = getColors(handles,'Fur',colorCols);
    mc = getColors(handles,'Fur',colorCols);%mouseColors(:,colorCols);
    mcm = findValsAroundMean(mc,[MMT 10]);
%     hsvFrame = imgaussfilt(hsvFrame,5);
    if sm
        mouseColors = getOldColorFormat(mouseColors,0);
        Im = zeros(size(hsvFrame(:,:,1)));
        for ii = 1:size(mcm,1)
%             Im = colorDetectHSV(rgb2hsv(hsvFrame),mouseColors(1,:),MMT*mouseColors(2,:));
            Im = Im | colorDetectHSV(rgb2hsv(hsvFrame),mcm(ii,:),MMT*mouseColors(2,:));
        end
    else
        Im = getThisMask(hsvFrame,mc,nrows,ncols,numberOfPoints);
    end
    
%     Im = imfill(Im);
%     Im = bwareaopen(Im,100);
%     sm = regionprops(Im,'centroid','area','PixelIdxList','BoundingBox');
%     for ii = 1:length(sm)
%         areasM(ii) = sm(ii).Area;
%     end
%     areasM = areasM * getParameter(handles,'Scale');
%     inds = find(areasM>350);
%     maskTemp = zeros(size(Im));
%     for ii = 1:length(inds)
%         maskTemp(sm(inds(ii)).PixelIdxList) = 1;
%     end
%     Im = logical(maskTemp);
    mask = Im;
end
% if strcmp(object,'right ear')
if strcmp(object,'ears')
%     earColors = getParameter(handles,'Right Ear Color');
%     earColors = getParameter(handles,'Ears Color');
    ec = getColors(handles,'Ears',colorCols);%earColors(:,colorCols);
%     hsvFrame = imsharpen(hsvFrame,'Radius',10);
    if sm
        earColors = getOldColorFormat(earColors,0);
        Ie = colorDetectHSV(rgb2hsv(hsvFrame),earColors(1,:),MMT*earColors(2,:));
    else
        Ie = getThisMask(hsvFrame,(ec),nrows,ncols,numberOfPoints);
    end
%     Ie = imfill(Ie);
%     Ie = bwareaopen(Ie,100);
    mask = Ie;
end

if strcmp(object,'hands')
%     handColors = getParameter(handles,'Hands Color');
    hc = getColors(handles,'hands',colorCols);%handColors(:,colorCols);
%     Ih = getThisMask(hsvFrame,findValsAroundMean(hc),nrows,ncols,numberOfPoints);
    if sm
        handColors = getOldColorFormat(handColors,0);
        Ih = colorDetectHSV(rgb2hsv(hsvFrame),handColors(1,:),MMT*handColors(2,:));
    else
        Ih = getThisMask(hsvFrame,hc,nrows,ncols,numberOfPoints);
    end
%     Ih = imfill(Ih);
%     Ih = bwareaopen(Ih,100);
    mask = Ih;
end
if strcmp(object,'string')
    stringColors = getParameter(handles,'String Color');
    sc = getColors(handles,'String',colorCols);
%     Is = getThisMask(hsvFrame,findValsAroundMean(sc),nrows,ncols,numberOfPoints);
    if sm
        stringColors = getOldColorFormat(stringColors,0);
        Is = colorDetectHSV(rgb2hsv(hsvFrame),stringColors(1,:),MMT*stringColors(2,:));
    else
        Is = getThisMask(hsvFrame,sc,nrows,ncols,numberOfPoints);
    end
%     Is = imfill(Is);
%     Is = bwareaopen(Is,100);
    mask = Is;
end

if strcmp(object,'handsb')
    handColors = getParameter(handles,'Hands Diff Color');
    hc = handColors(:,colorCols);
    Ih = getThisMask(hsvFrame,findValsAroundMean(hc),nrows,ncols,numberOfPoints);
%     Ih = imfill(Ih);
%     Ih = bwareaopen(Ih,100);
    mask = Ih;
end
if strcmp(object,'handsf')
    handColors = getParameter(handles,'Hands Diff Color');
    hc = handColors(:,colorCols);
    Ih = getThisMask(hsvFrame,findValsAroundMean(hc),nrows,ncols,numberOfPoints);
%     Ih = imfill(Ih);
%     Ih = bwareaopen(Ih,100);
    mask = Ih;
end

if strcmp(object,'nose')
    mc = getColors(handles,'Nose',colorCols);%mouseColors(:,colorCols);
    mcm = findValsAroundMean(mc,[MMT 10]);
    if sm
        mouseColors = getOldColorFormat(mouseColors,0);
        Im = zeros(size(hsvFrame(:,:,1)));
        for ii = 1:size(mcm,1)
%             Im = colorDetectHSV(rgb2hsv(hsvFrame),mouseColors(1,:),MMT*mouseColors(2,:));
            Im = Im | colorDetectHSV(rgb2hsv(hsvFrame),mcm(ii,:),MMT*mouseColors(2,:));
        end
    else
        Im = getThisMask(hsvFrame,mc,nrows,ncols,numberOfPoints);
    end
    mask = Im;
end
