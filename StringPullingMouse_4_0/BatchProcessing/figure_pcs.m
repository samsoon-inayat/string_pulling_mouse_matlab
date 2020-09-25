function figure_pcs

mData = evalin('base','mData'); colors = mData.colors; 

% allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
% variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
allVarNames = {'pdfFolder','configs'};
variablesToGetFromBase = {'pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end

data = get_data('pcs');
color_blind_map = load('colorblind_colormap.mat');
groups = {'y','o','p'};
types = {'p','r'};
%%
data_table = table();
for gg = 1:length(groups)
    vals = [];
    for tt = 1:length(types)
        cmdTxt = sprintf('temp = data.pcs_%s_%s;',groups{gg},types{tt});
        eval(cmdTxt);
        for an = 1:length(temp)
            vals(an,tt) = temp{an}.motion.explained(1);
        end
    end
    vals = [gg*ones(length(temp),1) vals];
    data_table = [data_table;array2table(vals)];
end

data_table.Properties.VariableNames = {'Group','Pantomime','Real'};
data_table.Group = categorical(data_table.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(data_table,withinTable);
n = 0;
%%
varNameT = 'PCs_EV';
hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 3 1.25],'color','w');
hold on;
mVar = rmaR.est_marginal_means{:,3}';
semVar = rmaR.est_marginal_means{:,4}';
xdata = [1:2:12]; colors = {'b','r','b','r','c','m'};
combs = rmaR.combs; p = rmaR.p;
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
for ii = 3:4
    set(hbs(ii),'facecolor','none','edgecolor',colors{ii},'linewidth',1.25);
end
xlim([0 13]); ylim([0 maxY]);
% yval = 42; line([0.75 2.25],[yval yval]); line([2.75 4.25],[yval yval]);line([1.5 3.5],[47 47]); line([1.5 1.5],[yval 47]);line([3.5 3.5],[yval 47]);
% text(1.8,49,getNumberOfAsterisks(mc3{1,5}),'FontSize',12);
set(gca,'XTick',xdata,'XTickLabel',{'Young-P','Young-R','Old-P','Old-R','Prkn-P','Prkn-R'}); xtickangle(45);
xtickangle(30);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('PCs EV');%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);