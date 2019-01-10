function mask = compute_masks_KNN(handles,frame,object)
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
% rgbFrame = double(frame);
% typeParamName = {'Hands Diff Color', 'String Diff Color', 'Hands-String Diff Color'};
if strcmp(object,'body')
    mouseColors = getParameter(handles,'Fur Color');
    mc = mouseColors(:,colorCols);
    Im = getThisMask(hsvFrame,mc,nrows,ncols,500);
    Im = imfill(Im);
    Im = bwareaopen(Im,100);
    sm = regionprops(Im,'centroid','area','PixelIdxList','BoundingBox');
    for ii = 1:length(sm)
        areasM(ii) = sm(ii).Area;
    end
    areasM = areasM * handles.md.resultsMF.scale;
    inds = find(areasM>350);
    maskTemp = zeros(size(Im));
    for ii = 1:length(inds)
        maskTemp(sm(inds(ii)).PixelIdxList) = 1;
    end
    Im = logical(maskTemp);
    mask = Im;
end
if strcmp(object,'ears')
    earColors = getParameter(handles,'Ear Color');
    ec = earColors(:,colorCols);
    Ie = getThisMask(hsvFrame,(ec),nrows,ncols,500);
    Ie = imfill(Ie);
    Ie = bwareaopen(Ie,100);
    mask = Ie;
end
if strcmp(object,'hands')
    handColors = getParameter(handles,'Hands Color');
    hc = handColors(:,colorCols);
    Ih = getThisMask(hsvFrame,findValsAroundMean(hc),nrows,ncols,500);
    Ih = imfill(Ih);
    Ih = bwareaopen(Ih,100);
    mask = Ih;
end
if strcmp(object,'string')
    stringColors = getParameter(handles,'String Color');
    sc = stringColors(:,colorCols);
    Is = getThisMask(hsvFrame,findValsAroundMean(sc),nrows,ncols,500);
    Is = imfill(Is);
    Is = bwareaopen(Is,100);
    mask = Is;
end

if strcmp(object,'handsb')
    handColors = getParameter(handles,'Hands Diff Color');
    hc = handColors(:,colorCols);
    Ih = getThisMask(hsvFrame,findValsAroundMean(hc),nrows,ncols,500);
    Ih = imfill(Ih);
    Ih = bwareaopen(Ih,100);
    mask = Ih;
end
if strcmp(object,'handsf')
    handColors = getParameter(handles,'Hands Diff Color');
    hc = handColors(:,colorCols);
    Ih = getThisMask(hsvFrame,findValsAroundMean(hc),nrows,ncols,500);
    Ih = imfill(Ih);
    Ih = bwareaopen(Ih,100);
    mask = Ih;
end
