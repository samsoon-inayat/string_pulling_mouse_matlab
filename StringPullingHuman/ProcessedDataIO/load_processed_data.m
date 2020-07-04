function [success,d] = load_processed_data(handles)

meta_data = get_meta_data(handles);
fieldNames = fields(meta_data);
for ii = 1:length(fieldNames)
    cmdTxt = sprintf('%s = meta_data.%s;',fieldNames{ii},fieldNames{ii});
    eval(cmdTxt);
end

if ~exist(results_file_name,'file')
    R = []; RE = []; 
    P = [];
    save(results_file_name,'R','RE','P','-v7.3');
end

if ~exist(resultsDLC_file_name,'file')
    R = [];
    save(resultsDLC_file_name,'R','-v7.3');
end

d.processed_data_folder = processed_data_folder;
if isfield(handles,'figure1')
    d.resultsMF = matfile(results_file_name,'writable',true);
    d.resultsDLCMF = matfile(resultsDLC_file_name,'writable',true);
    d.R = d.resultsMF.R;
    d.RDLCS = d.resultsDLCMF.R;
    d.P = d.resultsMF.P;
else
    resultsMF = matfile(results_file_name,'writable',true);
    resultsDLCMF = matfile(resultsDLC_file_name,'writable',true);
    d.R = resultsMF.R;
    d.RDLCS = resultsDLCMF.R;
    d.P = resultsMF.P;
end
success = 1;
