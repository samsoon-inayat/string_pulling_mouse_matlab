function figure_temporal_changes_speed_three_groups
mData = evalin('base','mData'); colors = mData.colors; 

% allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
% variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
allVarNames = {'pdfFolder','configs'};
variablesToGetFromBase = {'pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end

data = get_data_from_base_ws('ent','AUD');
ds_data = get_data_from_base_ws('ds','AUD');
color_blind_map = load('colorblind_colormap.mat');

%% Entropy
runthis = 0;
if runthis
varName = 'motion.ent';
mds_data_r6 = get_masked_values_h(data.ent_r6,varName,ds_data.ds_r6,0.1,[-Inf Inf]);
mds_data_r7 = get_masked_values_h(data.ent_r7,varName,ds_data.ds_r7,0.1,[-Inf Inf]);
mds_data_rf = get_masked_values_h(data.ent_rf,varName,ds_data.ds_rf,0.1,[-Inf Inf]);

colVar1 = [ones(1,18)];
betweenTable = table(mds_data_r6.meanb',mds_data_r7.meanb',mds_data_rf.meanb','VariableNames',{'R6','R7','RF'});
withinTable = table([1 2 3]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
% writetable(rmaR.ranova,fullfile(pdfFolder,'temporal_entropy_ranova.xlsx'),'WriteRowNames',true)
% writetable(rmaR.mc_Type,fullfile(pdfFolder,'temporal_entropy_multiple_comparisons.xlsx'),'WriteRowNames',true);
n = 0;
write_ranova_tables_to_XL(rmaR,pdfFolder,'temporal_entropy');
hf = make_graph_whole_body_AUD(pdfFolder,'Temporal Entropy',rmaR,0.3,0.01);
ylims = ylim;
ylim([5 ylims(2)])
save_pdf(hf,pdfFolder,sprintf('Mean %s','Temporal Entropy'),600);
%%
return;
end

%% Higuchi
runthis = 1;
if runthis
varName = 'HFD.motion.ent'; 
mds_data_r6 = get_masked_values_h(data.ent_r6,varName,ds_data.ds_r6,0.1,[-Inf Inf]);

mds_data_r7 = get_masked_values_h(data.ent_r7,varName,ds_data.ds_r7,0.1,[-Inf Inf]);
mds_data_rf = get_masked_values_h(data.ent_rf,varName,ds_data.ds_rf,0.1,[-Inf Inf]);

colVar1 = [ones(1,18)];
betweenTable = table(mds_data_r6.meanb',mds_data_r7.meanb',mds_data_rf.meanb','VariableNames',{'R6','R7','RF'});
withinTable = table([1 2 3]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
% writetable(rmaR.ranova,fullfile(pdfFolder,'Higuchi_FD_ranova.xlsx'),'WriteRowNames',true)
% writetable(rmaR.mc_Type,fullfile(pdfFolder,'Higuchi_FD_multiple_comparisons.xlsx'),'WriteRowNames',true);
n = 0;
write_ranova_tables_to_XL(rmaR,pdfFolder,'Higuchi_FD');

hf = make_graph_whole_body_AUD(pdfFolder,'Higuchi FD',rmaR,0.1,0.01);
ylims = ylim;
ylim([1.5 ylims(2)])
save_pdf(hf,pdfFolder,sprintf('Mean %s','Higuchi FD'),600);
return;
end

%% Fano Factor
runthis = 1;
if runthis
varName = 'FF.motion.ent';
mds_data_r6 = get_masked_values_h(data.ent_r6,varName,ds_data.ds_r6,0.1,[-Inf Inf]);
mds_data_r7 = get_masked_values_h(data.ent_r7,varName,ds_data.ds_r7,0.1,[-Inf Inf]);
mds_data_rf = get_masked_values_h(data.ent_rf,varName,ds_data.ds_rf,0.1,[-Inf Inf]);

colVar1 = [ones(1,18)];
betweenTable = table(mds_data_r6.meanb',mds_data_r7.meanb',mds_data_rf.meanb','VariableNames',{'R6','R7','RF'});
withinTable = table([1 2 3]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
% writetable(rmaR.ranova,fullfile(pdfFolder,'Fano_Factor_ranova.xlsx'),'WriteRowNames',true)
% writetable(rmaR.mc_Type,fullfile(pdfFolder,'Fano_Factor_multiple_comparisons.xlsx'),'WriteRowNames',true);
n = 0;
make_graph_whole_body_AUD(pdfFolder,'Fano Factor',rmaR,0.1,0.01);
ylims = ylim;
ylim([0.22 ylims(2)])
return;
end

