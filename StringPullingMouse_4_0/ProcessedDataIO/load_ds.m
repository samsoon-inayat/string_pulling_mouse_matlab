function ds = load_ds(handles)

[sfn,efn] = getFrameNums(handles);

if ~isfield(handles,'figure1')
    ds = get_file_data(handles.pd_folder,sfn,efn,'descriptive_statistics');
    return;
end

handles.md = get_meta_data(handles);
fileName = sprintf('descriptive_statistics_%d_%d.mat',sfn,efn);
fileName = fullfile(handles.md.processed_data_folder,fileName);
if exist(fileName,'file')
    ds = load(fileName);
%     view_descriptive_statistics(handles,ds,'descriptive_stats');
    return;
else
    ds = [];
end
