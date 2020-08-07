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
for ii = 1:length(files)
    ii
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
% rm = fitrm(betweenTable,'Pantomime,Pantomime_N,Real,Real_N~Group');
% rm.WithinDesign = withinTable;
% mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Type','ComparisonType','bonferroni'),6);
% mc2 = find_sig_mctbl(multcompare(rm,'Type','By','Dominance','ComparisonType','bonferroni'),6);
% mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Dominance','ComparisonType','bonferroni'),6);
% mc2 = find_sig_mctbl(multcompare(rm,'Dominance','By','Group','ComparisonType','bonferroni'),6);
% n = 0;


%%
rm1 = fitrm(betweenTableCtrl,'Pantomime,Pantomime_N,Real,Real_N~1');
rm1.WithinDesign = withinTable;
rm1.WithinModel = 'Type*Dominance';
mc1 = find_sig_mctbl(multcompare(rm1,'Dominance','By','Type','ComparisonType','bonferroni'),6);
if ~isempty(mc1)
    ctrl_var{ii} = sprintf('%s_%s',names{cc},varName);
end

rm2 = fitrm(betweenTablePrkn,'Pantomime,Pantomime_N,Real,Real_N~1');
rm2.WithinDesign = withinTable;
rm2.WithinModel = 'Type*Dominance';
mc2 = find_sig_mctbl(multcompare(rm2,'Dominance','By','Type','ComparisonType','bonferroni'),6);
if ~isempty(mc2)
    prkn_var{ii} = sprintf('%s_%s',names{cc},varName);
end
end