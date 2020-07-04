function set_processing_mode_gui (handles,val)

if val == 1
    enable_disable(handles,0);
    set(handles.axes_main,'Visible','On');
    axes(handles.axes_main);cla;axis off;
    set(handles.pushbutton_stop_processing,'visible','on');
end
if val == 0
    enable_disable(handles,1);
    axes(handles.axes_main);cla;
    set(handles.axes_main,'Visible','Off');
    set(handles.pushbutton_stop_processing,'visible','off');
    close_extra_windows(handles);
end

if val == 2
    enable_disable(handles,1);
    axes(handles.axes_main);cla;
    set(handles.axes_main,'Visible','Off');
    set(handles.pushbutton_stop_processing,'visible','off');
end

pause(0.1);
