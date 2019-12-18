function figure_optical_flow
variablesToGetFromBase = {'ds_b','ds_w','motion_b','motion_w','pdfFolder','fd_ent_b','fd_ent_w','config_b','config_w'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',variablesToGetFromBase{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
n = 0;
% %%
% runthis = 1;
% if runthis
% an_b = 1; an_w = 1;
% viewOpticalFlow(config_b{an_b},motion_b{an_b},{pdfFolder,'optical_flow_b'})
% % viewOpticalFlow(config_w{an_w},motion_w{an_w},{pdfFolder,'optical_flow_w'})
% return
% end
%%
runthis = 0;
if runthis
out = get_masked_values(ds_b,ds_w,'motion.mean',ds_b,ds_w,0.1)
minb = out.minb; maxb = out.maxb;
minw = out.minw; maxw = out.maxw;
vars_to_define = {'barsb','meanb','medianb','maxb','xs','barsw','meanw','medianw','maxw'};
for ii = 1:length(vars_to_define)
    cmdTxt = sprintf('%s = out.%s;',vars_to_define{ii},vars_to_define{ii}); eval(cmdTxt);
end

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 3.25 1],'color','w');
hold on;
mVarB = mean(barsb,2);
mVarW = mean(barsw,2);
semVarB = std(barsb,[],2)./sqrt(5);
semVarW = std(barsw,[],2)./sqrt(5);
shadedErrorBar(xs,mVarB,semVarB,'k');
shadedErrorBar(xs,mVarW,semVarW,'b');
xlim([0 10]);
[h,p,ks2stat] = kstest2(mVarB,mVarW)
hx = xlabel('Speed (cm/s)'); changePosition(hx,[0 7.0 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.02 0.11 0.08 -0.08]);
legs = {'Black mice (N = 5)','White mice (N = 5)'};
legs{3} = [2.25 0.5 5 0.85];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',7},'lineWidth',1);
text(2,6,{'Average Distributions'},'FontSize',7,'FontWeight','normal');
text(3,2.5,{'***'},'FontSize',12,'FontWeight','normal'); text(3.75,2.75,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
ylim([0 6]);
% cumulative graph
cumPos = [0.7 0.28 0.15 0.3];
pos = get(gca,'Position');
axesPos = pos + [cumPos(1) cumPos(2) 0 0];
axesPos(3:4) = [cumPos(3) cumPos(4)];
hca = axes('Position',axesPos);hold on;
xlims = xlim;
plot(xs,cumsum(mVarB),'k');hold on;plot(xs,cumsum(mVarW),'b')
ylim([0 100]); xlim([0 10])
set(gca,'TickDir','out','FontSize',7,'FontWeight','Normal');
xlims = xlim; dx = diff(xlims);
text(xlims(1)+dx/10,120,'Cumulative','FontSize',7,'FontWeight','Normal');
axes(hca);
save_pdf(hf,pdfFolder,'Distribution Speeds',600);
%%
hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 5 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(medianb,medianw)
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
maxY = 7.5;
mVar = [mean(medianb) mean(medianw)]; semVar = [std(medianb)/sqrt(5) std(medianw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',1.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',8,'sigAsteriskFontSize',12,'sigLinesStartYFactor',0.05);
xlim([0.5 2.5]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Speed (cm/s)');changePosition(hy,[0 -0.3 0]);set(hy,'FontSize',7)
text(0.6,maxY,{'Median Speed'},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Median Speeds',600);

%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
maxY = 7.5;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',1.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'sigLinesStartYFactor',0.05);
xlim([0.5 2.5]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Speed (cm/s)');changePosition(hy,[0 -0.3 0]);set(hy,'FontSize',7)
text(0.6,maxY,{'Mean Speed'},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Mean Speeds',600);

%%

hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 2 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(maxb,maxw)
maxY = 15;
mVar = [mean(maxb) mean(maxw)]; semVar = [std(maxb)/sqrt(5) std(maxw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',1.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',14,'sigLinesStartYFactor',0.05);

    xlim([0.5 2.5]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Speed (cm/s)');changePosition(hy,[0 -2 0]);set(hy,'FontSize',7)
text(0.8,maxY,{'Max Speed'},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.12 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Max Speeds',600);
return;
end

%% motion mean
runthis = 0;
if runthis
varName = 'motion.mean'; varNameT = 'Speed';
% out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.01)
out = get_masked_values(ds_b,ds_w,varName,ds_b,ds_w,0.1);
minb = out.minb; maxb = out.maxb;
minw = out.minw; maxw = out.maxw;
vars_to_define = {'barsb','meanb','medianb','maxb','xs','barsw','meanw','medianw','maxw','mean_cdfb','mean_cdfw','sem_cdfb','sem_cdfw','mean_barsb','mean_barsw'};
for ii = 1:length(vars_to_define)
    cmdTxt = sprintf('%s = out.%s;',vars_to_define{ii},vars_to_define{ii}); eval(cmdTxt);
end

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.25 1],'color','w');
hold on;
shadedErrorBar(xs,mean_cdfb,sem_cdfb,'k');
shadedErrorBar(xs,mean_cdfw,sem_cdfw,'b');
xlim([min(xs) max(xs)]);
[h,p,ks2stat] = kstest2(mean_barsb,mean_barsw);
hk = h; pk = p;
hx = xlabel('Speed (cm/s)'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);%xlim([0 30])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [40 5 45 20];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
text(1.2,100,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.4,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Speed (cm/s)');%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hk hmean]
[pk pmean]
return;
end
