function s = selectAreas(thisFrame,s,Cs)

hf = figure(20000);clf
pos = get(hf,'Position');
pos(3) = 800;pos(4) = 800;
pos = [50 50 800 800];
set(hf,'Position',pos);
plotRegions(2000,thisFrame,s,Cs);
text(50,50,'Click inside Right Hand region','FontSize',14,'FontWeight','Bold','color','w');
set(hf,'WindowStyle','modal');
[x,y] = ginput(1);
set(hf,'WindowStyle','normal');
for ii = 1:length(s)
    thisS = s(ii);
    frameMask = zeros(size(thisFrame,1),size(thisFrame,2));
    frameMask(thisS.PixelIdxList) = 1;
    bnd = bwboundaries(frameMask);
    xs = bnd{1}(:,2);
    ys = bnd{1}(:,1);
    In = inpolygon(x,y,xs,ys);
    if In == 1
        s(ii).Hand = 'Right Hand';
        if ii == 1
            s(2).Hand = 'Left Hand';
        else
            s(1).Hand = 'Left Hand';
        end
        break;
    end
    n = 0;
end
close(hf);




function plotRegions(fn,thisFrame,s,Cs)

earsC = Cs{2};
xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);

colors = {'m','c','y','r'};


% chs = bwfill(chs);
if isempty(thisFrame)
    thisFrame = masks.thisFrame;
end
imagesc(thisFrame);
hold on;
plot(xrp,yrp,'*c');
plot(xlp,ylp,'*m');


for ii = 1:length(s)
    thisS = s(ii);
    frameMask = zeros(size(thisFrame,1),size(thisFrame,2));
    frameMask(thisS.PixelIdxList) = 1;
    bnd = bwboundaries(frameMask);
    xs = bnd{1}(:,2);
    ys = bnd{1}(:,1);
    plot(xs,ys,'color','w');
    xs = thisS.Centroid(1);
    ys = thisS.Centroid(2);
    plot(xs,ys,'.w');
    text(thisS.PixelList(end,1),thisS.PixelList(end,2)+5,num2str(ii),'color','r','FontSize',12,'FontWeight','bold');
end
axis equal;
C = Cs{1};
plot(C.Major_axis_xs,C.Major_axis_ys,'g');
plot(C.Minor_axis_xs,C.Minor_axis_ys,'g');
plot(C.Ellipse_xs,C.Ellipse_ys,'g');
