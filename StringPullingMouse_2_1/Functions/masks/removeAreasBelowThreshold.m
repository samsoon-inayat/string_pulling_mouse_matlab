function maskTemp = removeAreasBelowThreshold(Im,scale,threshold)
CC_Im = bwconncomp(Im);
sm = regionprops(CC_Im,'area','PixelIdxList');
for ii = 1:length(sm)
    areasM(ii) = sm(ii).Area;
end
areasM = areasM * scale;
inds = find(areasM>threshold);
maskTemp = zeros(size(Im));
for ii = 1:length(inds)
    maskTemp(sm(inds(ii)).PixelIdxList) = 1;
end