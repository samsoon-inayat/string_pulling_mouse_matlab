function ds = load_dsm(handles)

if ~isfield(handles,'figure1')
    [sfn,efn] = getFrameNums(handles);
    ds = get_file_data(handles.pd_folder,sfn,efn,'descriptive_statistics_masks');
    return;
end
