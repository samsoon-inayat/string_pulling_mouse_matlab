function C = find_centroids_coincident(M,s,cr,cl)
tC = s;
% thetad = tC.Orientation;
% Major_axis_xs = tC.Major_axis_xs;
% Major_axis_ys = tC.Major_axis_ys;
allPixels = tC.PixelList;
allPixelsIdx = tC.PixelIdxList;
% here I am dividing the two halves of common ROI into left and right hands
Minor_axis_xs = tC.Minor_axis_xs;
Minor_axis_ys = tC.Minor_axis_ys;
for ii = 1:size(allPixels,1)
    thisPoint = allPixels(ii,:);
    d = (thisPoint(1)-Minor_axis_xs(1))*diff(Minor_axis_ys)-(thisPoint(2)-Minor_axis_ys(1))*diff(Minor_axis_xs);
    if d < 0
        side(ii) = 0;
    else
        side(ii) = 1;
    end
end

zPLi = allPixelsIdx(side==0,:);
oPLi = allPixelsIdx(side==1,:);


mask = zeros(M.sizeMasks);
mask(zPLi) = 1;
mask = bwconvhull(mask,'objects');
vals = sum(mask(:));
try
    maskec = expandOrCompressMask(mask,0.9);
    if sum(maskec(:)) > floor(vals/2)
        mask = maskec;
    end
catch
%     mask = expandOrCompressMask(mask,0.95);
end
temp1 = findRegions(mask);
temp1 = findBoundary(temp1,size(mask));

mask = zeros(M.sizeMasks);
mask(oPLi) = 1;
mask = bwconvhull(mask,'objects');
vals = sum(mask(:));
try
    maskec = expandOrCompressMask(mask,0.9);
    if sum(maskec(:)) > floor(vals/2)
        mask = maskec;
    end
catch
%     mask = expandOrCompressMask(mask,0.95);
end
temp2 = findRegions(mask);
temp2 = findBoundary(temp2,size(mask));

C(1) = temp1;
C(2) = temp2;


% 
% if thetad > 80 & exist('cr','var')
%     if cl(2) > cr(2)
%         ind = find(Major_axis_ys == max(Major_axis_ys));
%         C(1).Centroid(1) = Major_axis_xs(ind);
%         C(1).Centroid(2) = Major_axis_ys(ind);
% %         C(1).Hand = 'Left Hand';
%         ind = find(Major_axis_ys == min(Major_axis_ys));
%         C(2).Centroid(1) = Major_axis_xs(ind);
%         C(2).Centroid(2) = Major_axis_ys(ind);
% %         C(2).Hand = 'Right Hand';
%     else
%         ind = find(Major_axis_ys == max(Major_axis_ys));
%         C(1).Centroid(1) = Major_axis_xs(ind);
%         C(1).Centroid(2) = Major_axis_ys(ind);
% %         C(1).Hand = 'Right Hand';
%         ind = find(Major_axis_ys == min(Major_axis_ys));
%         C(2).Centroid(1) = Major_axis_xs(ind);
%         C(2).Centroid(2) = Major_axis_ys(ind);
% %         C(2).Hand = 'Left Hand';
%     end
%     
%     minC1x = min(C(1).PixelList(:,1)); maxC1x = max(C(1).PixelList(:,1));
%     minC1y = min(C(1).PixelList(:,2)); maxC1y = max(C(1).PixelList(:,2));
%     
%     xc = C(1).Centroid(1); yc = C(1).Centroid(2);
%     if xc > minC1x & xc < maxC1x & yc > minC1y & yc < maxC1y
%     else
%         temp = C(1).Centroid;
%         C(1).Centroid = C(2).Centroid;
%         C(2).Centroid = temp;
%     end
%     return;
% end
% ind = find(Major_axis_xs == max(Major_axis_xs));
% C(1).Centroid(1) = Major_axis_xs(ind);
% C(1).Centroid(2) = Major_axis_ys(ind);
% % C(1).Hand = 'Left Hand';
% ind = find(Major_axis_xs == min(Major_axis_xs));
% C(2).Centroid(1) = Major_axis_xs(ind);
% C(2).Centroid(2) = Major_axis_ys(ind);
% % C(2).Hand = 'Right Hand';
% 
% minC1x = min(C(1).PixelList(:,1)); maxC1x = max(C(1).PixelList(:,1));
% minC1y = min(C(1).PixelList(:,2)); maxC1y = max(C(1).PixelList(:,2));
% 
% xc = C(1).Centroid(1); yc = C(1).Centroid(2);
% if xc > minC1x & xc < maxC1x & yc > minC1y & yc < maxC1y
% else
%     temp = C(1).Centroid;
%     C(1).Centroid = C(2).Centroid;
%     C(2).Centroid = temp;
% end



