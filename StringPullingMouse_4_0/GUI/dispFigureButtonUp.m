function dispFigureButtonUp(event,handles)
handles1 = guidata(handles.figure1);
dispProps = get(handles1.pushbutton_select_annotation_colors,'userdata');
md = get_meta_data(handles);
disp = md.disp;
uda = get(gcf,'userdata');
ud = uda(1);
buttonType = get(gcf,'SelectionType');
fn = get(gca,'userdata');
% hfn = findall(gca,'Type','Text');
% if length(hfn) > 1
%     for ii = 1:length(hfn)
%         thisT = str2num(hfn(ii).String);
%         if isempty(thisT)
%             continue;
%         else
%             fn = thisT;
%             break;
%         end
%     end
% else
%     fn = str2num(get(hfn(1),'String'));
% end
set(gca,'box','on');
% if ud == 1 % ctrl keyboard key
%     temp = handles.md.resultsMF.epochStarts;
% %     if isempty(find(temp == fn))
%         handles.md.resultsMF.epochStarts = [temp;fn];
%         populateTable(handles);
% %     end
% end
% if ud == 2 % alt keyboard key
%     temp = handles.md.resultsMF.epochEnds;
% %     if isempty(find(temp == fn))
%         handles.md.resultsMF.epochEnds = [temp;fn];
%         populateTable(handles);
% %     end
% end
% if ud == 0
    if strcmp(buttonType,'normal')
        if get(handles1.checkbox_displayMasks,'Value')
            displayMasks(handles1,fn);
        end
        set(handles1.radiobutton_selectedFrame,'Value',1);
        set(handles1.uibuttongroup_framesToProcess,'userdata',1);
        figure(handles1.figure1);
    end
    if strcmp(buttonType,'alt')
        objectToProcess = get(handles1.uibuttongroup_objectToProcess,'userdata');
        switch objectToProcess
            case 1
                manuallyTagBody(handles1,fn);
            case 2
                manuallyTagEars(handles1,fn);
            case 3
                manuallyTagHands(handles1,fn);
            case 4
                manuallyTagNose(handles1,fn);
        end
        axes(handles1.axes_main);cla;set(handles1.axes_main,'visible','off');
    end
    if strcmp(buttonType,'open')
%         displayFrames(handles1,fn);
%         set(handles1.radiobutton_framesInDisplayWindow,'Value',1);
%         set(handles1.uibuttongroup_framesToProcess,'userdata',2);
%         figure(handles1.figure1);
%         handles1 = guidata(handles.figure1);
%         disp = handles1.disp;
        pos = get(handles1.figure1,'Position');
        fn1 = round(get(handles.slider1,'Value'));
        [rr,cc] = find((disp.frns-1+fn1) == fn);
        thisFrame = get(disp.hims(rr,cc),'CData');
        hf = figure_window(handles1,1000);
        posf = get(hf,'Position');
        posf(1) = pos(1); posf(2) = pos(2); posf(3) = floor(pos(3)/1.25); posf(4) = floor(pos(4)/1.25);
        set(hf,'Position',posf);
        imagesc(thisFrame);
        axis equal;
        zw = getParameter(handles1,'Auto Zoom Window');
        if ~isempty(zw)
            xlim([zw(1) zw(3)]);
            ylim([zw(2) zw(4)]);
        end
        plotTags(handles1,gca,fn);
    end
% end
% if ud == 3 % shift keyboard key
%     manuallyTag(handles,fn);
% end
zw = getParameter(handles1,'Zoom Window');%handles.md.resultsMF.zoomWindow;
azw = getParameter(handles,'Auto Zoom Window');
if ~isempty(azw) & get(handles.checkbox_select_auto_zoom_window,'Value')
    zw = azw;
end
ffn = round(get(handles1.slider1,'Value'));
pfn = get(handles1.figure1,'userdata');
frns = ffn-1+reshape(1:(disp.numRs*disp.numCs),disp.numCs,disp.numRs)';
[rr,cc] = find(frns == pfn);
axes(disp.ff.h_axes(rr,cc));
hrect = findall(gca,'Type','Rectangle');
delete(hrect);
[rr,cc] = find(frns == fn);
uda(2) = rr; uda(3) = cc;
set(disp.ff.hf,'userdata',uda);
axes(disp.ff.h_axes(rr,cc));

if ~isempty(zw)
    thrects = findobj(gca,'Type','Rectangle');
    if ~isempty(thrects)gui
        delete(thrects);
    end
    rectangle('Position',[zw(1),zw(2),zw(3)-zw(1),zw(4)-zw(2)],'linewidth',dispProps.selectRectangle_linewidth,'EdgeColor',dispProps.selectRectangle_color);
else
    sz = md.frame_size;
    rectangle('Position',[1,1,sz(2)-1,sz(1)-1],'linewidth',3);
end
set(handles1.figure1,'userdata',fn);
set(handles1.text_selected_frame,'String',sprintf('(%d)',fn));
set(handles.text_display_frames,'String',sprintf('Frames %d - %d (%d)',min(frns(:)),max(frns(:)),fn));

% if get(handles.checkbox_displayMasks,'Value')
%     displayMasks(handles,fn);
% end
