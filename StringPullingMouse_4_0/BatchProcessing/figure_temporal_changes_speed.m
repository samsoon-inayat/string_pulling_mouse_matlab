function figure_temporal_changes_speed

allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
n = 0; ind1 = 2; ind2  = 4;
indCs = {1:16;1:8}; 
ds_b = ds(ind1,indCs{ind1}); ds_w = ds(ind2,indCs{ind1});
motion_b = motion(ind1,indCs{ind1}); motion_w = motion(ind2,indCs{ind1});
fd_ent_b = fd_ent(ind1,indCs{ind1}); fd_ent_w = fd_ent(ind2,indCs{ind1});
ent_b = ent(ind1,indCs{ind1}); ent_w = ent(ind2,indCs{ind1});
pcs_b = pcs(ind1,indCs{ind1}); pcs_w = pcs(ind2,indCs{ind1});
config_b = configs(ind1,indCs{ind1}); config_w = configs(ind2,indCs{ind1});
%%
runthis = 0;
if runthis
    for ii = 1
an_b = ii; ab_w = ii;
view_entropy(config_b{an_b},ent_b{an_b},{pdfFolder,sprintf('Temporal_b_%d',ii)});
view_entropy(config_w{ab_w},ent_w{ab_w},{pdfFolder,sprintf('Temporal_w_%d',ii)});
    end
return;
end


%% speed frames
runthis = 1;
if runthis
ds_types_vars = {'standard_deviation','skewness','kurtosis','Fano Factor','Entropy','Higuchi'};
ds_types = {'Std. Dev.','Skewness','Kurtosis','Fano Factor','Entropy','Higuchi FD'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types_vars,{'Motion'});

maxY = 11; ySpacing = 0.5; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[12 8 2 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});changePosition(ylh,[0.1 1.5 0])
changePosition(ha,[0.05 -0.02 -0.015 -0.01]);
ylim([4 maxY]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[3.75 0.5 maxY 1.1]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',5);
save_pdf(hf,pdfFolder,'Temporal_m ENT',600);

maxY = 1.8; ySpacing = 0.1; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[12 5 2 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Hausdorff FD'});changePosition(ylh,[-0.4 0.7 0]);
changePosition(ha,[0.05 -0.02 -0.015 -0.01]);
ylim([1.5 maxY]);
save_pdf(hf,pdfFolder,'Temporal_m FD',600);

maxY = 0.03; ySpacing = 0.02; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[12 2 2 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Shaprness'});changePosition(ylh,[0.1 0.001 0])
changePosition(ha,[0.08 -0.02 -0.015 -0.01]);
ylim([0.004 maxY]);
save_pdf(hf,pdfFolder,'Temporal_m SN',600);
return;
end

%% standard deviation motion
runthis = 0;
if runthis
% out = get_masked_values(ent_b,ent_w,'motion.s',ds_b,ds_w,0.05)
varName = 'motion.standard_deviation'; varNameT = 'Std. Dev.';
out = get_masked_values(ds_b,ds_w,varName,ds_b,ds_w,0.01);
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
xlim([0 10]);
[h,p,ks2stat] = kstest2(mean_barsb,mean_barsw);
hk = h; pk = p;
hx = xlabel(varNameT); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [40 5 45 20];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
text(1.5,100,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_m %s',varName),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/3;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varNameT);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,maxY,{'Mean '},'FontSize',7,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean_m %s',varName),600);
[hk hmean]
[pk pmean]
return;
end


%% skewness motion
runthis = 0;
if runthis
% out = get_masked_values(ent_b,ent_w,'motion.s',ds_b,ds_w,0.05)
varName = 'motion.skewness'; varNameT = 'Skewness';
out = get_masked_values(ds_b,ds_w,varName,ds_b,ds_w,0.5);
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
hx = xlabel(varNameT); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 110])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [40 5 45 20];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
text(10,40,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_m %s',varName),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanb,meanw);
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.65;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varNameT);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean_m %s',varName),600);
[hk hmean]
[pk pmean]
effect_size
return;
end



%% Kurtosis image sequence
runthis = 0;
if runthis
% out = get_masked_values(ent_b,ent_w,'motion.s',ds_b,ds_w,0.05)
varName = 'motion.kurtosis'; varNameT = 'Kurtosis';
out = get_masked_values(ds_b,ds_w,varName,ds_b,ds_w,1);
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
hx = xlabel(varNameT); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);xlim([0 150])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [40 5 45 20];
% putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
text(70,30,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_m %s',varName),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.1;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varNameT);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean_m %s',varName),600);
[hk hmean]
[pk pmean]
return;
end

%% Fano Factor image sequence
runthis = 0;
if runthis
varName = 'FF.motion.ent'; varNameT = 'Fano Factor';
out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.001)
% out = get_masked_values(ds_b,ds_w,varName,ds_b,ds_w,1);
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
hx = xlabel(varNameT); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);%xlim([0 30])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [40 5 45 20];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
text(0.4,30,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_m %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanb,meanw);
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/3;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.01,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.05);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varNameT);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean_m %s',varNameT),600);
[hk hmean]
[pk pmean]
effect_size
return;
end

%% entropy image sequence
runthis = 0;
if runthis
varName = 'motion.ent'; varNameT = 'Entropy';
out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.01)
% out = get_masked_values(ds_b,ds_w,varName,ds_b,ds_w,1);
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
hx = xlabel(varNameT); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);%xlim([0 30])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [40 5 45 20];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
text(3,100,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_m %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanb,meanw);
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/2;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.5,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varNameT);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean_m %s',varNameT),600);
[hk hmean]
[pk pmean]
effect_size
return;
end

%% Higuchi image sequence
runthis = 1;
if runthis
varName = 'HFD.motion.ent'; varNameT = 'Higuchi FD';
out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.01)
% out = get_masked_values(ds_b,ds_w,varName,ds_b,ds_w,1);
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
hx = xlabel(varNameT); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);%xlim([0 30])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [40 5 45 20];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
text(1.6,100,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_m %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanb,meanw);
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/20;
minY = max(mVar - semVar); minY = minY - minY/20;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.05,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.005);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varNameT);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean_m %s',varNameT),600);
[hk hmean]
[pk pmean]
effect_size
return;
end