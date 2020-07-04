function mask = makeMaskFromRegions(handles,thisFrame,cc,varargin)

if isfield(cc,'Area')
    mask = zeros(size(cc(1).In));
    for i=1:length(cc)
        thesePixels = cc(i).PixelIdxList;
        mask(thesePixels) = 1;
    end
    return;
end


if nargin == 3
    colorVals = getParameter(handles,'Hands Color');
    colorVals = colorVals(:,4:6);
else
    colorVals = getParameter(handles,'Hands Color Backward Difference');
    colorVals = colorVals(:,4:6);
end

ED_th = getParameter(handles,'Eucledian Distance Threshold');

mask = zeros(cc.ImageSize);  
for i=1:cc.NumObjects
    thesePixels = cc.PixelIdxList{i};
    rFrame = thisFrame(:,:,1);
    gFrame = thisFrame(:,:,2);
    bFrame = thisFrame(:,:,3);
    pixelColors = [rFrame(thesePixels) gFrame(thesePixels) bFrame(thesePixels)];
    dists = [];
    for jj = 1:size(pixelColors,1)
        thisPixel = double(pixelColors(jj,:));
        dists(jj) = min(sqrt(sum((colorVals - thisPixel).^2,2)));
    end
    inds = dists < ED_th;
    if sum(inds) > 0
        mask(thesePixels(inds)) = 1;
    end
end


% figure(10);clf;
% plot3(pixelColors(:,1),pixelColors(:,2),pixelColors(:,3),'b.');hold on;
% plot3(colorVals(:,1),colorVals(:,2),colorVals(:,3),'r.');