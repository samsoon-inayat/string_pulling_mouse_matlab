function NN_plots

mainDataTable = evalin('base','NN.PARK_all_Pram');
pdfFolder = [evalin('base','pdfFolder') '\NN'];
varNames = mainDataTable.Properties.VariableNames;
all_var_names = varNames;

% NoN_DOM search
indp  = [];
for ii = 1:length(varNames)
    thisVarName = varNames{ii};
    if ~isempty(strfind(thisVarName,'NoN_DOM'))
        indp = [indp ii];
    end
end

non_dom_var_names = varNames(indp);

for ii = 1:length(non_dom_var_names)
    param_names{ii} = non_dom_var_names{ii}(1:(end-8));
end

indpo = [];
for ii = 1:length(varNames)
    thisVarName = varNames{ii};
    if isempty(strfind(thisVarName,'_DOM'))
        indpo = [indpo ii];
    end
end

param_names_other = varNames(indpo(2:end));

for ii = 1:length(param_names)
    [between,within] = build_table_dom_non_dom(mainDataTable,param_names{ii});
    rmaR{ii} = repeatedMeasuresAnova(between,within);
    out = rmaR{ii};
    h_Group(ii) = out.ranova{2,5} < 0.05;
    h_Type(ii) = out.ranova{4,5} < 0.05;
    h_Dominance(ii) = out.ranova{7,5} < 0.05;
end
h_Group_i = find(h_Group);
for iii = 1:length(h_Group_i)
    ii = h_Group_i(iii);
    out = rmaR{ii};
    n = 0;
    make_graph(pdfFolder,param_names{ii},out);
end
n = 0;

function [data_table,withinTable] = build_table_dom_non_dom(mainDataTable,param_name)
varNames = mainDataTable.Properties.VariableNames;
param_name_dom = [param_name '_DOM'];
param_name_non_dom = [param_name '_NoN_DOM'];
for ii = 1:length(varNames)
    if strcmp(param_name_dom,varNames{ii})
        ind_dom = ii;
    end
    if strcmp(param_name_non_dom,varNames{ii})
        ind_non_dom = ii;
    end
end

group_names = {'Young','OLD','PARK'};
N = [10,16,8];
type_names = {'Pantomime','Real'};
data_table = table();
column_names = [];
for ii = 1:length(group_names)
    vals = [];
    for jj = 1:length(type_names)
        name_to_search = [group_names{ii} ' ' type_names{jj}];
        ind = [];
        for rr = 1:size(mainDataTable,1)
            if strcmp(mainDataTable{rr,1},name_to_search)
                ind = [ind rr];
            end
        end
        if jj == 1
            vals(:,1) = mainDataTable{ind,ind_dom}; 
            vals(:,2) = mainDataTable{ind,ind_non_dom};
        else
            vals(:,3) = mainDataTable{ind,ind_dom}; 
            vals(:,4) = mainDataTable{ind,ind_non_dom};
        end
    end
    vals = [ii*ones(size(ind')) vals];
    data_table = [data_table;array2table(vals)];
end
column_names = [];
for jj = 1:length(type_names)
    column_names = [column_names {[param_name_dom '_' type_names{jj}]}];
    column_names = [column_names {[param_name_non_dom '_' type_names{jj}]}];
end
data_table.Properties.VariableNames = {'Group',column_names{:}};
data_table.Group = categorical(data_table.Group);
withinTable = table([1 1 2 2]',[1 2 1 2]','VariableNames',{'Type','Dominance'});
withinTable.Type = categorical(withinTable.Type);
withinTable.Dominance = categorical(withinTable.Dominance);




