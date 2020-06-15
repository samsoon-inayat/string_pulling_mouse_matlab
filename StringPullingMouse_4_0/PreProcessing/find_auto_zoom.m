function find_auto_zoom(handles,frameNums)

% zw = getParameter(handles,'Zoom Window');

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
    image_resize_factor = 8;
end
% hf = figure_window(handles,100);
data = get_data(handles);
frames = data.frames;
frameNums1 = frameNums(1:5:length(frameNums));
for ii = 1:length(frameNums1)
    tic
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
        return;
    end
    fn = frameNums1(ii);
    thisFrame = frames{fn};
    bb = get_body_box(handles,fn,thisFrame,16,1);
%     hb = get_head_box(handles,fn,frames{fn},16);
%     thisFrameH = frames{fn}(hb(2):hb(4),hb(1):hb(3),:);
%     xBox = get_mouse_string_xBox(handles,fn,thisFrameH,[10,10]);
%     msint = find_mouse_string_intersection(handles,fn);
    displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',fn,ii,length(frameNums1),getTimeRemaining(length(frameNums1),ii)));
    % update display
    if get(handles.checkbox_updateDisplay,'Value')
        axes(handles.axes_main);cla
        imagesc(thisFrame);axis equal;axis off;
        title(sprintf('%d - Body Box',fn));
    %     displayFrames(handles,M.dfn,fn);
        zw = bb;
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
        pause(0.01);
    end
end
bbs = getParameter(handles,'Body Boxes');
temp = min(bbs(:,2:5)); sleft = temp(1); stop = temp(2);
temp = max(bbs(:,2:5)); sright = temp(3); sbottom = temp(4);
% sleft = min(temp);
% stop = min(top);
% sright = max(right);
% sbottom = max(bottom);
setParameter(handles,'Auto Zoom Window',[sleft stop sright sbottom]);
zw = [sleft stop sright sbottom];
set(handles.text_autoZoomWindow,'String',sprintf('[%d %d %d %d]',zw(1),zw(2),zw(3),zw(4)),'userdata',zw,'ForegroundColor','b');
thisFrame = frames{1}(zw(2):zw(4),zw(1):zw(3),:);
setParameter(handles,'Auto Zoom Window Size',[size(thisFrame,1) size(thisFrame,2)]);
displayMessage(handles,sprintf('Done! finding Auto Zoom window'),{'ForegroundColor','b'});

