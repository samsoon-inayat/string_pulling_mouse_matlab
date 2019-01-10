function mask = find_mask_threshold(frame,nstd)

mdF = mean(frame); sdF = std(frame);
uT = mdF + nstd*sdF; lT = mdF - nstd*sdF;

mask = zeros(size(frame));
mask(frame<uT) = 0; mask(frame>uT) = 1;
