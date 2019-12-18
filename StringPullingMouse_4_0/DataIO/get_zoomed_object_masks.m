function [fnm,image_resize_factor] = get_zoomed_object_masks(handles,frameNums,selfRun,groups)

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

temp = get_object_mask(handles,sfn,1);
if image_resize_factor ~=1
    temp = imresize(temp,(1/image_resize_factor)); 
end


objects = [];
for ii = 1:length(groups)
    objects = [objects groups{ii}];
    fnm{ii} = zeros(size(temp,1),size(temp,2),length(frameNums));
end
objects = sort(objects);


for ii = 1:length(frameNums)
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off') && selfRun == 0
        axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
        break;
    end
    fn = frameNums(ii);
    allMasks = get_object_mask(handles,fn,objects);
    zF = zeros(size(allMasks(:,:,1)));
    for gg = 1:length(groups)
        thisGroup = groups{gg};
        groupMask = zF;
        for mm = 1:length(thisGroup)
            ind = objects == thisGroup(mm);
            groupMask = groupMask | allMasks(:,:,ind);
        end
        if image_resize_factor ~=1
            groupMask = imresize(groupMask,(1/image_resize_factor)); 
        end
        fnm{gg}(:,:,ii) = groupMask;
    end
    displayMessage(handles,sprintf('Getting body, nose, ears, and hands object-masks, %d/%d',ii,length(frameNums)));
end


