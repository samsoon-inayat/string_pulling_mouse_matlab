function out = get_meta_data(handles)

if ~isfield(handles,'figure1')
    out = handles.md;
else
    out = get(handles.text_meta_data,'userdata');
end
