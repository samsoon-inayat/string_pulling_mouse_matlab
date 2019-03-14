function [so,sC] = combineRegions(s,inds,frameSize)

mask = zeros(frameSize);  
for ii=1:length(inds)
    mask(s(inds(ii)).PixelIdxList) = 1;
end

mask = bwconvhull(mask);
so = findRegions(mask);

% CC_mask = bwconncomp(mask,8);
% so = regionprops(CC_mask,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
%     'Orientation','Extrema');
% if isfield(s,'xb')
%     so = findBoundary(so,frameSize);
% end
sC = so;
oinds = setxor(1:length(s),inds);

for ii = 1:length(oinds)
    so(ii+1) = s(oinds(ii));
end
