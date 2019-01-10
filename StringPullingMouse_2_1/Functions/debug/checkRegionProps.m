function checkRegionProps(fn,thisFrame,masks,M,s)
colors = {'g','m','r','c','k','y'};
figure(fn);clf;
imagesc(thisFrame);
hold on;
for ii = 1:length(s)
    thisS = s(ii);
    xs = thisS.PixelList(:,1);
    ys = thisS.PixelList(:,2);
%     plot(xs,ys,'color',colors{ii});
    plot(xs,ys,'color','w');
    xs = thisS.Centroid(1);
    ys = thisS.Centroid(2);
    plot(xs,ys,'.b');
    text(xs,thisS.PixelList(end,2)+5,num2str(ii),'color','r');
    xs = thisS.WeightedCentroid(1);
    ys = thisS.WeightedCentroid(2);
    plot(xs,ys,'*k');
end
titleText = [];
for ii = 1:length(colors)
    titleText = [titleText sprintf(' %s',colors{ii})];
end
title(titleText);
axis equal;
var = [];
for ii = 1:length(s)
    thisS = s(ii);
%     thisVar = sqrt(sum((thisS.Centroid - thisS.WeightedCentroid).^2));
    thisVar = thisS.Extent;
    var = [var;thisVar];
end
var