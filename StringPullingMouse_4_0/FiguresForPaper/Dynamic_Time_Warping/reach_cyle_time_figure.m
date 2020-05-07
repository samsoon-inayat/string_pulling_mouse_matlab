function reach_cyle_time_figure
meanw = [0.203333333333333,0.197619047619048,0.244444444444444,0.211904761904762,0.238888888888889];
meanb = [0.313888888888889,0.252083333333333,0.336666666666667,0.291666666666667,0.261111111111111];
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.5 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanb,meanw);
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.65;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.04,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel({'Reach Cycle','Time (sec)'});%changePosition(hy,[0.1 -0.01 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pwd,sprintf('RCT.pdf'),600);
effect_size