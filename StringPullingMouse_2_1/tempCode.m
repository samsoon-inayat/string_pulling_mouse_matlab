

[regions_f,rrs] = detectMSERFeatures(I,'ThresholdDelta',0.5);
mask_r = makeMaskFromRegions(handles,thisFrame,rrs);
temp = mask_r & masks.cIn & masks.Ih;
temp = imfill(temp,'holes');
temp = bwareaopen(temp,100);
temp = bwconvhull(temp,'objects');

mask_r1 = temp;