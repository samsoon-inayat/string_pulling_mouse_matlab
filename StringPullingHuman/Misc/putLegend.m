function putLegend(ah,legs,varargin)
% function putLegend(ah,legs,specs,varargin)

p = inputParser;
default_colors = distinguishable_colors(20);
default_ySpacingFactor = 10;
addRequired(p,'ah',@ishandle);
addRequired(p,'legs',@iscell);
addOptional(p,'colors',default_colors,@iscell);
addOptional(p,'sigR',NaN);
addOptional(p,'sigType',NaN);
addOptional(p,'sigColor',NaN);
addOptional(p,'lineWidth',0.5);


parse(p,ah,legs,varargin{:});

cols = p.Results.colors;
lineWidth = p.Results.lineWidth;
ah = p.Results.ah;
temp = p.Results.sigR;
if iscell(temp)
    sigR = temp{1};
    sigType = temp{2};
    sigColor = temp{3};
    sigFontSize = temp{4};
else
    sigR = NaN;
    sigFontSize = 5;
end

axes(ah);
specs = legs{end};
legs(end) = [];
lenLine = specs(2);
x1 = specs(1); x2 = x1+lenLine; y1 = (specs(3):-specs(4):0); y1 = y1(1:length(legs)); y2 = y1;
legendFontSize = sigFontSize;
for ii = 1:length(legs)
    if isempty(legs{ii})
        continue;
    end
    plot([x1 x2],[y1(ii) y2(ii)],'color',cols{ii},'linewidth',lineWidth);
    text(x2+(lenLine/2),y1(ii),sprintf('%s',legs{ii}),'Color',cols{ii},'FontSize',legendFontSize);
end

if isstruct(sigR)
    combs = sigR.combs;
    if strcmp(sigType,'ks')
        sig(:,2) = sigR.ks.p';
        sig(:,1) = sigR.ks.h';
        sigTypeT = 'KS test';
    end

    if strcmp(sigType,'anova')
        sig(:,2) = sigR.anova.multcompare.p;
        sig(:,1) = sigR.anova.multcompare.h;
        sigTypeT = 'ANOVA';
    end
    
    if strcmp(sigType,'ancovas')
        sig(:,2) = sigR.ancova.multcompare.ps;
        sig(:,1) = sigR.ancova.multcompare.hs;
        sigTypeT = 'ANCOVA';
    end
    
    if strcmp(sigType,'ancovai')
        sig(:,2) = sigR.ancova.multcompare.pi;
        sig(:,1) = sigR.ancova.multcompare.hi;
        sigTypeT = 'ANCOVA';
    end

    if strcmp(sigType,'kruskalwallis')
        sig(:,2) = sigR.kruskalwallis.multcompare.p;
        sig(:,1) = sigR.kruskalwallis.multcompare.h;
        sigTypeT = 'KW';
    end
    
    diffCombs  = combs(:,2) - combs(:,1);
    maxdiff = max(combs(:,2) - combs(:,1));
    numberOfSigLines = length(find(sig(:,1)));
    
    if numberOfSigLines > 0
        sigLineWidth = 0.25;
        xlims = xlim;
        xspacing = lenLine/2; 
        axx = (x1-xspacing):-lenLine:xlims(1);
        count = 0;
        for ii = 1:maxdiff
            inds = find(diffCombs == ii);
            for jj = 1:length(inds)
                if ~sig(inds(jj),1)
                    continue;
                end
                count = count + 1;
                xx = axx(count);
                b1  = combs(inds(jj),1);
                b2  = combs(inds(jj),2);
                ys = y1(b1);
                ye = y1(b2);
                line([xx xx], [ys ye],'linewidth',sigLineWidth,'color',sigColor);
                line([xx xx+xspacing/2],[ys ys],'linewidth',sigLineWidth,'color',sigColor);
                line([xx xx+xspacing/2],[ye ye],'linewidth',sigLineWidth,'color',sigColor);
                pvalue = sig(inds(jj),2);
                sigText = getNumberOfAsterisks(pvalue);
                xt = xx-xspacing/2;
                yt = ye;
                ht = text(xt,yt,sigText,'FontSize',legendFontSize,'rotation',90,'Color',sigColor);
                extent = get(ht,'Extent');
                totalY = ys - ye;
                indent = (totalY - extent(4))/2;
                yt = ye + indent;
                set(ht,'Position',[xt yt 0]);
            end
        end
        count = count + 1;
        xx = axx(count);
        sigText = sprintf('%s',sigTypeT);
        xt = xx-xspacing;
        yt = y1(end);% + (y1(1) - y1(2));
        ht = text(xt,yt,sigText,'FontSize',legendFontSize,'rotation',90,'Color',sigColor);
        extent = get(ht,'Extent');
        totalY = y1(1) - y1(end);
        indent = (totalY - extent(4))/2;
        yt = y1(end) + indent;
        set(ht,'Position',[xt yt 0]);
    else
        xlims = xlim;
        xspacing = lenLine/2; 
        axx = (x1-xspacing):-lenLine:xlims(1);
        xx = axx(1);
        sigText = sprintf('%s',sigTypeT);
        xt = xx-xspacing;
        yt = y1(end);% + (y1(1) - y1(2));
        ht = text(xt,yt,'NS','FontSize',legendFontSize,'rotation',90,'Color',sigColor);
        extent = get(ht,'Extent');
        totalY = y1(1) - y1(end);
        indent = (totalY - extent(4))/2;
        yt = y1(end) + indent;
        set(ht,'Position',[xt yt 0]);
        xx = axx(1);
        sigText = sprintf('%s',sigTypeT);
        xt = xx-3*xspacing;
        yt = y1(end);% + (y1(1) - y1(2));
        ht = text(xt,yt,sigText,'FontSize',legendFontSize,'rotation',90,'Color',sigColor);
        extent = get(ht,'Extent');
        totalY = y1(1) - y1(end);
        indent = (totalY - extent(4))/2;
        yt = y1(end) + indent;
        set(ht,'Position',[xt yt 0]);
    end
end

% p = inputParser;
% default_colors = distinguishable_colors(20);
% default_ySpacingFactor = 10;
% addRequired(p,'ah',@ishandle);
% addRequired(p,'legs',@iscell);
% addRequired(p,'specs',@isnumeric);
% addOptional(p,'colors',default_colors,@iscell);
% 
% parse(p,ah,legs,specs,varargin{:});
% 
% cols = p.Results.colors;
% ah = p.Results.ah;
% 
% axes(ah);
% 
% lenLine = specs(2);
% x1 = specs(1); x2 = x1+lenLine; y1 = (specs(3):-specs(4):0); y1 = y1(1:length(legs)); y2 = y1;
% legendFontSize = 5;
% for ii = 1:length(legs)
%     plot([x1 x2],[y1(ii) y2(ii)],'color',cols{ii},'linewidth',0.5);
%     text(x2+(lenLine/2),y1(ii),sprintf('%s',legs{ii}),'Color',cols{ii},'FontSize',legendFontSize);
% end
