function [sfn,efn] = getFrameNums(handles)

framesToProcess = get(handles.uibuttongroup_framesToProcess,'userdata');
global frames;
switch framesToProcess
    case 1
        sfn = get(handles.figure1,'userdata');
        efn = sfn;
    case 2
        sfn = round(get(handles.slider1,'Value'));
        efn = sfn + handles.disp.numFrames - 1;
    case 3
        try
        data = get(handles.epochs,'Data');
        currentSelection = get(handles.epochs,'userdata');
        fn = data{currentSelection};
        if isempty(fn)
            msgbox('Select an appropriate epoch');
        end
        startEnd = cell2mat(data(currentSelection(1),:));
        sfn = startEnd(1);
        efn = startEnd(2);
        catch
            msgbox('Select an appropriate epoch');
        end
    case 4
        sfn = 1;
        efn = length(frames);
end