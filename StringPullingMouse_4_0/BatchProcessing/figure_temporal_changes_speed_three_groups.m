function figure_temporal_changes_speed_three_groups
mData = evalin('base','mData'); colors = mData.colors; 

% allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
% variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
% allVarNames = {'pdfFolder','configs'};
% variablesToGetFromBase = {'pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end

% data = get_data('ent');
% ds_data = get_data('ds');
color_blind_map = load('colorblind_colormap.mat');
n = 0;
%% Entropy
runthis = 1;
if runthis
varName = 'motion.ent';
mds_data_o_p = get_masked_values_h(data.ent_o_p,varName,ds_data.ds_o_p,0.1,[-Inf Inf]);
mds_data_o_r = get_masked_values_h(data.ent_o_r,varName,ds_data.ds_o_r,0.1,[-Inf Inf]);
mds_data_p_p = get_masked_values_h(data.ent_p_p,varName,ds_data.ds_p_p,0.1,[-Inf Inf]);
mds_data_p_r = get_masked_values_h(data.ent_p_r,varName,ds_data.ds_p_r,0.1,[-Inf Inf]);
mds_data_y_p = get_masked_values_h(data.ent_y_p,varName,ds_data.ds_y_p,0.1,[-Inf Inf]);
mds_data_y_r = get_masked_values_h(data.ent_y_r,varName,ds_data.ds_y_r,0.1,[-Inf Inf]);
% outp = get_masked_values_h(ds_bp,ds_wp,varName,ds_bp,ds_wp,0.1,[0 Inf]);
% outr = get_masked_values_h(ds_br,ds_wr,varName,ds_br,ds_wr,0.1,[0 Inf]);
colVar1 = [ones(1,10) 2*ones(1,16) 3*ones(1,8)];
betweenTableOld = table(mds_data_o_p.meanb',mds_data_o_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTablePrkn = table(mds_data_p_p.meanb',mds_data_p_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTableYoung = table(mds_data_y_p.meanb',mds_data_y_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableYoung;betweenTableOld;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
n = 0;
make_graph_whole_body(pdfFolder,'Temporal Entropy',rmaR);
%%
return;
end

%% Higuchi
runthis = 0;
if runthis
varName = 'HFD.motion.ent'; 
mds_data_o_p = get_masked_values_h(data.ent_o_p,varName,ds_data.ds_o_p,0.1,[-Inf Inf]);
mds_data_o_r = get_masked_values_h(data.ent_o_r,varName,ds_data.ds_o_r,0.1,[-Inf Inf]);
mds_data_p_p = get_masked_values_h(data.ent_p_p,varName,ds_data.ds_p_p,0.1,[-Inf Inf]);
mds_data_p_r = get_masked_values_h(data.ent_p_r,varName,ds_data.ds_p_r,0.1,[-Inf Inf]);
mds_data_y_p = get_masked_values_h(data.ent_y_p,varName,ds_data.ds_y_p,0.1,[-Inf Inf]);
mds_data_y_r = get_masked_values_h(data.ent_y_r,varName,ds_data.ds_y_r,0.1,[-Inf Inf]);
% outp = get_masked_values_h(ds_bp,ds_wp,varName,ds_bp,ds_wp,0.1,[0 Inf]);
% outr = get_masked_values_h(ds_br,ds_wr,varName,ds_br,ds_wr,0.1,[0 Inf]);
colVar1 = [ones(1,10) 2*ones(1,16) 3*ones(1,8)];
betweenTableOld = table(mds_data_o_p.meanb',mds_data_o_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTablePrkn = table(mds_data_p_p.meanb',mds_data_p_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTableYoung = table(mds_data_y_p.meanb',mds_data_y_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableYoung;betweenTableOld;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
n = 0;
make_graph_whole_body(pdfFolder,'Higuchi FD',rmaR);
return;
end

%% Fano Factor
runthis = 0;
if runthis
varName = 'FF.motion.ent';
mds_data_o_p = get_masked_values_h(data.ent_o_p,varName,ds_data.ds_o_p,0.1,[-Inf Inf]);
mds_data_o_r = get_masked_values_h(data.ent_o_r,varName,ds_data.ds_o_r,0.1,[-Inf Inf]);
mds_data_p_p = get_masked_values_h(data.ent_p_p,varName,ds_data.ds_p_p,0.1,[-Inf Inf]);
mds_data_p_r = get_masked_values_h(data.ent_p_r,varName,ds_data.ds_p_r,0.1,[-Inf Inf]);
mds_data_y_p = get_masked_values_h(data.ent_y_p,varName,ds_data.ds_y_p,0.1,[-Inf Inf]);
mds_data_y_r = get_masked_values_h(data.ent_y_r,varName,ds_data.ds_y_r,0.1,[-Inf Inf]);
% outp = get_masked_values_h(ds_bp,ds_wp,varName,ds_bp,ds_wp,0.1,[0 Inf]);
% outr = get_masked_values_h(ds_br,ds_wr,varName,ds_br,ds_wr,0.1,[0 Inf]);
colVar1 = [ones(1,10) 2*ones(1,16) 3*ones(1,8)];
betweenTableOld = table(mds_data_o_p.meanb',mds_data_o_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTablePrkn = table(mds_data_p_p.meanb',mds_data_p_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTableYoung = table(mds_data_y_p.meanb',mds_data_y_r.meanb','VariableNames',{'Pantomime','Real'});
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableYoung;betweenTableOld;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([1 2]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rmaR = repeatedMeasuresAnova(betweenTable,withinTable);
n = 0;
make_graph_whole_body(pdfFolder,'Fano Factor',rmaR);
return;
end

