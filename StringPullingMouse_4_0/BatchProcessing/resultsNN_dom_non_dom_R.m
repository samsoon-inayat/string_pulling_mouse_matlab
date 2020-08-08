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
f_ind = 1;
for ii = 1:length(files)
    values = f{ii}.values;
    names = f{ii}.names;
    num_columns = f{ii}.num_columns;
    varName = names{end};
    for cc = 1:(length(names)-1)
%         cc = 1;
        betweenTable = [];
        varNameT = sprintf('%s_%s',names{cc},varName);
        sel_values_d = values.DOM; sel_values_n = values.NoN_DOM;
        sel_values = sel_values_d;
        outp.meanb = sel_values(1:16,cc)'; outp.meanw = sel_values(17:24,cc)';
        outr.meanb = sel_values(1:16,cc+(num_columns/2))'; outr.meanw = sel_values(17:24,cc+(num_columns/2))';
        sel_values = sel_values_n;
        outpn.meanb = sel_values(1:16,cc)'; outpn.meanw = sel_values(17:24,cc)';
        outrn.meanb = sel_values(1:16,cc+(num_columns/2))'; outrn.meanw = sel_values(17:24,cc+(num_columns/2))';
    
        colVar1 = [ones(1,32) 2*ones(1,16)];
        colVar2 = [ones(1,16) 2*ones(1,16) ones(1,8) 2*ones(1,8)];
        id_var = [1:16 1:16 17:24 17:24];
        betweenTableCtrl_dom = table(outp.meanb',outr.meanb','VariableNames',{'Pantomime','Real'});
        betweenTableCtrl_n_dom = table(outpn.meanb',outrn.meanb','VariableNames',{'Pantomime','Real'});
        betweenTablePrkn_dom = table(outp.meanw',outr.meanw','VariableNames',{'Pantomime','Real'});
        betweenTablePrkn_n_dom = table(outpn.meanw',outrn.meanw','VariableNames',{'Pantomime','Real'});
        betweenTable = [table(id_var',colVar1',colVar2','VariableNames',{'ID','Group','Hand_Dominance'}) [betweenTableCtrl_dom;betweenTableCtrl_n_dom;betweenTablePrkn_dom;betweenTablePrkn_n_dom]];
        betweenTable.Group = categorical(betweenTable.Group);
        betweenTable.Hand_Dominance = categorical(betweenTable.Hand_Dominance);
        
        fileNames{f_ind} = sprintf('%s.csv',varNameT);
        varNames{f_ind} = varName;
        f_ind = f_ind+1;
%         writetable(betweenTable,fullfile(pwd,'CSV_Data',sprintf('%s.csv',varNameT)));
    end
end
% file_var_names = table(fileNames',varNames','VariableNames',{'Filenames','Varnames'});
% writetable(file_var_names,fullfile(pwd,'CSV_Data',sprintf('file_var_names.csv')))