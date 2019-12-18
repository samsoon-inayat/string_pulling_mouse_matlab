function [fn,imrf] = get_zoomed_frames(handles,frameNums,selfRun)

if ~isfield(handles,'figure1')
    imrf = selfRun;
    sfn = frameNums(1);
    efn = frameNums(end);
    fileName = sprintf('zoomed_frames_%d_%d_%d',sfn,efn,imrf);
    fileName = fullfile(handles.pd_folder,fileName);
    tud = load(fileName);
    fn = tud.fn;
    imrf = tud.image_resize_factor;
    return;
end

if get(handles.checkbox_Reduce_Image_Size,'Value')
    try
        image_resize_factor = str2double(get(handles.edit_reduce_image_factor,'String'));
    catch
        displayMessageBlinking(handles,'Enter a valid number for image resize factor',{'ForegroundColor','r'},2);
        return;
    end
else
    image_resize_factor = 1;
end
handles.md = get_meta_data(handles);
sfn = frameNums(1);
efn = frameNums(end);

ud = get(handles.pushbutton_findMouse,'userdata');
if ~isempty(ud)
    for ii = 1:length(ud)
        tud = ud{ii};
        if tud.sfn == sfn && tud.efn == efn && tud.image_resize_factor == image_resize_factor;
           fn = tud.fn;
           imrf = tud.image_resize_factor;
           return;
        end
    end
end



frames = get_frames(handles);
zw = getParameter(handles,'Auto Zoom Window');

for ii = 1:length(frameNums)
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off') && selfRun == 0
        axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
        break;
    end
    temp = frames{frameNums(ii)}; 
    temp = temp(zw(2):zw(4),zw(1):zw(3),:); 
    if image_resize_factor ~=1
        temp = imresize(temp,(1/image_resize_factor)); 
    end
    fn{ii} = temp;
end

tud.sfn = sfn;
tud.efn = efn;
tud.image_resize_factor = image_resize_factor;
tud.fn = fn;
imrf = tud.image_resize_factor;
ud{length(ud)+1} = tud;
set(handles.pushbutton_findMouse,'userdata',ud);

fileName = sprintf('zoomed_frames_%d_%d_%d',sfn,efn,imrf);
fileName = fullfile(handles.md.processed_data_folder,fileName);
save(fileName,'-struct','tud');
