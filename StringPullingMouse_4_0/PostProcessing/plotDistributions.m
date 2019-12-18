function [hb,ha,hca,varargout] = plotDistributions (distD,varargin)

% use as follows
% [hb,hca] = plotDistributions(distD,'min',-140,'max',140,'incr',20,'colors',colors,'maxY',80,'cumPos',[0.5 0.35 0.3 0.3],'legend',legs);

hb = NaN;
hca = NaN;
allD = [];
for ii = 1:length(distD)
    allD = [allD distD{ii}];
end
maxB = ceil(max(allD));
minB = floor(min(allD));

p = inputParser;
default_colors = distinguishable_colors(20);
default_ySpacingFactor = 10;
addRequired(p,'distD',@iscell);
addOptional(p,'incr',inf,@isnumeric);
addOptional(p,'min',-inf,@isnumeric);
addOptional(p,'max',inf,@isnumeric);
addOptional(p,'colors',default_colors,@iscell);
addOptional(p,'maxY',100,@isnumeric);
addOptional(p,'cumPos',0,@isnumeric);
addOptional(p,'barGraph',{},@iscell);
addOptional(p,'legend',{},@iscell);
addOptional(p,'BaseValue',0.2,@isnumeric);
addOptional(p,'ks_tail','unequal');
parse(p,distD,varargin{:});

cols = p.Results.colors;
maxY = p.Results.maxY;
cumPos = p.Results.cumPos;
barGraph = p.Results.barGraph;
legs = p.Results.legend;
bv = p.Results.BaseValue;
ks_tail = p.Results.ks_tail;
% legs = temp(1:(end-1));
% specs = temp{end};

if p.Results.min ~= -inf
    minB = p.Results.min;
end

if p.Results.max ~= inf
    maxB = p.Results.max;
end

if p.Results.incr ~= inf
    incr = p.Results.incr;
else
    incr = ((maxB - minB)/20);
end



bins = (minB+incr):incr:(maxB-incr);
% else
%     bins = incr:incr:(maxB-incr);
% end

allBars = [];
for ii = 1:length(distD)
    bd = distD{ii};
    [bar1 xs] = hist(bd,bins); bar1 = 100*bar1/sum(bar1);
    allBars = [allBars;bar1];
end
hb = bar(xs,allBars');
for ii = 1:length(hb)
    set(hb(ii),'facecolor',cols{ii},'barwidth',0.7,'EdgeColor','none','BaseValue',bv,'ShowBaseline','off');
end
xlim([bins(1)-(incr/2) bins(end)+(incr/2)]);
ylim([0 maxY]);
set(gca,'TickDir','out','FontSize',7,'FontWeight','Normal','XTick',bins(1:2:end),'linewidth',0.5);
ha = gca;
% putLegend(gca,legs,specs,'colors',cols);
if length(cumPos) > 1
    pos = get(gca,'Position');
    axesPos = pos + [cumPos(1) cumPos(2) 0 0];
    axesPos(3:4) = [cumPos(3) cumPos(4)];
    hca = axes('Position',axesPos);hold on;
    xlims = xlim;
    for ii = 1:length(distD)
        cs = cumsum(allBars(ii,:));
        plot(xs,cs,'color',cols{ii},'linewidth',0.5);
    end
    xlim([bins(1)-(incr/2) bins(end)+(incr/2)]);
    ylim([0 100]);
    set(gca,'TickDir','out','FontSize',5,'FontWeight','Normal');
    xlims = xlim; dx = diff(xlims);
    text(xlims(1)+dx/10,120,'Cumulative','FontSize',5,'FontWeight','Normal');
end

data = distD;
selGroups = 1:length(data);
combs = nchoosek(1:length(selGroups),2);
for ii = 1:size(combs,1)
    [hks(ii),pks(ii),ks2stat(ii)] = kstest2(allBars(combs(ii,1),:),allBars(combs(ii,2),:),'Tail',ks_tail);
end
% sigR = significanceTesting(distD);
sigR.ks.h = hks;
sigR.ks.p = pks;
sigR.ks.ks2stat = ks2stat;
sigR.ks.tail = ks_tail;
% 
% if ~isempty(barGraph)
%     barPos = barGraph{2};
%     maxY = barGraph{4};
%     ySpacing = barGraph{6};
%     sigTestName = barGraph{8};
%     sigColor = barGraph{10};
%     baseValue = barGraph{12};
%     pos = get(gca,'Position');
%     axesPos = pos + [barPos(1) barPos(2) 0 0];
%     axesPos(3:4) = [barPos(3) barPos(4)];
%     hca = axes('Position',axesPos);hold on;
%     hs = sigR.anova.multcompare.h; ps = sigR.anova.multcompare.p;
%     plotBarsWithSigLines(sigR.means,sigR.sems,sigR.combs,[hs ps],'colors',cols,'sigColor',sigColor,'maxY',maxY,'ySpacing',ySpacing,'sigTestName',sigTestName,'sigLineWidth',0.25,'BaseValue',baseValue);
%     xlim([0.4 0.6+length(sigR.means)]);
%     set(gca,'TickDir','out','FontSize',5,'FontWeight','Normal');
% end
% 
if nargout == 4
    varargout{1} = sigR;
end
% 
% axes(ha);
% if ~isempty(legs)
%     putLegend(gca,legs,'colors',cols);
% end

