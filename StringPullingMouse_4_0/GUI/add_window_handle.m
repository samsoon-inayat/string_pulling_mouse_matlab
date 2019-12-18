function add_window_handle(handles,hf)
if isfield(handles,'figure1')
    whs = get(handles.pushbutton_close_extra_windows,'userdata');
    whs{length(whs)+1} = hf;
    set(handles.pushbutton_close_extra_windows,'userdata',whs);
end