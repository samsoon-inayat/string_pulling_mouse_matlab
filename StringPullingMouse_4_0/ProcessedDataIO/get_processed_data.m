function out = get_processed_data (handles)

if isfield(handles,'figure1')
    out = get(handles.text_processed_data,'userdata');
else
    [~,out] = load_processed_data(handles);
end