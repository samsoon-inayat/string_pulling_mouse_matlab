function mask = make_mask_from_region_pixels(C,varargin)

mask = zeros(size(C.In));
mask(C.PixelIdxList) = 1;

