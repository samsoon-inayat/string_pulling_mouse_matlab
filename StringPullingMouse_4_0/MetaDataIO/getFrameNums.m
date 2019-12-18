function [sfn,efn] = getFrameNums(handles)

if ~isfield(handles,'figure1')
    % in case one passes a config file to this function 
    epochs = getParameter(handles,'Epochs');         
    sfn = epochs{1,1};    efn = epochs{1,2};
    return;
end

sfn = []; efn = [];
md = get_meta_data(handles);
framesToProcess = get(handles.uibuttongroup_framesToProcess,'userdata');
frames = get_frames(handles);
switch framesToProcess
    case 1
        sfn = get(handles.figure1,'userdata');
        efn = sfn;
    case 2
        sfn = round(get(handles.slider1,'Value'));
        efn = sfn + md.disp.numFrames - 1;
    case 3
        try
        data = get(handles.epochs,'Data');
        currentSelection = get(handles.epochs,'userdata');
        fn = data{currentSelection};
        if isempty(fn)
            uiwait(msgbox('Select an appropriate epoch','Success','modal'));
            return;
        end
        startEnd = cell2mat(data(currentSelection(1),:));
        sfn = startEnd(1);
        efn = startEnd(2);
        catch
            uiwait(msgbox('Select an appropriate epoch','Success','modal'));
            return;
        end
    case 4
        try
            sfn = str2double(get(handles.edit_fromFrame,'String'));
            efn = str2double(get(handles.edit_toFrame,'String'));
        catch
            return;
        end
end