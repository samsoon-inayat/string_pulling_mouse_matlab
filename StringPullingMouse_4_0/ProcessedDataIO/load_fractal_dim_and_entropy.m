function ds = load_fractal_dim_and_entropy(handles)

if ~isfield(handles,'figure1')
    [sfn,efn] = getFrameNums(handles);
    ds = get_file_data(handles.pd_folder,sfn,efn,'fractal_dim_and_entropy');
    return;
end
