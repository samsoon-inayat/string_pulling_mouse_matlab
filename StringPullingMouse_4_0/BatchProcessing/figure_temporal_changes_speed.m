function figure_temporal_changes_speed
mData = evalin('base','mData'); colors = mData.colors; 

allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
ind1 = 1; ind2  = 2;
indCs = {1:16;1:8;1:16;1:8}; 
ds_bp = ds(ind1,indCs{ind1}); ds_wp = ds(ind2,indCs{ind2});
ent_bp = ent(ind1,indCs{ind1}); ent_wp = ent(ind2,indCs{ind2});
fd_ent_bp = fd_ent(ind1,indCs{ind1}); fd_ent_wp = fd_ent(ind2,indCs{ind2});
config_bp = configs(ind1,indCs{ind1}); config_wp = configs(ind2,indCs{ind2});
ind1 = 3; ind2  = 4;
ds_br = ds(ind1,indCs{ind1}); ds_wr = ds(ind2,indCs{ind2});
ent_br = ent(ind1,indCs{ind1}); ent_wr = ent(ind2,indCs{ind2});
fd_ent_br = fd_ent(ind1,indCs{ind1}); fd_ent_wr = fd_ent(ind2,indCs{ind2});
config_br = configs(ind1,indCs{ind1}); config_wr = configs(ind2,indCs{ind2});
color_blind_map = load('colorblind_colormap.mat');

%% Entropy
runthis = 0;
if runthis
varName = 'motion.ent'; varNameT = 'ENT';
% out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.01)
outp = get_masked_values_h(ent_bp,ent_wp,varName,ds_bp,ds_wp,0.1);
outr = get_masked_values_h(ent_br,ent_wr,varName,ds_br,ds_wr,0.1);

colVar1 = [ones(1,16) 2*ones(1,8)];
betweenTableCtrl = table(outp.meanb',outr.meanb','VariableNames',{'Pantomime','Real'});
betweenTablePrkn = table(outp.meanw',outr.meanw','VariableNames',{'Pantomime','Real'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableCtrl;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rm = fitrm(betweenTable,'Pantomime,Real~Group');
rm.WithinDesign = withinTable;
mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Type','ComparisonType','bonferroni'),6);
mc2 = find_sig_mctbl(multcompare(rm,'Type','By','Group','ComparisonType','bonferroni'),6);
mc3 = find_sig_mctbl(multcompare(rm,'Group','ComparisonType','bonferroni'),5);
mc4 = find_sig_mctbl(multcompare(rm,'Type','ComparisonType','bonferroni'),5);
n = 0;

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
hold on;
h = shadedErrorBar(outp.xs,outp.mean_barsb,outp.sem_barsb,'b',0.7);
h = shadedErrorBar(outp.xs,outp.mean_barsw,outp.sem_barsw,'c',0.7);
h = shadedErrorBar(outr.xs,outr.mean_barsb,outr.sem_barsb,'r',0.7);
h = shadedErrorBar(outr.xs,outr.mean_barsw,outr.sem_barsw,'m',0.7);
% xlim([min(xs) max(xs)]);
hx = xlabel('Temporal Entropy'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
% ylim([0 100]);
xlim([0.25 8])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
legs{5} = [0.5 0.5 6 0.5];
putLegend(gca,legs,'colors',{'b','r','c','m'},'sigR',{[],'','k',6},'lineWidth',1);
% text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_pdf %s',varNameT),600);

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
hold on;
h = shadedErrorBar(outp.xs,outp.mean_cdfb,outp.sem_cdfb,'b',0.7);%h.mainLine.Color = colors{1};h.patch.FaceColor = colors{1};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outp.xs,outp.mean_cdfw,outp.sem_cdfw,'c',0.7);%h.mainLine.Color = colors{2};h.patch.FaceColor = colors{2};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfb,outr.sem_cdfb,'r',0.7);%h.mainLine.Color = colors{3};h.patch.FaceColor = colors{3};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfw,outr.sem_cdfw,'m',0.7);%h.mainLine.Color = colors{4};h.patch.FaceColor = colors{4};h.patch.FaceAlpha = 0.5;
% xlim([min(xs) max(xs)]);
hx = xlabel('Temporal Entropy'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);%xlim([0 30])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
legs{5} = [1 0.5 95 10];
putLegend(gca,legs,'colors',{'b','r','c','m'},'sigR',{[],'','k',6},'lineWidth',1);
text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.5 1.25],'color','w');
hold on;
mVar = [mean(outp.meanb) mean(outr.meanb) mean(outp.meanw) mean(outr.meanw)]; 
semVar = [std(outp.meanb)/sqrt(16) std(outr.meanb)/sqrt(16) std(outp.meanw)/sqrt(8) std(outr.meanw)/sqrt(8)];
combs = nchoosek(1:length(mVar),2); p = ones(size(combs,1),1);
p(1) = mc2{1,6}; p(6) = mc2{2,6};
xdata = [1 2 3 4]; colors = {'b','r','c','m'}; 
[~,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',0.3,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.01);
xlim([0 5]); ylim([3 maxY]);
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Ctrl-P','Ctrl-R','Prkn-P','Prkn-R'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Temporal Entropy');%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
return;
end

%% Higuchi
runthis = 0;
if runthis
varName = 'HFD.motion.ent'; varNameT = 'HFD';
% out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.01)
outp = get_masked_values_h(ent_bp,ent_wp,varName,ds_bp,ds_wp,0.005);
outr = get_masked_values_h(ent_br,ent_wr,varName,ds_br,ds_wr,0.005);

colVar1 = [ones(1,16) 2*ones(1,8)];
betweenTableCtrl = table(outp.meanb',outr.meanb','VariableNames',{'Pantomime','Real'});
betweenTablePrkn = table(outp.meanw',outr.meanw','VariableNames',{'Pantomime','Real'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableCtrl;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rm = fitrm(betweenTable,'Pantomime,Real~Group');
rm.WithinDesign = withinTable;
mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Type','ComparisonType','bonferroni'),6);
mc2 = find_sig_mctbl(multcompare(rm,'Type','By','Group','ComparisonType','bonferroni'),6);
mc3 = find_sig_mctbl(multcompare(rm,'Group','ComparisonType','bonferroni'),5);
mc4 = find_sig_mctbl(multcompare(rm,'Type','ComparisonType','bonferroni'),5);
n = 0;

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
hold on;
h = shadedErrorBar(outp.xs,outp.mean_barsb,outp.sem_barsb,'b',0.7);
h = shadedErrorBar(outp.xs,outp.mean_barsw,outp.sem_barsw,'c',0.7);
h = shadedErrorBar(outr.xs,outr.mean_barsb,outr.sem_barsb,'r',0.7);
h = shadedErrorBar(outr.xs,outr.mean_barsw,outr.sem_barsw,'m',0.7);
% xlim([min(xs) max(xs)]);
hx = xlabel('Higuchi FD'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
% ylim([0 100]);xlim([0.9 2.1])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
legs{5} = [1 0.1 95 10];
% putLegend(gca,legs,'colors',{'b','c','r','m'},'sigR',{[],'','k',6},'lineWidth',1);
% text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_pdf %s',varNameT),600);
%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
hold on;
h = shadedErrorBar(outp.xs,outp.mean_cdfb,outp.sem_cdfb,'b',0.7);%h.mainLine.Color = colors{1};h.patch.FaceColor = colors{1};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outp.xs,outp.mean_cdfw,outp.sem_cdfw,'c',0.7);%h.mainLine.Color = colors{2};h.patch.FaceColor = colors{2};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfb,outr.sem_cdfb,'r',0.7);%h.mainLine.Color = colors{3};h.patch.FaceColor = colors{3};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfw,outr.sem_cdfw,'m',0.7);%h.mainLine.Color = colors{4};h.patch.FaceColor = colors{4};h.patch.FaceAlpha = 0.5;
% xlim([min(xs) max(xs)]);
hx = xlabel('Higuchi FD'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);xlim([0.9 2.1])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
legs{5} = [1 0.1 95 10];
putLegend(gca,legs,'colors',{'b','c','r','m'},'sigR',{[],'','k',6},'lineWidth',1);
text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.5 1.25],'color','w');
hold on;
mVar = [mean(outp.meanb) mean(outr.meanb) mean(outp.meanw) mean(outr.meanw)]; 
semVar = [std(outp.meanb)/sqrt(16) std(outr.meanb)/sqrt(16) std(outp.meanw)/sqrt(8) std(outr.meanw)/sqrt(8)];
combs = nchoosek(1:length(mVar),2); p = ones(size(combs,1),1);
% p(5) = 1.5e-05; p(2) = 0.00954; p(6) = 0.013236;
p(1) = mc2{1,6};
xdata = [1 2 3 4]; colors = {'b','c','r','m'}; 
[~,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',0.1,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.01);
xlim([0 5]); ylim([1.5 maxY]);
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Ctrl-P','Ctrl-R','Prkn-P','Prkn-R'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Higuchi FD');%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
return;
end

%% Fano Factor
runthis = 1;
if runthis
varName = 'FF.motion.ent'; varNameT = 'FF';
% out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.01)
outp = get_masked_values_h(ent_bp,ent_wp,varName,ds_bp,ds_wp,0.005);
outr = get_masked_values_h(ent_br,ent_wr,varName,ds_br,ds_wr,0.005);

colVar1 = [ones(1,16) 2*ones(1,8)];
betweenTableCtrl = table(outp.meanb',outr.meanb','VariableNames',{'Pantomime','Real'});
betweenTablePrkn = table(outp.meanw',outr.meanw','VariableNames',{'Pantomime','Real'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableCtrl;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rm = fitrm(betweenTable,'Pantomime,Real~Group');
rm.WithinDesign = withinTable;
mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Type','ComparisonType','bonferroni'),6);
mc2 = find_sig_mctbl(multcompare(rm,'Type','By','Group','ComparisonType','bonferroni'),6);
mc3 = find_sig_mctbl(multcompare(rm,'Group','ComparisonType','bonferroni'),5);
mc4 = find_sig_mctbl(multcompare(rm,'Type','ComparisonType','bonferroni'),5);
n = 0;

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
hold on;
h = shadedErrorBar(outp.xs,outp.mean_barsb,outp.sem_barsb,'b',0.7);
h = shadedErrorBar(outp.xs,outp.mean_barsw,outp.sem_barsw,'c',0.7);
h = shadedErrorBar(outr.xs,outr.mean_barsb,outr.sem_barsb,'r',0.7);
h = shadedErrorBar(outr.xs,outr.mean_barsw,outr.sem_barsw,'m',0.7);
% xlim([min(xs) max(xs)]);
hx = xlabel('Fano Factor'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
% ylim([0 100]);xlim([0.9 2.1])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
legs{5} = [1 0.1 95 10];
% putLegend(gca,legs,'colors',{'b','c','r','m'},'sigR',{[],'','k',6},'lineWidth',1);
% text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution_pdf %s',varNameT),600);

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
hold on;
h = shadedErrorBar(outp.xs,outp.mean_cdfb,outp.sem_cdfb,'b',0.7);%h.mainLine.Color = colors{1};h.patch.FaceColor = colors{1};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outp.xs,outp.mean_cdfw,outp.sem_cdfw,'c',0.7);%h.mainLine.Color = colors{2};h.patch.FaceColor = colors{2};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfb,outr.sem_cdfb,'r',0.7);%h.mainLine.Color = colors{3};h.patch.FaceColor = colors{3};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfw,outr.sem_cdfw,'m',0.7);%h.mainLine.Color = colors{4};h.patch.FaceColor = colors{4};h.patch.FaceAlpha = 0.5;
% xlim([min(xs) max(xs)]);
hx = xlabel('Fano Factor'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
% ylim([0 100]);xlim([0.9 2.1])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
legs{5} = [1 0.1 95 10];
putLegend(gca,legs,'colors',{'b','c','r','m'},'sigR',{[],'','k',6},'lineWidth',1);
text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.5 1.25],'color','w');
hold on;
mVar = [mean(outp.meanb) mean(outr.meanb) mean(outp.meanw) mean(outr.meanw)]; 
semVar = [std(outp.meanb)/sqrt(16) std(outr.meanb)/sqrt(16) std(outp.meanw)/sqrt(8) std(outr.meanw)/sqrt(8)];
combs = nchoosek(1:length(mVar),2); p = ones(size(combs,1),1);
p(1) = mc2{1,6}; p(6) = mc2{2,6};
xdata = [1 2 3 4]; colors = {'b','c','r','m'}; 
[~,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',0.051,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.01);
% xlim([0 5]); ylim([1.5 maxY]);
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Ctrl-P','Ctrl-R','Prkn-P','Prkn-R'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Fano Factor');%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
return;
end

%%
runthis = 0;
if runthis
    for ii = 2
an_b = ii; ab_w = ii;
view_entropy(config_bp{an_b},ent_bp{an_b},{pdfFolder,sprintf('Temporal_bp_%d',ii)});
view_entropy(config_wp{ab_w},ent_wp{ab_w},{pdfFolder,sprintf('Temporal_wp_%d',ii)});
view_entropy(config_br{an_b},ent_br{an_b},{pdfFolder,sprintf('Temporal_br_%d',ii)});
view_entropy(config_wr{ab_w},ent_wr{ab_w},{pdfFolder,sprintf('Temporal_wr_%d',ii)});
    end
return;
end


%% speed frames
runthis = 1;
if runthis
ds_types_vars = {'standard_deviation','skewness','kurtosis','Fano Factor','Entropy','Higuchi'};
ds_types = {'Std. Dev.','Skewness','Kurtosis','Fano Factor','Entropy','Higuchi FD'};
fesp = get_2d_image_xics(fd_ent_bp,fd_ent_wp,ds_types_vars,{'Motion'});
fesr = get_2d_image_xics(fd_ent_br,fd_ent_wr,ds_types_vars,{'Motion'});
fes = fesp;

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

maxY = 0.05; ySpacing = 0.02; params = {'SN',maxY ySpacing};
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