function out = get_data(handles)

if ~isfield(handles,'figure1')
    out = handles.data;
    return;
end

out = get(handles.text_data,'userdata');
