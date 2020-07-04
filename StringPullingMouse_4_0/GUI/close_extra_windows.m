function close_extra_windows(handles)

whs = get(handles.pushbutton_close_extra_windows,'userdata');
for ii = 2:length(whs)
    try
        close(whs{ii});
    catch
    end
end
set(handles.pushbutton_close_extra_windows,'userdata',whs(1));