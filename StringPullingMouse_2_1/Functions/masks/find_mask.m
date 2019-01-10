function mask = find_mask (handles,frame,type)


temp = handles.md.resultsMF.diffColors(1,2);
stringColors = getOldColorFormat(temp{1});
temp = handles.md.resultsMF.diffColors(1,1);
handColors = getOldColorFormat(temp{1});
temp = handles.md.resultsMF.diffColors(1,3);
handStringColors = getOldColorFormat(temp{1});
colorsRGB{1} = stringColors(3,:); colorsRGB{2} = handColors(3,:);
temp = handles.md.resultsMF.colors(1,2);
mouseColors = temp{1};
temp = handles.md.resultsMF.colors(1,4);
earColors = temp{1};
hsvFrame = rgb2hsv(frame);
rgbFrame = double(frame);

if strcmp(type,'hand')
    color = handColors(3,:);
    colorTol = handColors(4,:);
    mask = colorDetectHSV(rgbFrame,color,30*colorTol);
end

if strcmp(type,'handString')
    color = handStringColors(3,:);
    colorTol = handStringColors(4,:);
    mask = colorDetectHSV(rgbFrame,color,5*colorTol);
end


mask = imfill(mask);
mask = bwareaopen(mask,100);
mask = bwconvhull(mask,'objects');
n=0;
