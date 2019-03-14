function [dists,overlaps,bdists,dAs,dxs,dys] = findDistsAndOverlaps(M,thisFrame,s1,s2)
frameSize = size(thisFrame(:,:,1));
s1 = findBoundary(s1,frameSize);
s2 = findBoundary(s2,frameSize);

dists = [];
overlaps = [];
bdists = [];
for ii = 1:length(s1)
    centroid1 = s1(ii).Centroid;
    pixelInds1 = s1(ii).PixelIdxList;
    s1Points = [s1(ii).xb s1(ii).yb];
    for jj = 1:length(s2)
        centroid2 = s2(jj).Centroid;
        dxs(ii,jj) = centroid1(1) - centroid2(1);
        dys(ii,jj) = centroid1(2) - centroid2(2);
        dists(ii,jj) = sqrt(sum(((centroid2 - centroid1).^2)));
        pixelInds2 = s2(jj).PixelIdxList;
        overlaps(ii,jj) = length(intersect(pixelInds1,pixelInds2))/(length(pixelInds1)+length(pixelInds2)-length(intersect(pixelInds1,pixelInds2)));
        dAs(ii,jj) = length(pixelInds1) - length(pixelInds2);
        tbdists = [];
        for kk = 1:length(s2(jj).xb)
            p1 = [s2(jj).xb(kk) s2(jj).yb(kk)];
            tbdists(kk) = min(sqrt(sum((s1Points - p1).^2,2)));
        end
        bdists(ii,jj) = min(tbdists);
    end
end
