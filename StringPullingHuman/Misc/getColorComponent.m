function fng = getColorComponent(fn,ic)

if strcmp(ic,'R')
    ind = 1;
end
if strcmp(ic,'G')
    ind = 2;
end
if strcmp(ic,'B')
    ind = 3;
end

nrows = size(fn{1},1);
ncols = size(fn{1},2);
nFrames = length(fn);
fng = zeros(nrows,ncols,nFrames);
for ii = 1:length(fn)
    fng(:,:,ii) = fn{ii}(:,:,ind);
end