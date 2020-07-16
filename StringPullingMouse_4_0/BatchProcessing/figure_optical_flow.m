function figure_optical_flow

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
ind1 = 3; ind2  = 4;
ds_br = ds(ind1,indCs{ind1}); ds_wr = ds(ind2,indCs{ind2});
color_blind_map = load('colorblind_colormap.mat');

%% motion mean
runthis = 1;
if runthis
varName = 'motion.mean'; varNameT = 'Speed';
% out = get_masked_values(ent_b,ent_w,varName,ds_b,ds_w,0.01)
outp = get_masked_values_h(ds_bp,ds_wp,varName,ds_bp,ds_wp,0.1);
outr = get_masked_values_h(ds_br,ds_wr,varName,ds_br,ds_wr,0.1);

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
n = 0;

%%
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.5 1.25],'color','w');
hold on;
h = shadedErrorBar(outp.xs,outp.mean_cdfb,outp.sem_cdfb,'b',0.7);%h.mainLine.Color = colors{1};h.patch.FaceColor = colors{1};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outp.xs,outp.mean_cdfw,outp.sem_cdfw,'c',0.7);%h.mainLine.Color = colors{2};h.patch.FaceColor = colors{2};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfb,outr.sem_cdfb,'r',0.7);%h.mainLine.Color = colors{3};h.patch.FaceColor = colors{3};h.patch.FaceAlpha = 0.5;
h = shadedErrorBar(outr.xs,outr.mean_cdfw,outr.sem_cdfw,'m',0.7);%h.mainLine.Color = colors{4};h.patch.FaceColor = colors{4};h.patch.FaceAlpha = 0.5;
% xlim([min(xs) max(xs)]);
hx = xlabel('Speed (cm/s)'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 100]);%xlim([0 30])
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Ctrl-P (N=16)','Ctrl-R ','Prkn-P (N=8)','Prkn-R '};
legs{5} = [37 3 55 10];
putLegend(gca,legs,'colors',{'b','c','r','m'},'sigR',{[],'','k',6},'lineWidth',1);
text(60,80,{'CDF'},'FontSize',7,'FontWeight','normal');
% text(2.75,4,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(3.25,4.5,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution %s',varNameT),600);
%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.5 1.25],'color','w');
hold on;
mVar = [mean(outp.meanb) mean(outr.meanb) mean(outp.meanw) mean(outr.meanw)]; 
semVar = [std(outp.meanb)/sqrt(16) std(outr.meanb)/sqrt(16) std(outp.meanw)/sqrt(8) std(outr.meanw)/sqrt(8)];

xdata = [1 2 3 4]; colors = {'b','c','r','m'}; combs = nchoosek(1:length(mVar),2);
h = [0 1 0 0 1 0]'; p = [1 0.0001 1 1 0.0001 1]';
[hbs,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',9,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 5]); ylim([0 maxY]);
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Ctrl-P','Ctrl-R','Prkn-P','Prkn-R'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Speed (cm/s)');%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
return;
end
