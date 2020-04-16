function plotStringAndRegions(fn,thisFrame,masks,M,s,Cs)
if ~isempty(Cs)
%     earsC = Cs{2};
%     xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
%     xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);
    Cm = Cs{1};
end

colors = {'m','c','y','r'};
% figure(fn);clf;
axes(M.axes_main);cla;
try
try
    chs = masks.Is;
catch
    masks = M.masks;
%     chs = masks.Is;
end
catch
end
% chs = bwconvhull(chs,'objects');
% chs = bwfill(chs);
if isempty(thisFrame)
    thisFrame = M.thisFrame;
end
imagesc(thisFrame);
hold on;
% if ~isempty(Cs)
%     plot(xrp,yrp,'*m');
%     plot(xlp,ylp,'*m');
% end

if ~iscell(s)
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
else
    alls = s;
    for jj = 1:length(alls)
        s = alls{jj};
        for ii = 1:length(s)
            thisS = s(ii);
            if ~isfield(thisS,'PixelList')
                [PixelList(:,2),PixelList(:,1)] = ind2sub(size(thisFrame(:,:,1)),thisS.PixelIdxList);
                thisS.PixelList = PixelList;%[PixelList(:,1)+M.zw(2) PixelList(:,2)+M.zw(1)];
            end
            xs = thisS.PixelList(:,1);
            ys = thisS.PixelList(:,2);
        %     plot(xs,ys,'color',colors{ii});
            plot(xs,ys,'color',colors{jj});
            xs = thisS.Centroid(1);
            ys = thisS.Centroid(2);
            plot(xs,ys,'.b');
            text(xs,thisS.PixelList(end,2)+5,num2str(ii),'color','w');%colors{jj});
            text(xs,thisS.PixelList(end,2)-15,num2str(thisS.Area),'color','w');%colors{jj});
%             xs = thisS.WeightedCentroid(1);
%             ys = thisS.WeightedCentroid(2);
%             plot(xs,ys,'*k');
        end
    end
end

titleText = [];
for ii = 1:length(colors)
    titleText = [titleText sprintf(' %s',colors{ii})];
end
title(titleText);
axis equal;

if ~isempty(Cs)
    bCy = Cm.Centroid(2);
    topOfEllipse = min(Cm.yb);
    numberOfPixelsFromAbove = abs(topOfEllipse-bCy)/2.5;
    yTa = topOfEllipse + numberOfPixelsFromAbove;
    xs = 1:size(Cm.In,2);
    ys = ones(size(xs))*yTa;
    plot(xs,ys,'r');
end

% var = [];
% for ii = 1:length(s)
%     thisS = s(ii);
% %     thisVar = sqrt(sum((thisS.Centroid - thisS.WeightedCentroid).^2));
%     thisVar = thisS.Extent;
%     var = [var;thisVar];
% end
% var