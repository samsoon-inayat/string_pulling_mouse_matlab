function figure_temporal_changes_position

variablesToGetFromBase = {'config_b','config_w','ent_b','ent_w','fd_ent_b','fd_ent_w','pdfFolder','ds_b','ds_w'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',variablesToGetFromBase{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
n = 0;
%%
runthis = 0;
if runthis
    for ii = 1:5
an_b = ii; ab_w = ii;
view_entropy(config_b{an_b},ent_b{an_b},{pdfFolder,sprintf('Temporal_b_%d',ii)});
view_entropy(config_w{ab_w},ent_w{ab_w},{pdfFolder,sprintf('Temporal_w_%d',ii)});
    end
return;
end

%% image sequence
runthis = 0;
if runthis == 1
ds_types_vars = {'standard_deviation','skewness','kurtosis','Fano Factor','Entropy','Higuchi'};
ds_types = {'Std. Dev.','Skewness','Kurtosis','Fano Factor','Entropy','Higuchi FD'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types_vars,{'Img'});

maxY = 11; ySpacing = 0.5; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[12 8 2 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});changePosition(ylh,[0.1 1.5 0])
changePosition(ha,[0.05 -0.02 -0.015 -0.01]);
ylim([4 maxY]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[3.75 0.5 maxY 1.1]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',5);
save_pdf(hf,pdfFolder,'Temporal ENT',600);

maxY = 1.8; ySpacing = 0.1; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[12 5 2 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Hausdorff FD'});changePosition(ylh,[-0.4 0.7 0]);
changePosition(ha,[0.05 -0.02 -0.015 -0.01]);
ylim([1.5 maxY]);
save_pdf(hf,pdfFolder,'Temporal FD',600);

maxY = 0.1; ySpacing = 0.02; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[12 2 2 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Shaprness'});changePosition(ylh,[0.1 0.001 0])
changePosition(ha,[0.08 -0.02 -0.015 -0.01]);
ylim([0.004 maxY]);
save_pdf(hf,pdfFolder,'Temporal SN',600);

% maxY = 0.7; ySpacing = 0.005; params = {'SP',maxY ySpacing};
% [hf,ha] = param_figure(1003,[14 2 1.5 1],ds_types,fes,params);
% set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
% xlh = xlabel(''); ylh = ylabel({'Spread'});changePosition(ylh,[0.1 0.001 0])
% changePosition(ha,[0.1 -0.02 -0.02 -0.01]);
% ylim([0 maxY]);
% save_pdf(hf,pdfFolder,'DSm SP V',600);
return;
end

%% standard deviation image sequence
runthis = 1;
if runthis
out = get_masked_values(ent_b,ent_w,'motion.ent',ds_b,ds_w,0.05)
% out = get_masked_values(ds_b,ds_w,'skewness',ds_b,ds_w,0.01);
minb = out.minb; maxb = out.maxb;
minw = out.minw; maxw = out.maxw;
vars_to_define = {'barsb','meanb','medianb','maxb','xs','barsw','meanw','medianw','maxw','cdfb','cdfw'};
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
% xlim([2.5 8]);
[h,p,ks2stat] = kstest2(mVarB,mVarW);
hk = h; pk = p;
hx = xlabel('Entropy'); changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.02 0.11 0.08 -0.08]);
legs = {'Black mice (N = 5)','White mice (N = 5)'};
legs{3} = [2.75 0.15 8 1.5];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',7},'lineWidth',1);
text(2.75,10,{'Average Distributions'},'FontSize',7,'FontWeight','normal');
text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
% ylim([0 10]);
% cumulative graph
mVarB = mean(cdfb,2);
mVarW = mean(cdfw,2);
semVarB = std(cdfb,[],2)./sqrt(5);
semVarW = std(cdfw,[],2)./sqrt(5);
cumPos = [0.7 0.22 0.15 0.3];
pos = get(gca,'Position');
axesPos = pos + [cumPos(1) cumPos(2) 0 0];
axesPos(3:4) = [cumPos(3) cumPos(4)];
hca = axes('Position',axesPos);hold on;
xlims = xlim;
% plot(xs,mVarB,'k');hold on;plot(xs,(mVarW),'b')
shadedErrorBar(xs,mVarB,semVarB,'k');
shadedErrorBar(xs,mVarW,semVarW,'b');
ylim([0 100]); xlim([2.5 8])
set(gca,'TickDir','out','FontSize',7,'FontWeight','Normal');
xlims = xlim; dx = diff(xlims);
text(xlims(1)+dx/10,130,'Cumulative','FontSize',7,'FontWeight','Normal');
axes(hca);
save_pdf(hf,pdfFolder,'Distribution Entropy',600);
%%
hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 5 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(medianb,medianw)
hmedian = h; pmedian = p;
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
mVar = [mean(medianb) mean(medianw)]; semVar = [std(medianb)/sqrt(5) std(medianw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/4;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.25,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',8,'sigAsteriskFontSize',12);
% xlim([0.5 2.5]); ylim([4.5 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Entropy');changePosition(hy,[0.1 0.3 0]);set(hy,'FontSize',7)
text(1,maxY,{'Median '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Median Entropy',600);

%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/4;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12);
% xlim([0.5 2.5]); ylim([4.5 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Entropy');changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
text(1,maxY,{'Mean '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Mean Entropy',600);

%%

hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 2 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(maxb,maxw)
hmax = h; pmax = p;
mVar = [mean(maxb) mean(maxw)]; semVar = [std(maxb)/sqrt(5) std(maxw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/4;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',1.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',14);

% xlim([0.5 2.5]); ylim([4.5 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Entropy');changePosition(hy,[0 0 0]);set(hy,'FontSize',7)
text(1,maxY,{'Max '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.12 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Max Higuchi FD',600);
[hk hmean hmedian hmax]
[pk pmean pmedian pmax]
return;
end


%% Entropy image sequence
runthis = 1;
if runthis
out = get_masked_values(ent_b,ent_w,'ent',ds_b,ds_w,0.1)
% out = get_masked_values(ds_b,ds_w,'kurtosis',ds_b,ds_w,0.01)
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
xlim([2.5 8]);
[h,p,ks2stat] = kstest2(mVarB,mVarW);
hk = h; pk = p;
hx = xlabel('Entropy'); changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.02 0.11 0.08 -0.08]);
legs = {'Black mice (N = 5)','White mice (N = 5)'};
legs{3} = [2.75 0.15 8 1.5];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',7},'lineWidth',1);
text(2.75,10,{'Average Distributions'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
ylim([0 10]);
% cumulative graph
cumPos = [0.7 0.22 0.15 0.3];
pos = get(gca,'Position');
axesPos = pos + [cumPos(1) cumPos(2) 0 0];
axesPos(3:4) = [cumPos(3) cumPos(4)];
hca = axes('Position',axesPos);hold on;
xlims = xlim;
plot(xs,cumsum(mVarB),'k');hold on;plot(xs,cumsum(mVarW),'b')
ylim([0 100]); xlim([2.5 8])
set(gca,'TickDir','out','FontSize',7,'FontWeight','Normal');
xlims = xlim; dx = diff(xlims);
text(xlims(1)+dx/10,130,'Cumulative','FontSize',7,'FontWeight','Normal');
axes(hca);
save_pdf(hf,pdfFolder,'Distribution Entropy',600);
%%
hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 5 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(medianb,medianw)
hmedian = h; pmedian = p;
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
maxY = 6.75;
mVar = [mean(medianb) mean(medianw)]; semVar = [std(medianb)/sqrt(5) std(medianw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',8,'sigAsteriskFontSize',12,'sigLinesStartYFactor',0.01);
xlim([0.5 2.5]); ylim([4.75 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Entropy');changePosition(hy,[0 -0.2 0]);set(hy,'FontSize',7)
text(1,maxY,{'Median '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Median Entropy',600);

%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
maxY = 6.75;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'sigLinesStartYFactor',0.01);
xlim([0.5 2.5]); ylim([4.75 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Entropy');changePosition(hy,[0 -0.2 0]);set(hy,'FontSize',7)
text(1,maxY,{'Mean '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Mean Entropy',600);

%%

hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 2 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(maxb,maxw)
hmax = h; pmax = p;
maxY = 7.5;
mVar = [mean(maxb) mean(maxw)]; semVar = [std(maxb)/sqrt(5) std(maxw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',1.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',14,'sigLinesStartYFactor',0.05);

    xlim([0.5 2.5]); ylim([4.5 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Entropy');changePosition(hy,[0 0 0]);set(hy,'FontSize',7)
text(1,maxY,{'Max '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.12 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Max Entropy',600);
[hk hmean hmedian hmax]
[pk pmean pmedian pmax]
return;
end


%% Higuchi FD image sequence
runthis = 1;
if runthis
out = get_masked_values(ent_b,ent_w,'HFD.ent',ds_b,ds_w,0.005)
% out = get_masked_values(ds_b,ds_w,'kurtosis',ds_b,ds_w,0.01)
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
xlim([1 2.3]);
[h,p,ks2stat] = kstest2(mVarB,mVarW);
hk = h; pk = p;
hx = xlabel('Higuchi FD'); changePosition(hx,[0 0.2 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.02 0.11 0.08 -0.08]);
legs = {'Black mice (N = 5)','White mice (N = 5)'};
legs{3} = [1.05 0.05 1.65 0.3];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',7},'lineWidth',1);
text(1.1,2,{'Average Distributions'},'FontSize',7,'FontWeight','normal');
text(1.05,0.9,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(1.05,0.75,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
ylim([0 2]);
% cumulative graph
cumPos = [0.7 0.22 0.15 0.3];
pos = get(gca,'Position');
axesPos = pos + [cumPos(1) cumPos(2) 0 0];
axesPos(3:4) = [cumPos(3) cumPos(4)];
hca = axes('Position',axesPos);hold on;
xlims = xlim;
plot(xs,cumsum(mVarB),'k');hold on;plot(xs,cumsum(mVarW),'b')
ylim([0 100]); xlim([1 2.5])
set(gca,'TickDir','out','FontSize',7,'FontWeight','Normal');
xlims = xlim; dx = diff(xlims);
text(xlims(1)+dx/10,130,'Cumulative','FontSize',7,'FontWeight','Normal');
axes(hca);
save_pdf(hf,pdfFolder,'Distribution Higuchi FD',600);
%%
hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 5 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(medianb,medianw)
hmedian = h; pmedian = p;
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
maxY = 2;
mVar = [mean(medianb) mean(medianw)]; semVar = [std(medianb)/sqrt(5) std(medianw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.2,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',8,'sigAsteriskFontSize',12,'sigLinesStartYFactor',0.01);
xlim([0.5 2.5]); ylim([1.45 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Higuchi FD');changePosition(hy,[0.1 0 0]);set(hy,'FontSize',7)
text(1,maxY,{'Median '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Median Higuchi FD',600);

%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
% [p,h,r_stat] = ranksum(meanuvb,meanuvw)
maxY = 2;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.2,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'sigLinesStartYFactor',0.01);
xlim([0.5 2.5]); ylim([1.45 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Higuchi FD');changePosition(hy,[0.1 0 0]);set(hy,'FontSize',7)
text(1,maxY,{'Mean '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Mean Higuchi FD',600);

%%

hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 2 1 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(maxb,maxw)
hmax = h; pmax = p;
maxY = 2.2;
mVar = [mean(maxb) mean(maxw)]; semVar = [std(maxb)/sqrt(5) std(maxw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',1.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',14,'sigLinesStartYFactor',0.01);

xlim([0.5 2.5]);  ylim([1.45 maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Higuchi FD');changePosition(hy,[0 0 0]);set(hy,'FontSize',7)
text(1,maxY,{'Max '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.12 0 -0.08 0]);
save_pdf(hf,pdfFolder,'Max Higuchi FD',600);
[hk hmean hmedian hmax]
[pk pmean pmedian pmax]
return;
end
