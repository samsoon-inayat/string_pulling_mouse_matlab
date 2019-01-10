function mask = find_mask_1 (handles,frame,type)


temp = handles.md.resultsMF.diffColors(1,2);
stringColors = temp{1};
temp = handles.md.resultsMF.diffColors(1,1);
handColors = temp{1};
temp = handles.md.resultsMF.diffColors(1,3);
handStringColors = temp{1};
% colorsRGB{1} = stringColors(3,:); colorsRGB{2} = handColors(3,:);
% temp = handles.md.resultsMF.colors(1,2);
% mouseColors = temp{1};
% temp = handles.md.resultsMF.colors(1,4);
% earColors = temp{1};
hsvFrame = rgb2hsv(frame);
rgbFrame = double(frame);

vars = {'stringColors','handColors'};%,'handStringColors'};
for ii = 1:length(vars)
    cmdTxt = sprintf('thisSize = size(%s,1);',vars{ii});
    eval(cmdTxt);
    inds = randi([1 thisSize],1,floor(thisSize/4));
    cmdTxt = sprintf('%s = %s(inds,:);',vars{ii},vars{ii});
    eval(cmdTxt);
end

nrows = size(frame,1);
ncols = size(frame,2);
if strcmp(type,'hand')
    mask = getThisMask(rgbFrame,handColors(:,4:6),nrows,ncols);
%     mask = getThisMask(hsvFrame,handColors(:,1:3),nrows,ncols);
end

if strcmp(type,'handString')
    mask = getThisMask(rgbFrame,handStringColors(:,4:6),nrows,ncols);
%     mask = getThisMask(hsvFrame,handColors(:,1:3),nrows,ncols);
end


mask = imfill(mask);
mask = bwareaopen(mask,50);
mask = bwconvhull(mask,'objects');
n=0;
