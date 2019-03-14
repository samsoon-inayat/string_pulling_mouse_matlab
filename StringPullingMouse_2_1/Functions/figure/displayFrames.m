function displayFrames(handles,fn,ofn)
try
    disp = handles.disp;
catch
    handles1 = guidata(handles.figure1);
    disp = handles1.disp;
end
global frames;
global cmasks;
frns = fn-1+reshape(1:(disp.numRs*disp.numCs),disp.numCs,disp.numRs)';
zw = getParameter(handles,'Zoom Window');
azw = getParameter(handles,'Auto Zoom Window');
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
% zw = handles.md.resultsMF.zoomWindow;
if ~isempty(zw)
    set(handles.pushbutton_zoom_window,'ForegroundColor',[0 0.6 0.2],'FontWeight','Bold');
    set(handles.text_zoomWindowSize,'String',sprintf('[%d %d %d %d]',zw),'ForegroundColor','b');
    tdx = zw(1)+20;
    tdy = zw(2)+20;
else
    set(handles.pushbutton_zoom_window,'ForegroundColor','r');
    set(handles.text_zoomWindowSize,'String','Not Set','ForegroundColor','r');
    tdx = 50;
    tdy = 70;
end
if ~isempty(azw)
    set(handles.text_autoZoomWindow,'String',sprintf('[%d %d %d %d]',azw),'ForegroundColor','b');
else
    set(handles.text_autoZoomWindow,'String','Not Set','ForegroundColor','r');

end
if ~isempty(getParameter(handles,'Scale'))
    set(handles.pushbutton_measure,'ForegroundColor',[0 0.6 0.2],'FontWeight','Bold');
else
    set(handles.pushbutton_measure,'ForegroundColor','r');
end
checkStatusOfColors(handles);
dispTags = get(handles.checkbox_displayTags,'Value');
dispScale = get(handles.checkbox_scaleBar,'Value');
if exist('ofn','var')
    onlyOne = 1;
else
    onlyOne = 0;
end
% temp = handles.md.resultsMF.diffColors(1,1);
% handColors = temp{1};
% global gradients;
uda = get(disp.ff.hf,'userdata');
srr = uda(2); scc = uda(3);
sz = handles.md.frameSize;
zf = zeros(sz);
masksMap = getParameter(handles,'Masks Order');
for rr = 1:disp.numRs
    for cc = 1:disp.numCs
        if onlyOne
            if frns(rr,cc) ~= ofn
                continue;
            end
        end
        axes(disp.ff.h_axes(rr,cc));
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
        if frns(rr,cc) > handles.d.number_of_frames
            set(disp.hims(rr,cc),'CData',[]);
            continue;
        else
            thisFrame = frames{frns(rr,cc)};
            if get(handles.checkbox_displayMasks,'Value')
                tMasks = get_masks_KNN(handles,frns(rr,cc));
                temp = zf; 
                tMask = cmasks(:,fn); % get the previous mask value. If not calculated before, it would be zeros
                btMask = de2bi(tMask,7);
                switch objectToProcess
                    case 1
%                         thisMask = tMasks.Im;
                        thisMask = reshape(btMask(:,1),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
                    case 2
%                         thisMask = tMasks.Ier | tMasks.Iel;
                        thisMask = reshape(btMask(:,2),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
                    case 3
%                         thisMask = tMasks.Ih;
                        thisMask = reshape(btMask(:,4),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
                end
                temp(azw(2):azw(4),azw(1):azw(3)) = thisMask;
                thisFrame = imoverlay(thisFrame,temp);
            end
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
        axis equal; axis off;
        if [rr,cc] == [srr,scc]
            if ~isempty(zw)
                rectangle('Position',[zw(1),zw(2),zw(3)-zw(1),zw(4)-zw(2)],'linewidth',3);
            else
                rectangle('Position',[1,1,sz(2)-1,sz(1)-1],'linewidth',3);
            end
            set(handles.figure1,'userdata',frns(rr,cc));
        end
        if get(handles.checkbox_framesDifference,'Value')
            text(tdx,tdy,sprintf('%d',frns(rr,cc)),'fontsize',9,'Color','w');
        else
            text(tdx,tdy+3,sprintf('%d',frns(rr,cc)),'fontsize',12,'Color','w','fontweight','Bold');
        end
        if dispTags
            plotTags(handles,disp.ff.h_axes(rr,cc),frns(rr,cc));
        end
        if dispScale
            
        end
        if ~isempty(zw)
            xlim([zw(1) zw(3)]);
            ylim([zw(2) zw(4)]);
        else
            xlim([1 sz(2)]);
            ylim([1 sz(1)]);
        end
    end
end
set(handles.slider1,'Value',fn);
% displayMasks(handles,fn);
figure(handles.figure1);
if ~get(handles.text_fileName,'userdata')
    if strcmp(get(handles.timer_video_loader,'Running'),'off')
        start(handles.timer_video_loader);
    end
else
    stop(handles.timer_video_loader);
end
set(handles.figure1,'userdata',frns(srr,scc));
set(handles.text_selected_frame,'String',sprintf('(%d)',frns(srr,scc)));
a = findall(handles.figure1,'Type','axes');
if ~isempty(a)
    delete(a);
end



