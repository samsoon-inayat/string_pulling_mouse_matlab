function [hbs,myys] = plotBarsWithSigLines (means,sems,combs,sig,varargin)

p = inputParser;
default_maxY = max(means+sems);
default_colors = distinguishable_colors(20);
default_ySpacingFactor = 10;
addRequired(p,'means',@isnumeric);
addRequired(p,'sems',@isnumeric);
addRequired(p,'combs',@isnumeric);
addRequired(p,'sig',@isnumeric);
addOptional(p,'maxY',default_maxY,@isnumeric);
addOptional(p,'colors',default_colors,@iscell);
addOptional(p,'ySpacingFactor',default_ySpacingFactor,@isnumeric);
addOptional(p,'ySpacing',1,@isnumeric);
addOptional(p,'sigColor','k');
addOptional(p,'sigTestName','');
addOptional(p,'sigLineWidth',0.25);
addOptional(p,'sigAsteriskFontSize',5);
addOptional(p,'sigFontSize',5);
addOptional(p,'BaseValue',0.3);
addOptional(p,'barwidth',0.8);
addOptional(p,'sigLinesStartYFactor',0.1);
addOptional(p,'xdata',1:length(means));
parse(p,means,sems,combs,sig,varargin{:});

cols = p.Results.colors;
myy = p.Results.maxY;
maxY = default_maxY;
sigLinesStartYFactor = p.Results.sigLinesStartYFactor;
ySpacing = p.Results.ySpacing;
sigColor = p.Results.sigColor;
sigTestName = p.Results.sigTestName;
sigLineWidth = p.Results.sigLineWidth;
sigAsteriskFontSize = p.Results.sigAsteriskFontSize;
sigFontSize = p.Results.sigFontSize;
bv = p.Results.BaseValue;
xdata = p.Results.xdata;
xdatai = xdata;
barwidth = p.Results.barwidth;

hold on;
for ii = 1:length(xdata)
    hb = bar(xdata(ii),means(ii),'BaseValue',bv,'ShowBaseline','off','barwidth',barwidth);
    set(hb,'FaceColor',cols{ii},'EdgeColor',cols{ii});
%     xdata = get(hb,'XData');
%     dx = xdata(2) - xdata(1);
    errorbar(xdata(ii), means(ii), sems(ii), 'k', 'linestyle', 'none','CapSize',3);
    hbs(ii) = hb;
end
% xlim([0.5 length(means)+0.5]);

% xdata = 1:length(means);
dx = xdata(2) - xdata(1);

yl = get(gca,'YLim');

if size(sig,2) == 1
tSig = sig;
sig(:,1) = tSig<0.05;
sig(:,2) = tSig;
end

dy = (maxY-yl(1));
diffCombs  = combs(:,2) - combs(:,1);
maxdiff = max(combs(:,2) - combs(:,1));
numberOfSigLines = length(find(sig(:,1)));
if numberOfSigLines > 0
    fyy = maxY + sigLinesStartYFactor*(maxY-yl(1));
    fyy1 = maxY + 10*(maxY-yl(1));
%     sigLineWidth = 0.5;
%     ayy = fyy:((maxY-yl(1))/ySpacingFactor):fyy1;
    ayy = (fyy+(ySpacing/2)):ySpacing:fyy1;
%     myy = ayy(numberOfSigLines);
    count = 0;
    for ii = 1:maxdiff
        inds = find(diffCombs == ii);
        for jj = 1:length(inds)
            if ~sig(inds(jj),1)
                continue;
            end
            count = count + 1;
            yy = ayy(count); dy = ayy(2) - ayy(1);
            b1  = combs(inds(jj),1);
            b2  = combs(inds(jj),2);
            x1 = xdata(b1)+dx/40;
            x2 = xdata(b2)- dx/40;
            line([x1 x2], [yy yy],'linewidth',sigLineWidth,'color',sigColor);
            line([x1 x1], [yy-(ySpacing/3) yy],'linewidth',sigLineWidth,'color',sigColor);
            line([x2 x2], [yy-(ySpacing/3) yy],'linewidth',sigLineWidth,'color',sigColor);
%             if count == 1
%                 line([x1 x1], [means(b1)+sems(b1)+dy/15 yy],'linewidth',sigLineWidth,'color',sigColor);
%                 line([x2 x2], [means(b2)+sems(b2)+dy/15 yy],'linewidth',sigLineWidth,'color',sigColor);
%             else
%                 line([x1 x1], [ayy(count-1)+0.3*dy/10 yy],'linewidth',sigLineWidth,'color',sigColor);
%                 line([x2 x2], [ayy(count-1)+0.3*dy/10 yy],'linewidth',sigLineWidth,'color',sigColor);
%             end
            pvalue = sig(inds(jj),2);
            sigText = getNumberOfAsterisks(pvalue);
            xt1 = x1 + (x2-x1)/2;
            text(xt1,yy+dy/7,sigText,'FontSize',sigAsteriskFontSize,'HorizontalAlignment','center','Color',sigColor);
            all_yys(ii,jj) = yy;
        end
    end
    myys = max(all_yys(:));
    if myys > myy
        ylimvs = [yl(1) myys];
    else
        ylimvs = [yl(1) myy];
    end
%     ylimvs = [yl(1) myy];
    ylim(ylimvs);
    yt = ylimvs(2);
    xdata = xlim;
    ht = text(xdata(1)+(dx/2),yt,sigTestName,'FontSize',sigFontSize,'Color',sigColor);
    extent = get(ht,'Extent');
    total = xdata(end) - xdata(1);
    indent = (total - extent(3))/2;
    xt = xdata(1) + indent + total/10;
    set(ht,'Position',[xt yt 0]);
else
    myys = maxY;
    ylimvs = [yl(1) myy];
    ylim(ylimvs);
    yt = default_maxY + ((ylimvs(2)-ylimvs(1))/10);
    if isempty(xdatai)
        xdata = xlim;
    else
        if xdatai(1) > 1
            xdata = xdatai(1);
        else
            xdata = xdatai(2);
        end
    end
    ht = text(xdata(1)+(dx/2),yt,sprintf('%s',sigTestName),'FontSize',sigFontSize,'Color',sigColor);
    extent = get(ht,'Extent');
    total = xdata(end) - xdata(1);
    indent = (total - extent(3))/2;
    xt = xdata(1) + indent + total/10;
    set(ht,'Position',[xt yt 0]);
end

myys = 1.1*myys;