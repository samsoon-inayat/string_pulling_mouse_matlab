function mask = makeMaskFromRegions(cc)
mask = zeros(cc.ImageSize);  
for i=1:cc.NumObjects
    mask(cc.PixelIdxList{i}) = 1;
end