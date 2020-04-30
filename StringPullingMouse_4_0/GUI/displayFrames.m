function displayFrames(handles,fn,ofn)
dispProps = get(handles.pushbutton_select_annotation_colors,'userdata');
md = get_meta_data(handles);
disp = md.disp;
data = get_data(handles);
frames = data.frames;
frns = fn-1+reshape(1:(disp.numRs*disp.numCs),disp.numCs,disp.numRs)';
zw = getParameter(handles,'Zoom Window');
azw = getParameter(handles,'Auto Zoom Window');
if ~isempty(azw) & get(handles.checkbox_select_auto_zoom_window,'Value')
    zw = azw;
end
if isempty(azw)
    set(handles.pushbutton_auto_zoom_change,'Visible','Off');
else
    set(handles.pushbutton_auto_zoom_change,'Visible','On');
end
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
% zw = handles.md.resultsMF.zoomWindow;
if ~isempty(zw)
    set(handles.pushbutton_zoom_window,'ForegroundColor',[0 0.6 0.2],'FontWeight','Bold');
    set(handles.text_zoomWindowSize,'String',sprintf('[%d %d %d %d]',zw),'ForegroundColor','b');
    set(handles.text_zoom_window,'String',sprintf('[%d %d %d %d]',zw));
    tdx = zw(1)+20;
    tdy = zw(2)+50;
else
    set(handles.pushbutton_zoom_window,'ForegroundColor','r');
    set(handles.text_zoomWindowSize,'String','Not Set','ForegroundColor','r');
    set(handles.text_zoom_window,'String','Not Set');
    tdx = 50;
    tdy = 70;
end
if ~isempty(azw)
    set(handles.text_autoZoomWindow,'String',sprintf('[%d %d %d %d]',azw),'ForegroundColor','b');
else
    set(handles.text_autoZoomWindow,'String','Not Set','ForegroundColor','r');
end
if ~isempty(getParameter(handles,'Scale'))
    set(handles.pushbutton_setScale,'ForegroundColor',[0 0.6 0.2],'FontWeight','Bold');
else
    set(handles.pushbutton_setScale,'ForegroundColor','r');
end
checkStatusOfColors(handles);
dispTags = get(handles.checkbox_displayTags,'Value');
dispScale = get(handles.checkbox_scaleBar,'Value');
if exist('ofn','var')
    onlyOne = 1;
else
    onlyOne = 0;
end

uda = get(disp.ff.hf,'userdata');
srr = uda(2); scc = uda(3);
sz = data.frame_size;
zf = zeros(sz);
for rr = 1:disp.numRs
    for cc = 1:disp.numCs
        if onlyOne
            if frns(rr,cc) ~= ofn
                continue;
            end
        end
%         axes(disp.ff.h_axes(rr,cc));
%         cla
        set(disp.ff.h_axes(rr,cc),'userdata',frns(rr,cc));
        h_children = get(disp.ff.h_axes(rr,cc),'Children');
        for ii = 1:length(h_children)
            if strcmp(h_children(ii).Type,'line')
                delete(h_children(ii));
                continue;
            end
            if strcmp(h_children(ii).Type,'text')
                delete(h_children(ii));
                continue;
            end
        end
        if frns(rr,cc) > data.number_of_frames
            set(disp.hims(rr,cc),'CData',[]);
            continue;
        else
            if get(handles.checkbox_displayMasks,'Value')
                tMask = get_mask(handles,frns(rr,cc),objectToProcess);
            end
            if get(handles.checkbox_displayCMasks,'Value')
                if objectToProcess == 2 % for ears
                    tMask = get_object_mask(handles,frns(rr,cc),[2 3]); tMask = tMask(:,:,1) | tMask(:,:,2);
                elseif objectToProcess == 3 % for hands
                    tMask = get_object_mask(handles,frns(rr,cc),[5 6]); tMask = tMask(:,:,1) | tMask(:,:,2);
                else
                    tMask = get_object_mask(handles,frns(rr,cc),objectToProcess);
                end
            end
            if get(handles.checkbox_displayMasks,'Value') | get(handles.checkbox_displayCMasks,'Value')
%                 btMask = de2bi(tMask,8);
%                 if objectToProcess == 1 | objectToProcess == 4 | objectToProcess == 5
%                     thisMask = reshape(btMask(:,objectToProcess),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                 end
%                 if objectToProcess == 6
%                     thisMask = reshape(btMask(:,7),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                 end
%                 if objectToProcess == 2
%                     if get(handles.checkbox_displayCMasks,'Value')
%                         thisMask = reshape(btMask(:,2),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                         thisMask = thisMask | reshape(btMask(:,3),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                     else
%                         thisMask = reshape(btMask(:,2),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                     end
%                 end
%                 if objectToProcess == 3
%                     if get(handles.checkbox_displayCMasks,'Value')
%                         thisMask = reshape(btMask(:,5),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                         thisMask = thisMask | reshape(btMask(:,6),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                     else
%                         thisMask = reshape(btMask(:,3),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
%                     end
%                 end
                tM = zf;
                if ~isempty(tMask)
                    tM(azw(2):azw(4),azw(1):azw(3)) = tMask;
                end
%                 thisFrame = frames{frns(rr,cc)};
%                 thisFrame = imoverlay(thisFrame,tM);
                thisFrame = tM;
            else
                if get(handles.checkbox_imcomplement,'Value')
                    thisFrame = imcomplement(frames{frns(rr,cc)});
                else
                    thisFrame = frames{frns(rr,cc)};
                end
            end
            
% %             if get(handles.checkbox_displayMasks,'Value')
% %                 tMasks = get_masks_KNN(handles,frns(rr,cc));
% %                 temp = zf; 
% %                 if objectToProcess == 5
% %                     tMask = masks.frameMasks(:,frns(rr,cc)); % get the previous mask value. If not calculated before, it would be zeros
% %                 else
% %                     tMask = cmasks(:,frns(rr,cc)); % get the previous mask value. If not calculated before, it would be zeros
% %                 end
% %                 btMask = de2bi(tMask,7);
% % %                 switch objectToProcess
% %                     thisMask = reshape(btMask(:,objectToProcess),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
% % %                     case 1
% % % %                         thisMask = tMasks.Im;
% % %                         
% % %                     case 2
% % % %                         thisMask = tMasks.Ier | tMasks.Iel;
% % %                         thisMask = reshape(btMask(:,2),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
% % %                     case 3
% % % %                         thisMask = tMasks.Ih;
% % %                         thisMask = reshape(btMask(:,3),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
% % %                     case 4
% % %                         thisMask = reshape(btMask(:,4),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
% % %                 end
% %                 temp(azw(2):azw(4),azw(1):azw(3)) = thisMask;
% %                 thisFrame = imoverlay(thisFrame,temp);
% %             end
%             thisGradient = reshape(gradients(:,frns(rr,cc)),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
%             tM = zeros(size(thisFrame(:,:,1)));
%             tM(zw(2):zw(4),zw(1):zw(3)) = thisGradient;
%             thisFrame = tM;
            if get(handles.checkbox_framesDifference,'Value')
                if frns(rr,cc) > 1
                    thisFramem1 = frames{frns(rr,cc)-1};
                    if get(handles.radiobutton_backwardFrameDifference,'Value')
                        thisFrame = thisFrame - thisFramem1;
                    else
                        thisFrame = thisFramem1 - thisFrame;
                    end
%                     thisFrame = imadjust(thisFrame,[handColors(3,:)-20*handColors(4,:);handColors(3,:)+20*handColors(4,:)]/255,[]);
%                     thisFrame = imadjust(thisFrame,[0.5 0.3 0.2;0.7 0.7 0.7]/255,[]);
                end
            end
%             thisFrame = double(rgb2gray(thisFrame));
%             thisFrame = imgradient(thisFrame);
%             thisFrame = imgradient(thisFrame);
            set(disp.hims(rr,cc),'CData',thisFrame);
        end
%         axis equal; axis off;
        if [rr,cc] == [srr,scc]
            if ~isempty(zw)
                thrects = findobj(gca,'Type','Rectangle');
                if ~isempty(thrects)
                    delete(thrects);
                end
                rectangle(disp.ff.h_axes(rr,cc),'Position',[zw(1),zw(2),zw(3)-zw(1),zw(4)-zw(2)],'linewidth',dispProps.selectRectangle_linewidth,'EdgeColor',dispProps.selectRectangle_color);
            else
                rectangle(disp.ff.h_axes(rr,cc),'Position',[1,1,sz(2)-1,sz(1)-1],'linewidth',dispProps.selectRectangle_linewidth,'EdgeColor',dispProps.selectRectangle_color);
            end
            set(handles.figure1,'userdata',frns(rr,cc));
        end
        if get(handles.checkbox_framesDifference,'Value')
            text(disp.ff.h_axes(rr,cc),tdx,tdy,sprintf('%d',frns(rr,cc)),'fontsize',9,'Color','w');
        else
            if get(handles.checkbox_display_DLC_results,'Value') & get(handles.checkbox_displayTags,'Value')
                text(disp.ff.h_axes(rr,cc),tdx,tdy+3,sprintf('%d',frns(rr,cc)),'fontsize',12,'Color','w','fontweight','Bold');
                text(disp.ff.h_axes(rr,cc),tdx,tdy+100,sprintf('DLC'),'fontsize',12,'Color','w','fontweight','Bold');
            else
                text(disp.ff.h_axes(rr,cc),tdx,tdy+3,sprintf('%d',frns(rr,cc)),'fontsize',12,'Color',dispProps.frameNumber_Text_Color,'fontweight','Bold');
            end
        end
        if dispTags
            plotTags(handles,disp.ff.h_axes(rr,cc),frns(rr,cc));
        end
        if dispScale
            
        end
        if ~isempty(zw)
            xlim(disp.ff.h_axes(rr,cc),[zw(1) zw(3)]);
            ylim(disp.ff.h_axes(rr,cc),[zw(2) zw(4)]);
        else
            xlim(disp.ff.h_axes(rr,cc),[1 sz(2)]);
            ylim(disp.ff.h_axes(rr,cc),[1 sz(1)]);
        end
    end
end
set(handles.slider1,'Value',fn);
set(handles.text_display_frames,'String',sprintf('Frames %d - %d (%d)',min(frns(:)),max(frns(:)),frns(srr,scc)));
% displayMasks(handles,fn);
figure(handles.figure1);
% if ~get(handles.text_fileName,'userdata')
%     if strcmp(get(handles.timer_video_loader,'Running'),'off')
%         start(handles.timer_video_loader);
%     end
% else
%     stop(handles.timer_video_loader);
% end
set(handles.figure1,'userdata',frns(srr,scc));
set(handles.text_selected_frame,'String',sprintf('(%d)',frns(srr,scc)));
% a = findall(handles.figure1,'Type','axes');
% if ~isempty(a)
%     delete(a);
% end
figure(disp.ff.hf);
if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
    set(handles.axes_main,'Visible','Off');
    cla(handles.axes_main);
end