function mask = makeMaskFromRegions(cc)
mask = zeros(cc.ImageSize);  
for i=1:cc.NumObjects
    if length(cc.PixelIdxList{i}) > 200
        mask(cc.PixelIdxList{i}) = 1;
    end
end