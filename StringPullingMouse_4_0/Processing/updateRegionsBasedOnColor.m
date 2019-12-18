function s = updateRegionsBasedOnColor(handles,M,s,object)
colorVals = getParameter(handles,sprintf('%s Color',object));
colorVals = colorVals(:,4:6);
thisFrame = M.thisFrame;
mask = zeros(M.sizeMasks);
ED_th = 3;
for ii = 1:length(s)
    thesePixels = s(ii).PixelIdxList;
    rFrame = thisFrame(:,:,1);
    gFrame = thisFrame(:,:,2);
    bFrame = thisFrame(:,:,3);
    pixelColors = [rFrame(thesePixels) gFrame(thesePixels) bFrame(thesePixels)];
    dists = [];
    for jj = 1:size(pixelColors,1)
        thisPixel = double(pixelColors(jj,:));
        dists(jj) = min(sqrt(sum((colorVals - thisPixel).^2,2)));
    end
    inds = dists < ED_th;
    if sum(inds) > 0
        mask(thesePixels(inds)) = 1;
    end
end

mask = bwareaopen(mask,20);
figure(1000);clf;imagesc(mask);
B = bwboundaries(mask);
P = [];
for ii = 1:length(B)
    P = [P;B{ii}];
end

shp = alphaShape(fliplr(P));
[bf,P1] = boundaryFacets(shp);
k = boundary(P1(:,1),P1(:,2),1);
figure(1000);clf;imagesc(mask);axis equal;axis off;hold on; plot(P1(k,1),P1(k,2),'r')

[X,Y] = meshgrid(1:M.sizeMasks(1),1:M.sizeMasks(2));
[in,on] = inpolygon(X,Y,P1(k,1),P1(k,2));

s = findRegions(in,1);
areas = getRegionValues(s,'Area');
s = s(areas == max(areas));