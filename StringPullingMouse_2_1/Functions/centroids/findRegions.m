function [s so] = findRegions(M,Cs,masks,iThisFrame,thisMask)


% Cm = Cs{1};
% tF = zeros(size(iThisFrame));
% [allxs,allys] = meshgrid(1:size(tF,2),1:size(tF,1));
% In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);
% startingVal = 0.95;
% cIn = expandOrCompressMask(In,startingVal);
chs = thisMask & masks.cIn;
chs = bwconvhull(chs,'objects');
% s = regionprops(chs,iThisFrame,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
%     'Orientation','WeightedCentroid','Perimeter','EulerNumber','Eccentricity','Extent','Extrema');

so = regionprops(chs,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema');
s = so;
% s = selectAppropriateRegions(M,Cs,masks,so);

