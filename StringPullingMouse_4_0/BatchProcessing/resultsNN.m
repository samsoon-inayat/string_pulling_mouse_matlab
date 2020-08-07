clear all
clc

mainFolder = 'G:\OneDrives\OneDrive\Data\String_Pulling\Surjeet\Results_NN';
pdfFolder = 'G:\OneDrives\OneDrive\Data\String_Pulling\Surjeet\pdfs';

files = dir(sprintf('%s\\*.mat',mainFolder));

for ii = 1:length(files)
    thisFile = fullfile(files(ii).folder,files(ii).name);
    f{ii}.values = load(thisFile);
    this_file_name = files(ii).name;
    pos = findstr(this_file_name,'_');
    names = [];
    if length(pos) == 1
        names{1} = this_file_name(1:(pos-1));
        names{2} = this_file_name((pos+1):(end-4));
    end
    if length(pos) == 2
        names{1} = this_file_name(1:(pos(1)-1));
        names{2} = this_file_name((pos(1)+1):(pos(2)-1));
        names{3} = this_file_name((pos(2)+1):(end-4));
    end
    if length(pos) == 3
        names{1} = this_file_name(1:(pos(1)-1));
        names{2} = this_file_name((pos(1)+1):(pos(2)-1));
        names{3} = this_file_name((pos(2)+1):(pos(3)-1));
        names{4} = this_file_name((pos(3)+1):(end-4));
    end
    f{ii}.names = names;
    f{ii}.num_columns = (length(names)-1)*2;
    f{ii}.num_categories = (length(names)-1);
end
% return;
%%
ii = 1;
values = f{ii}.values;
names = f{ii}.names
num_columns = f{ii}.num_columns;
varName = names{end};
cc = 1;
varNameT = sprintf('%s_%s',names{cc},varName);

sel_values_d = values.DOM; sel_values_n = values.NoN_DOM;
sel_values = sel_values_d
outp.meanb = sel_values(1:16,cc)'; outp.meanw = sel_values(17:24,cc)';
outr.meanb = sel_values(1:16,cc+(num_columns/2))'; outr.meanw = sel_values(17:24,cc+(num_columns/2))';

% sel_values = sel_values_n
% outpn.meanb = sel_values(1:16,cc)'; outpn.meanw = sel_values(17:24,cc)';
% outrn.meanb = sel_values(1:16,cc+(num_columns/2))'; outrn.meanw = sel_values(17:24,cc+(num_columns/2))';

%%
colVar1 = [ones(1,16) 2*ones(1,8)];
betweenTableCtrl = table(outp.meanb',outr.meanb','VariableNames',{'Pantomime','Real'});
betweenTablePrkn = table(outp.meanw',outr.meanw','VariableNames',{'Pantomime','Real'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableCtrl;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rm = fitrm(betweenTable,'Pantomime,Real~Group','WithinModel','Time');
rm.WithinDesign = withinTable;
mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Type','ComparisonType','bonferroni'),6);
mc2 = find_sig_mctbl(multcompare(rm,'Type','By','Group','ComparisonType','bonferroni'),6);
% mc3 = find_sig_mctbl(multcompare(rm,'Group','ComparisonType','bonferroni'),5);
% mc4 = find_sig_mctbl(multcompare(rm,'Type','ComparisonType','bonferroni'),5);
n = 0;

%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.5 1.25],'color','w');
hold on;
mVar = [mean(outp.meanb) mean(outr.meanb) mean(outp.meanw) mean(outr.meanw)]; 
semVar = [std(outp.meanb)/sqrt(16) std(outr.meanb)/sqrt(16) std(outp.meanw)/sqrt(8) std(outr.meanw)/sqrt(8)];
combs = nchoosek(1:length(mVar),2); p = ones(size(combs,1),1);
% p(1) = mc2{1,6};
xdata = [1 2 3 4]; colors = {'b','r','c','m'}; 
[~,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',0.3,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.01);
xlim([0 5]); 
ylim([0 maxY]);
set(gca,'XTick',[1 2 3 4],'XTickLabel',{'Ctrl-P','Ctrl-R','Prkn-P','Prkn-R'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varName);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);