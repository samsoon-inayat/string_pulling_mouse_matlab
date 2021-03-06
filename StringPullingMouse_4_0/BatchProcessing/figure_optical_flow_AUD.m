function figure_optical_flow

mData = evalin('base','mData'); colors = mData.colors; 

% allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
% variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
allVarNames = {'pdfFolder','configs'};
variablesToGetFromBase = {'pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end

ds_data = get_data_from_base_ws('ds','AUD');
color_blind_map = load('colorblind_colormap.mat');


%% motion mean
runthis = 1;
if runthis
varName = 'motion.mean'; varNameT = 'Speed';
mds_data_r6 = get_masked_values_h(ds_data.ds_r6,varName,ds_data.ds_r6,0.1,[-Inf Inf]);
mds_data_r7 = get_masked_values_h(ds_data.ds_r7,varName,ds_data.ds_r7,0.1,[-Inf Inf]);
mds_data_rf = get_masked_values_h(ds_data.ds_rf,varName,ds_data.ds_rf,0.1,[-Inf Inf]);

colVar1 = [ones(1,18)];
betweenTable = table(mds_data_r6.meanb',mds_data_r7.meanb',mds_data_rf.meanb','VariableNames',{'R6','R7','RF'});
withinTable = table([1 2 3]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
% writetable(rmaR.ranova,fullfile(pdfFolder,'speed1_ranova.xlsx'),'WriteRowNames',true);
% writetable(rmaR.mc_Type,fullfile(pdfFolder,'speed_multiple_comparisons.xlsx'),'WriteRowNames',true);
% writetable(betweenTable,fullfile(pdfFolder,'speed_multiple_comparisons.xlsx'),'WriteRowNames',true);
n = 0;
write_ranova_tables_to_XL(rmaR,pdfFolder,'U_Speed');


%%
% hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
% hold on;
% h = shadedErrorBar(outp.xs,outp.mean_barsb,outp.sem_barsb,'b',0.7);%h.mainLine.Color = colors{1};h.patch.FaceColor = colors{1};h.patch.FaceAlpha = 0.5;
% h = shadedErrorBar(outp.xs,outp.mean_barsw,outp.sem_barsw,'c',0.7);%h.mainLine.Color = colors{2};h.patch.FaceColor = colors{2};h.patch.FaceAlpha = 0.5;
% h = shadedErrorBar(outr.xs,outr.mean_barsb,outr.sem_barsb,'r',0.7);%h.mainLine.Color = colors{3};h.patch.FaceColor = colors{3};h.patch.FaceAlpha = 0.5;
% h = shadedErrorBar(outr.xs,outr.mean_barsw,outr.sem_barsw,'m',0.7);%h.mainLine.Color = colors{4};h.patch.FaceColor = colors{4};h.patch.FaceAlpha = 0.5;
% % xlim([min(xs) max(xs)]);
% hx = xlabel('Speed (cm/s)'); %changePosition(hx,[0 1.25 0]);
% hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
% % ylim([0 100]);
% xlim([0 33])
% set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
% changePosition(gca,[-0.01 -0.01 0.03 0]);
% legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
% legs{5} = [10 5 0.9 0.09];
% putLegend(gca,legs,'colors',{'b','r','c','m'},'sigR',{[],'','k',6},'lineWidth',1);
% % text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% % text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
% save_pdf(hf,pdfFolder,sprintf('Distribution_pdf %s',varNameT),600);

%%
% hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
% hold on;
% h = shadedErrorBar(outp.xs,outp.mean_cdfb,outp.sem_cdfb,'b',0.7);%h.mainLine.Color = colors{1};h.patch.FaceColor = colors{1};h.patch.FaceAlpha = 0.5;
% h = shadedErrorBar(outp.xs,outp.mean_cdfw,outp.sem_cdfw,'c',0.7);%h.mainLine.Color = colors{2};h.patch.FaceColor = colors{2};h.patch.FaceAlpha = 0.5;
% h = shadedErrorBar(outr.xs,outr.mean_cdfb,outr.sem_cdfb,'r',0.7);%h.mainLine.Color = colors{3};h.patch.FaceColor = colors{3};h.patch.FaceAlpha = 0.5;
% h = shadedErrorBar(outr.xs,outr.mean_cdfw,outr.sem_cdfw,'m',0.7);%h.mainLine.Color = colors{4};h.patch.FaceColor = colors{4};h.patch.FaceAlpha = 0.5;
% % xlim([min(xs) max(xs)]);
% hx = xlabel('Speed (cm/s)'); %changePosition(hx,[0 1.25 0]);
% hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
% ylim([0 100]);%xlim([0 30])
% set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
% changePosition(gca,[-0.01 -0.01 0.03 0]);
% legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
% legs{5} = [37 3 55 10];
% putLegend(gca,legs,'colors',{'b','r','c','m'},'sigR',{[],'','k',6},'lineWidth',1);
% text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% % text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
% save_pdf(hf,pdfFolder,sprintf('Distribution_cdf %s',varNameT),600);

%%
hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 3 1.25],'color','w');
hold on;
mVar = rmaR.est_marginal_means{:,2}';
semVar = rmaR.est_marginal_means{:,3}';
xdata = [1:3]; colors = {'r','b','g'};
combs = rmaR.combs; p = rmaR.p;
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);

xlim([0 4]); ylim([0 maxY]);
% yval = 42; line([0.75 2.25],[yval yval]); line([2.75 4.25],[yval yval]);line([1.5 3.5],[47 47]); line([1.5 1.5],[yval 47]);line([3.5 3.5],[yval 47]);
% text(1.8,49,getNumberOfAsterisks(mc3{1,5}),'FontSize',12);
set(gca,'XTick',xdata,'XTickLabel',{'60 bpm','76 bpm','Real'}); xtickangle(45);
xtickangle(30);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Speed (cm/s)');%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
return;
end
