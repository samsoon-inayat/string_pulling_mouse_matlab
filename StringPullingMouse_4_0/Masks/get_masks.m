function fng = get_masks(fn,colors,method)

nrows = size(fn{1},1);
ncols = size(fn{1},2);
nFrames = length(fn);
fng = zeros(nrows,ncols,nFrames);
for ii = 1:length(fn)
    fng(:,:,ii) = getThisMask(fn{ii},colors,nrows,ncols,1.5);
end