function userProcess(handles)

if ~strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
    displayMessageBlinking(handles,'Please wait for completion of file loading',{'ForegroundColor','r'},3);
    return;
end

% userProcess1(handles);
% userProcess3(handles);
make_velocity_profile(handles);



