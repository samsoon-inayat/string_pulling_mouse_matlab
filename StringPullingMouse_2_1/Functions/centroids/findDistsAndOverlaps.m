function [dists,overlaps] = findDistsAndOverlaps(M,thisFrame,s1,s2)
dists = [];
overlaps = [];
for ii = 1:length(s1)
    centroid1 = s1(ii).Centroid;
    pixelInds1 = s1(ii).PixelIdxList;
    for jj = 1:length(s2)
        centroid2 = s2(jj).Centroid;
        dists(ii,jj) = sqrt(sum(((centroid2 - centroid1).^2)));
        pixelInds2 = s2(jj).PixelIdxList;
        overlaps(ii,jj) = length(intersect(pixelInds1,pixelInds2))/(length(pixelInds1)+length(pixelInds2)-length(intersect(pixelInds1,pixelInds2)));
    end
end