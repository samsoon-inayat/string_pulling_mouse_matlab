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

data = get_data_from_base_ws('pcs','AUD');
color_blind_map = load('colorblind_colormap.mat');
groups = {'r6','r7','rf'};
%%
data_table = table();
for gg = 1:length(groups)
    vals = [];
    for tt = 1
        cmdTxt = sprintf('temp = data.pcs_%s;',groups{gg});
        eval(cmdTxt);
        for an = 1:length(temp)
            vals(an,tt) = temp{an}.motion.explained(1);
        end
    end
    vals = [gg*ones(length(temp),1) vals];
    data_table = [data_table;array2table(vals)];
end

betweenTable = array2table(reshape(data_table{:,2},18,3));
betweenTable.Properties.VariableNames = {'R6','R7','RF'};
withinTable = table([1 2 3]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
n = 0;
%%
varNameT = 'PCs_EV';
hf = make_graph_whole_body_AUD(pdfFolder,'PCs Exp. Var.',rmaR,6,0.1);
ylims = ylim;
ylim([0 ylims(2)])
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
