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
ii = 11;
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

sel_values = sel_values_n
outpn.meanb = sel_values(1:16,cc)'; outpn.meanw = sel_values(17:24,cc)';
outrn.meanb = sel_values(1:16,cc+(num_columns/2))'; outrn.meanw = sel_values(17:24,cc+(num_columns/2))';

%%
colVar1 = [ones(1,16) 2*ones(1,8)];
betweenTableCtrl = table(outp.meanb',outpn.meanb',outr.meanb',outrn.meanb','VariableNames',{'Pantomime','Pantomime_N','Real','Real_N'});
betweenTablePrkn = table(outp.meanw',outpn.meanw',outr.meanw',outrn.meanw','VariableNames',{'Pantomime','Pantomime_N','Real','Real_N'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableCtrl;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);

withinTable = table([1 1 2 2]',[1 2 1 2]','VariableNames',{'Type','Dominance'});
withinTable.Type = categorical(withinTable.Type);
withinTable.Dominance = categorical(withinTable.Dominance);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
% rm = fitrm(betweenTable,'Pantomime,Pantomime_N,Real,Real_N~Group');
% rm.WithinDesign = withinTable;
% mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Type','ComparisonType','bonferroni'),6);
% mc2 = find_sig_mctbl(multcompare(rm,'Type','By','Dominance','ComparisonType','bonferroni'),6);
% mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Dominance','ComparisonType','bonferroni'),6);
% mc2 = find_sig_mctbl(multcompare(rm,'Dominance','By','Group','ComparisonType','bonferroni'),6);
% % writetable(rm.BetweenDesign,sprintf('%s.csv',varNameT));
% n = 0;
% 
% %%
% rm1 = fitrm(betweenTableCtrl,'Pantomime,Pantomime_N,Real,Real_N~1');
% rm1.WithinDesign = withinTable;
% rm1.WithinModel = 'Type*Dominance';
% mc1 = find_sig_mctbl(multcompare(rm1,'Dominance','By','Type','ComparisonType','bonferroni'),6);
% 
% rm2 = fitrm(betweenTablePrkn,'Pantomime,Pantomime_N,Real,Real_N~1');
% rm2.WithinDesign = withinTable;
% rm2.WithinModel = 'Type*Dominance';
% mc2 = find_sig_mctbl(multcompare(rm2,'Dominance','By','Type','ComparisonType','bonferroni'),6);

%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 3 1.25],'color','w');
hold on;
mVar = rmaR.est_marginal_means{:,4}';
semVar = rmaR.est_marginal_means{:,5}';
combs = rmaR.combs; p = rmaR.p;

% mVar = [mean(outp.meanb) mean(outpn.meanb) mean(outr.meanb) mean(outrn.meanb) mean(outp.meanw) mean(outpn.meanw) mean(outr.meanw) mean(outrn.meanw)]; 
% semVar = [std(outp.meanb)/sqrt(16) std(outpn.meanb)/sqrt(16) std(outr.meanb)/sqrt(16) std(outrn.meanb)/sqrt(16) ...
%     std(outp.meanw)/sqrt(8) std(outpn.meanw)/sqrt(8) std(outr.meanw)/sqrt(8) std(outrn.meanw)/sqrt(8)];
% combs = nchoosek(1:length(mVar),2); p = ones(size(combs,1),1);
% p(1) = mc1{2,6}; 
xdata = [1 2 3 4 5 6 7 8]; colors = {'b',[0 0 0.75],'r',[0.75 0 0],'c',[0 0 0.5],'m',[0.5 0 0.5]}; 
[~,maxY] = plotBarsWithSigLines(mVar,semVar,combs,p,'colors',colors,'sigColor','k',...
        'ySpacing',0.1,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.01);
xlim([0 9]); 
ylim([0 maxY]);
set(gca,'XTick',[1 2 3 4 5 6 7 8],'XTickLabel',{'Ctrl-P','Ctrl-PN','Ctrl-R','Ctrl-RN','Prkn-P','Prkn-PN','Prkn-R','Prkn-RN'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel(varName);%changePosition(hy,[0.1 -0.3 0]);set(hy,'FontSize',7)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);