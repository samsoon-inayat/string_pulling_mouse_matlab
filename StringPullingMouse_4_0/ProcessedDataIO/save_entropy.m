function save_entropy(handles,data)

if ~isfield(handles,'figure1')
    [sfn,efn] = getFrameNums(handles);
    save_file_data(handles.pd_folder,sfn,efn,'entropy',data);
    return;
end
