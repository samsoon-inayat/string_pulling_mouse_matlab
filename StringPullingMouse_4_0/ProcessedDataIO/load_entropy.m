function ent = load_entropy(handles)
[sfn,efn] = getFrameNums(handles);
if ~isfield(handles,'figure1')
    ent = get_file_data(handles.pd_folder,sfn,efn,'entropy');
    return;
else
    handles.md = get_meta_data(handles);
    ent = get_file_data(handles.md.processed_data_folder,sfn,efn,'entropy');
end
