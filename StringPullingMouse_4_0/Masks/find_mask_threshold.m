function mask = find_mask_threshold(frame,nstd)

if exist('nstd','var')
    mdF = mean(frame(:)); sdF = std(frame(:));
    uT = mdF + nstd*sdF; lT = mdF - nstd*sdF;
else
    uT = graythresh(frame);
    lT = uT;
    nstd = 1;
end


mask = zeros(size(frame));
% mask(frame<uT) = 0;
if nstd > 0
    mask(frame>uT) = 1;
else
    mask(frame<lT) = 1;
end
