function mask = makeMaskFromRegions(handles,thisFrame,cc)

handsColor = getParameter(handles,'Hands Color');
handsColor = handsColor(:,4:6);

ED_th = getParameter(handles,'Eucledian Distance Threshold');

mask = zeros(cc.ImageSize);  
for i=1:cc.NumObjects
    thesePixels = cc.PixelIdxList{i};
    rFrame = thisFrame(:,:,1);
    gFrame = thisFrame(:,:,2);
    bFrame = thisFrame(:,:,3);
    pixelColors = [rFrame(thesePixels) gFrame(thesePixels) bFrame(thesePixels)];
    dists = [];
    for jj = 1:size(pixelColors,1)
        thisPixel = double(pixelColors(jj,:));
        dists(jj) = min(sqrt(sum((handsColor - thisPixel).^2,2)));
    end
    inds = dists < ED_th;
    if sum(inds) > 0
        mask(thesePixels(inds)) = 1;
    end
end


% figure(10);clf;
% plot3(pixelColors(:,1),pixelColors(:,2),pixelColors(:,3),'b.');hold on;
% plot3(handsColor(:,1),handsColor(:,2),handsColor(:,3),'r.');