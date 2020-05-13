function disp = initializeDisplayWindow (handles)

frames = get_frames(handles);
numRs = str2double(get(handles.edit_dispRows,'String'));
numCs = str2double(get(handles.edit_dispCols,'String'));
zw = getParameter(handles,'Zoom Window');
azw = getParameter(handles,'Auto Zoom Window');
if ~isempty(azw) & get(handles.checkbox_select_auto_zoom_window,'Value')
    zw = azw;
end
if ~isempty(zw)
    set(handles.pushbutton_zoom_window,'Foregroundcolor',[0 0.6 0.2],'FontWeight','Bold');
    tdx = zw(1)+20;
    tdy = zw(2)+20;
    zw1 = [zw(1) zw(2) zw(3)-zw(1)+1 zw(4)-zw(2)+1];
    set(handles.text_zoomWindowSize,'String',sprintf('[%d %d %d %d]',zw1(1),zw1(2),zw1(4),zw1(3)),'userdata',zw1);
else
    set(handles.pushbutton_zoom_window,'Foregroundcolor','r','FontWeight','Bold');
    tdx = 50;
    tdy = 70;
end
frns = reshape(1:(numRs*numCs),numCs,numRs)';
ff = makeFigureRowsCols(110,[1 1 11 3],'RowsCols',[numRs numCs],'spaceRowsCols',[0.011 0.0009],'rightUpShifts',[0.03 0.01],'widthHeightAdjustment',[-10 -15]);
set(ff.hf,'WindowButtonMotionFcn',@(hObject, event)dispFigureButtonMotion(event, handles),'Name',fullfile(get(handles.text_folderName,'userdata'),get(handles.text_fileName,'userdata')));
set(ff.hf,'WindowButtonUpFcn',@(hObject, event)dispFigureButtonUp(event, handles));
set(ff.hf,'WindowKeyPressFcn',@(hObject, event)dispFigureWindowKeyPressFcn(event, handles));
set(ff.hf,'WindowKeyReleaseFcn',@(hObject, event)dispFigureWindowKeyReleaseFcn(event, handles));
set(ff.hf,'userdata',[0 1 1]);
for rr = 1:numRs
    for cc = 1:numCs
        axes(ff.h_axes(rr,cc));
        hims(rr,cc) = imagesc(zeros(size(frames{frns(rr,cc)},1),size(frames{frns(rr,cc)},2)));
        axis equal; axis off;
        set(gca,'XTickLabel',[],'YTickLabel',[],'box','off','XTick',[],'YTick',[]);
        text(tdx,tdy,sprintf('%d',frns(rr,cc)),'fontsize',9);
        if ~isempty(zw)
            xlim([zw(1) zw(3)]);
            ylim([zw(2) zw(4)]);
        end
        set(gca,'visible','off');
    end
end
disp.numRs = numRs; 
disp.numCs = numCs;
disp.numFrames = numRs * numCs;
disp.ff = ff;
disp.hims = hims;
disp.frns = frns;
