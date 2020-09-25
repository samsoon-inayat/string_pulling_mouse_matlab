function make_graph_whole_body(pdfFolder,param_name,rmaR)
hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 3 1.25],'color','w');
hold on;
mVar = rmaR.est_marginal_means{:,3}';
semVar = rmaR.est_marginal_means{:,4}';
combs = rmaR.combs; p = rmaR.p;
xdata = [1:2:12]; colors = {'b','r','b','r','c','m'};
rough_scale = max(mVar+semVar);
minY = min(mVar - semVar);
minY = minY - minY/10;
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',rough_scale/10,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.01);
for ii = 3:4
    set(hbs(ii),'facecolor','none','edgecolor',colors{ii},'linewidth',1.25);
end
xlim([0 xdata(end)+1]); ylim([minY maxY]);
set(gca,'XTick',xdata,'XTickLabel',{'Young-P','Young-R','Old-P','Old-R','Prkn-P','Prkn-R'}); xtickangle(45);
xtickangle(30);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(param_name);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',param_name),600);