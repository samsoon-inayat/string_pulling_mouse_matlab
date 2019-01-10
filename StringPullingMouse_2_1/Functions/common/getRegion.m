function s = getRegion(M,fn,tagS)
[x y] = getxyFromR(M,fn,tagS);
if isempty(x)
    s = [];
    return;
end
x = x - M.zw(1);
y = y - M.zw(2);
s.Centroid = [x y];

if isempty(M.P)
    pixelsI = [];
end
indexC = strfind(M.tags,tagS);
tag = find(not(cellfun('isempty', indexC)));
Lia = ismember(M.P(:,[1 2]),[fn tag],'rows');
pixelsI = M.P(Lia,3);

[rr,cc] = ind2sub(M.frameSize,pixelsI);
x = cc - M.zw(1);
y = rr - M.zw(2);

mSize = [M.zw(4)-M.zw(2)+1 M.zw(3)-M.zw(1)+1];
BW = poly2mask(x,y,mSize(1),mSize(2));
s.PixelIdxList = find(BW);
[s.PixelList(:,2),s.PixelList(:,1)] = ind2sub(mSize,s.PixelIdxList);



