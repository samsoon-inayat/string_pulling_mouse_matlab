function hf = make_graph_whole_body_AUD(pdfFolder,varNameT,rmaR,ys,slsy)
hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 3 1.25],'color','w');
hold on;
mVar = rmaR.est_marginal_means{:,2}';
semVar = rmaR.est_marginal_means{:,3}';
xdata = [1:3]; colors = {'r','b','g'};
combs = rmaR.combs; p = rmaR.p;
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',ys,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',slsy);

xlim([0 4]); ylim([0 maxY]);
% yval = 42; line([0.75 2.25],[yval yval]); line([2.75 4.25],[yval yval]);line([1.5 3.5],[47 47]); line([1.5 1.5],[yval 47]);line([3.5 3.5],[yval 47]);
% text(1.8,49,getNumberOfAsterisks(mc3{1,5}),'FontSize',12);
set(gca,'XTick',xdata,'XTickLabel',{'60 bpm','76 bpm','Real'}); xtickangle(45);
xtickangle(30);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(sprintf('%s',varNameT));%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
