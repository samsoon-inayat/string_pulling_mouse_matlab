function make_graph(pdfFolder,param_name,rmaR)

hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 5 2.5],'color','w');
hold on;
mVar = rmaR.est_marginal_means.Mean';
semVar = rmaR.est_marginal_means.Formula_StdErr';
xdata = [1:2:24]; colors = {'b',[0 0 0.5],'r',[0.5 0 0],'b',[0 0 0.5],'r',[0.5 0 0],'c',[0 0.5 0.5],'m',[0.5 0 0.5]};
combs = rmaR.combs; p = rmaR.p;
rough_scale = max(mVar+semVar);
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',rough_scale/10,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
for ii = 5:8
    set(hbs(ii),'facecolor','none','edgecolor',colors{ii},'linewidth',1.25);
end
xlim([0 xdata(end)+1]); ylim([0 maxY]);
% yval = 42; line([0.75 2.25],[yval yval]); line([2.75 4.25],[yval yval]);line([1.5 3.5],[47 47]); line([1.5 1.5],[yval 47]);line([3.5 3.5],[yval 47]);
% text(1.8,49,getNumberOfAsterisks(mc3{1,5}),'FontSize',12);
set(gca,'XTick',xdata,'XTickLabel',{'Y-P-D','Y-P-ND','Y-R-D','Y-R-ND','O-P-D','O-P-ND','O-R-D','O-R-ND','Pa-P-D','Pa-P-ND','Pa-R-D','Pa-R-ND'}); 
xtickangle();
xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
yl = param_name;
inds = strfind(param_name,'_');
yl(inds) = ' ';
hy = ylabel(yl);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean_%s',param_name),600);