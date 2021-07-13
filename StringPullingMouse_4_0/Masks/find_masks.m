function find_masks (handles,object,sfn,efn)

% if ~get(handles.checkbox_useSimpleMasks,'Value')
%     displayMessageBlinking(handles,'Please wait ... starting process',{'ForegroundColor','r'},3);
%     pause(0.1);
% end
md = get_meta_data(handles);
% st = floor((getParameter(handles,'String Thickness in Pixels')));
% if isempty(st) && get(handles.radiobutton_GridWay,'Value')
%     displayMessageBlinking(handles,'Measure String thickness first',{'ForegroundColor','r'},2);
%     return;
% end

masksMap = {'body','ears','hands','nose','string','hands_bd','background'};
objectsMap = {'Fur';'Ears';'hands';'Nose';'String';'';'Background'};
% string_thickness = {st;st/2;st/2;st/2;st/2;st;st};
omasksMap = {'body','right ear','left ear','nose','right hand','left hand','string','background'};
setParameter(handles,'Masks Order',masksMap);
setParameter(handles,'Object Masks Order',omasksMap);
if strcmp(object,'all')
    os = [1 2 3 4 5];
else
    ind = find(strcmp(masksMap,object));
    os = ind;
end
% os = 6;
frames = get_frames(handles);
frameNums = sfn:efn;
% zw = handles.md.resultsMF.zoomWindow;
zw = getParameter(handles,'Auto Zoom Window');
if isempty(zw)
    displayMessageBlinking(handles,'No Zoom Window for Masks ... go to step 3',{'ForegroundColor','r'},3);
    return;
end

if get(handles.checkbox_Reduce_Image_Size,'Value')
    try
        image_resize_factor = str2double(get(handles.edit_reduce_image_factor,'String'));
    catch
        displayMessageBlinking(handles,'Enter a number for image resize factor',{'ForegroundColor','r'},2);
        return;
    end
end
% para_CLG = [alpha_1,ratio_1,minWidth_1,nOuterFPIterations_1,nInnerFPIterations_1,nSORIterations_1];
para_CLG = [0.01,0.5,20,7,1,30];
% hf = figure(100);clf;
startTime = tic;
for oo = 1:length(os)
    object = masksMap{os(oo)};
    ind = find(strcmp(masksMap,object));
    for jj = 1:length(frameNums)
        tic
        pause(0.1);
        if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
            axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
            break;
        end
        fn = frameNums(jj);
        try
            mask = get_mask(handles,fn,ind);
        catch
            displayMessageBlinking(handles,'Inconsistent data set, auto zoom window was perhaps changed after finding masks, find all masks again',{},3);
            answer = questdlg('Would you like to delete all old masks files?', ...
                            'Please choose', ...
                            'Yes','No');
            if strcmp(answer,'No')
                return;
            else
                folderName = fullfile(md.processed_data_folder,'masks');
                files = dir(folderName);
                for ff = 1:length(files)
                    if ~files(ff).isdir
                        fileName = fullfile(folderName,files(ff).name);
                        delete(fileName);
                    end
                end
                displayMessage(handles,sprintf('All files deleted ... find masks again'));
                return;
            end
        end
        if sum(mask(:))>0 && ~get(handles.checkbox_over_write,'Value')
            displayMessage(handles,sprintf('Finding %s masks ... Processing frame -%d, %d/%d ... time remaining %s',object,fn,jj,length(frameNums),getTimeRemaining(length(frameNums),jj)));
            continue;
        end
        if strcmp(object,'hands_bd') && fn == 1
            continue;
        end
        if strcmp(object,'hands_bd')
            thisFrame = frames{fn}-frames{fn-1};
        else
            thisFrame = frames{fn};
            if fn > 1
                previousFrame = frames{fn-1};
            end
        end
        if (strcmp(object,'nose') && get(handles.checkbox_use_head_box_nose,'Value')) || (strcmp(object,'ears') && get(handles.checkbox_use_headbox,'Value'))
            try
%                 msint = find_mouse_string_intersection(handles,fn,1);
%                 hb = get_head_box_from_msint(handles,fn,thisFrame,msint,1);
                hb = get_head_box(handles,fn,thisFrame,16,0);
                thisFrame = thisFrame(hb(2):hb(4),hb(1):hb(3),:);
                headBoxUsed = 1;
            catch
                headBoxUsed = 0;
                displayMessage(handles,'Couldn''t use head box');
                thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
            end
        else
            headBoxUsed = 0;
            thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
            if fn > 1
                previousFrame = previousFrame(zw(2):zw(4),zw(1):zw(3),:);
            end
        end
        
        if get(handles.checkbox_Reduce_Image_Size,'Value') & ~strcmp(object,'nose')
            frame1 = imresize(thisFrame,(1/image_resize_factor));
        else
            frame1 = thisFrame;
        end
        if get(handles.radiobutton_KNN,'Value')
            mask = compute_masks_KNN(handles,frame1,object,0);
        end
        if get(handles.radiobutton_GridWay,'Value')
            grid_specs = get_grid_specs(handles);
            [success,mask] = find_mask_grid_way(handles,frame1,getColors(handles,objectsMap{ind},4:6,0),grid_specs);
            if ~success
%                 mask = compute_masks_range_search(handles,frame1,object,0);
                continue;
            end
        end
        if get(handles.radiobutton_Simple,'Value')
            mask = compute_masks_range_search(handles,frame1,object,0);
        end
        if get(handles.checkbox_Reduce_Image_Size,'Value') & ~strcmp(object,'nose')
            mask = imresize(mask,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
            mask(mask>0) = 1; mask(mask<0) = 0;
            mask = bwareaopen(mask,500);
%             mask = imerode(mask,se);
        end
        if strcmp(object,'nose') || strcmp(object,'ears') && get(handles.checkbox_use_headbox,'Value')
            if headBoxUsed
                tmask = zeros(size(frames{fn},1),size(frames{fn},2));
                tmask(hb(2):hb(4),hb(1):hb(3)) = mask;
                mask = tmask(zw(2):zw(4),zw(1):zw(3));
                thisFrame = frames{fn};
                thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
            end
        end
        
        if fn>1
            thisFrameR = mean(imresize(thisFrame,(1/4)),3);
            previousFrameR = mean(imresize(previousFrame,(1/4)),3);
            [vx,vy,~] = Coarse2FineTwoFrames(previousFrameR,thisFrameR,para_CLG);
            speedFrame = abs(vx + i*vy);
            speedMask = speedFrame > nanmean(speedFrame(:)) + 3*nanstd(speedFrame(:));
%             [regions_f,rrs] = detectMSERFeatures(thisFrameR,'ThresholdDelta',0.1);
%             mask_r = makeMaskFromRegions(handles,thisFrame,rrs);
            n = 0;
        end
        save_mask(handles,fn,object,mask);
        if get(handles.checkbox_updateDisplay,'Value')
%             axes(handles.axes_main);cla
            Im = imoverlay(thisFrame,mask);
            imagesc(handles.axes_main,Im);axis equal;axis off;
            xlim([1 size(Im,2)]);ylim([1 size(Im,1)]);
            title(fn);
        end
%         bpMask(:,ind) = reshape(mask,numel(mask),1);
%         %         if strcmp(object,'hands') && fn > 1
%         %             thisFramem1 = frames{fn-1};
%         %             thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
%         %             bthisFrame = thisFrame - thisFramem1;
%         %             fthisFrame = thisFramem1 - thisFrame;
%         %             mask = compute_masks_KNN(handles,bthisFrame,'handsb');
%         %             bpMask(:,6) = reshape(mask,numel(mask),1);
%         % %             mask = compute_masks_KNN(handles,fthisFrame,'handsf');
%         % %             bpMask(:,7) = reshape(mask,numel(mask),1);
%         %         end
%         dpMask = (bi2de(bpMask));
%         fMasks(:,fn) = uint8(dpMask);
        displayMessage(handles,sprintf('Finding %s masks ... Processing frame -%d, %d/%d ... time remaining %s',object,fn,jj,length(frameNums),getTimeRemaining(length(frameNums),jj)));
    end
end
endTime = toc(startTime);
displayMessage(handles,sprintf('Done processing frames from %d to %d - Total Time Taken = %.3f s',sfn,sfn+jj-1,endTime));
