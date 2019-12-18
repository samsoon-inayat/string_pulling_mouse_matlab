function find_all_boxes(handles,frameNums)

zw = getParameter(handles,'Zoom Window');

if get(handles.checkbox_Reduce_Image_Size,'Value')
    try
        image_resize_factor = str2double(get(handles.edit_reduce_image_factor,'String'));
%         thisFrame = imresize(thisFrame,(1/image_resize_factor));
%         thisFrame = imresize(thisFrame,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
    catch
        displayMessageBlinking(handles,'Enter a number for image resize factor',{'ForegroundColor','r'},2);
        return;
    end
else
    image_resize_factor = 16;
end

ow = get(handles.checkbox_over_write,'Value');
hf = figure_window(handles,100,{'SameAsDisplayWindow'});
data = get_data(handles);
frames = data.frames;
frameNums1 = frameNums(1:length(frameNums));
% ow = 1;
bb = getParameter(handles,'Auto Zoom Window');
for ii = 1:length(frameNums1)
    tic
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
        return;
    end
    fn = frameNums1(ii);
    thisFrame = frames{fn};
    
%     bb = get_body_box(handles,fn,thisFrame,16,ow);
    if get(handles.checkbox_updateDisplay,'Value')
        figure(hf);subplot 121;imagesc(thisFrame);axis equal;axis off;title(sprintf('%d - Body Box',fn));zw = bb;xlim([zw(1) zw(3)]);ylim([zw(2) zw(4)]);pause(0.01);
    end
    
    hb = get_head_box(handles,fn,thisFrame,image_resize_factor,ow);
    if get(handles.checkbox_updateDisplay,'Value')
        figure(hf);subplot 122;imagesc(thisFrame);axis equal;axis off;title(sprintf('Head Box'));zw = hb;xlim([zw(1) zw(3)]);ylim([zw(2) zw(4)]);pause(0.01);
    end
%     xBox = get_mouse_string_xBox(handles,fn,thisFrame,image_resize_factor,[10,10],1);
%     if get(handles.checkbox_updateDisplay,'Value')
%         figure(hf);subplot 143;imagesc(thisFrame);axis equal;axis off;title(sprintf('Head Box'));zw = xBox;xlim([zw(1) zw(3)]);ylim([zw(2) zw(4)]);pause(0.01);
%     end
%     msint = find_mouse_string_intersection(handles,fn,ow);
%     hba = get_head_box_from_msint(handles,fn,frames{fn},msint,image_resize_factor,1);
    if ii < length(frameNums1)
        displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',frameNums1(ii+1),ii+1,length(frameNums1),getTimeRemaining(length(frameNums1),ii)));
    end
end
setParameter(handles,'Mouse String Boxes',[]);
setParameter(handles,'Mouse String Intersections',[]);
setParameter(handles,'Head Boxes from msint',[]);
displayMessage(handles,sprintf('Done! finding Head boxes'),{'ForegroundColor','b'});
close_extra_windows(handles);

