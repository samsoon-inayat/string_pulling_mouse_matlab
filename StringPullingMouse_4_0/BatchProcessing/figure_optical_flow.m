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

ds_data = get_data_from_base_ws('ds');
% ds_data = get_data('ds');
color_blind_map = load('colorblind_colormap.mat');
n = 0;

%% motion mean
runthis = 1;
if runthis
varName = 'motion.mean'; varNameT = 'Speed';
mds_data_o_p = get_masked_values_h(ds_data.ds_o_p,varName,ds_data.ds_o_p,0.1,[-Inf Inf]);
mds_data_o_r = get_masked_values_h(ds_data.ds_o_r,varName,ds_data.ds_o_r,0.1,[-Inf Inf]);
mds_data_p_p = get_masked_values_h(ds_data.ds_p_p,varName,ds_data.ds_p_p,0.1,[-Inf Inf]);
mds_data_p_r = get_masked_values_h(ds_data.ds_p_r,varName,ds_data.ds_p_r,0.1,[-Inf Inf]);
mds_data_y_p = get_masked_values_h(ds_data.ds_y_p,varName,ds_data.ds_y_p,0.1,[-Inf Inf]);
mds_data_y_r = get_masked_values_h(ds_data.ds_y_r,varName,ds_data.ds_y_r,0.1,[-Inf Inf]);
% outp = get_masked_values_h(ds_bp,ds_wp,varName,ds_bp,ds_wp,0.1,[0 Inf]);
% outr = get_masked_values_h(ds_br,ds_wr,varName,ds_br,ds_wr,0.1,[0 Inf]);
[within,dvn,xlabels] = make_within_table({'RP'},[2]);
factor_names = {'Group','(Intercept):RP','Group:RP','(Intercept):D','Group:D','(Intercept):RP:D','Group:RP:D'};
effs = {'Group','RP','Group_RP','D','Group_D','RP_D','Group_RP_D'};
grpd = {[mds_data_y_r.meanb' mds_data_y_p.meanb'];[mds_data_o_r.meanb' mds_data_o_p.meanb'];[mds_data_p_r.meanb' mds_data_p_p.meanb']};
between = make_between_table(grpd,dvn);
ra = RMA(between,within);

n = 0;

%%
[xdata,mVar,semVar,combs,p,h,colors,xlabels] = get_vals_for_bar_graph_RMA(mData,ra,{'Group','hsd'},[1.5 1 1]);
    xdata = make_xdata([3],[1 1.5]);
    hf = get_figure(5,[8 7 1.5 1.5]);
    tcolors = {[0 0.447 0.741];[0.85 0.325 0.098]; [0.466 0.674 0.188]};
    MmVar = max(mVar);
    [hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',tcolors,'sigColor','k',...
        'ySpacing',MmVar/3,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.01,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',8,'barWidth',0.5,'sigLinesStartYFactor',0.15);
    maxY = maxY + 0;
    ylims = ylim;
    format_axes(gca);
    set_axes_limits(gca,[0.35 xdata(end)+.65],[ylims(1) maxY]); format_axes(gca);
    xticks = xdata; xticklabels = {'Young','Old','Park'};
    set(gca,'xtick',xticks,'xticklabels',xticklabels); xtickangle(45)
    changePosition(gca,[0.07 0.01 -0.2 -0.15]); put_axes_labels(gca,{[],[0 0 0]},{'A.U.',[0 0 0]});
%     titletxt = var_name1{hi};
%     inds = strfind(titletxt,'_');
%     titletxt(inds) = '-';
%     title(titletxt);
%     put_axes_labels(gca,{[],[0 0 0]},{'Cells (%)',[0 0 0]});
    save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);


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

return;
end
