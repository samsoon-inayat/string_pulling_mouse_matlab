function out = get_data(handles)

if ~isfield(handles,'figure1')
    out = [];
    return;
end

out = get(handles.text_data,'userdata');
