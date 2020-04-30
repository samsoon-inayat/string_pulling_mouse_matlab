function dispFigureWindowKeyReleaseFcn(event,handles)

[globalR,globalP,~] = get_R_P_RDLC(handles);
handles1 = guidata(handles.figure1);
dispProps = get(handles1.pushbutton_select_annotation_colors,'userdata');
md = get_meta_data(handles1);
disp = md.disp;
uda = get(gcf,'userdata');
ud = uda(1);
hfn = findall(gca,'Type','Text');
changed = 0;
if length(hfn) > 1
    for ii = 1:length(hfn)
        thisT = str2num(hfn(ii).String);
        if isempty(thisT)
            continue;
        else
            fn = thisT;
            break;
        end
    end
else
    fn = str2num(get(hfn(1),'String'));
end
if strcmp(event.Key,'escape') && isempty(event.Modifier)
    set(handles1.text_processing,'userdata',0);
    set_processing_mode_gui(handles1,0);
end
if strcmp(event.Key,'delete') && isempty(event.Modifier)
    objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
    switch objectToProcess
        case 1 % body
            tagToCheck = 'Body';
        case 2 % ears
            tagToCheck = 'Ears';
        case 3 % hands
            tagToCheck = 'Hands';
        case 4 % nose
            tagToCheck = 'Nose';
    end
    [p,LiaR,LiaP] = checkIfDataPresent(handles1,fn,tagToCheck);
    if p
        globalR(LiaR,:) = [];
        if ~strcmp(tagToCheck,'Body')
            globalP(LiaP,:) = [];
        end
        changed = 1;
        set_R_P_RDLC(handles,globalR,globalP,'',1);
    end
    
end
if (strcmp(event.Key,'M') || strcmp(event.Key,'m')) && isempty(event.Modifier)
    ok = checkStatusOfSteps(handles1);
    if ~ok
        return;
    end
    framesToProcess = get(handles1.uibuttongroup_framesToProcess,'userdata');
    objectToProcess = get(handles1.uibuttongroup_objectToProcess,'userdata');
    props = {'FontSize',9,'ForegroundColor','b'};
    displayMessage(handles1,'',props);
    [sfn,efn] = getFrameNums(handles1);
    if isnan(sfn) || isnan(efn)
        displayMessage(handles1,'Select a valid frame range');
        return;
    end
    set_processing_mode_gui(handles1,1);
    try
        switch objectToProcess
            case 1
                find_masks(handles1,'body',sfn,efn);
            case 2
                find_masks(handles1,'ears',sfn,efn);
            case 3
                find_masks(handles1,'hands',sfn,efn);
    %             find_masks(handles1,'hands_bd',sfn,efn);
            case 4
                find_masks(handles1,'nose',sfn,efn);
            case 5
                find_masks(handles1,'string',sfn,efn);
            case 6
                find_masks(handles1,'all',sfn,efn);
        end
    catch
        fn = get(handles1.pushbutton_stop_processing,'userdata');
        props = {'FontSize',12,'ForegroundColor','r'};
        displayMessage(handles1,sprintf('Sorry :-( ... error occurred in frame %d',fn),props);
        rethrow(lasterror);
    end
    set_processing_mode_gui(handles1,0);
    switch framesToProcess
        case 1
            displayMasks(handles1,sfn);
    end
end
if (strcmp(event.Key,'O') || strcmp(event.Key,'o')) && isempty(event.Modifier)
    ok = checkStatusOfSteps(handles1);
    if ~ok
        return;
    end
    props = {'FontSize',9,'ForegroundColor','b'};
    displayMessage(handles1,'',props);
    enable_disable(handles,0);
    set(handles.pushbutton_stop_processing,'visible','on');
    objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
    objectMap = {'body','ears','hands','nose','string'};
    [sfn,efn] = getFrameNums(handles);
    if isnan(sfn) || isnan(efn)
        displayMessage(handles,'Select a valid frame range');
        return;
    end
    find_object(handles,sfn,efn,objectMap{objectToProcess});
    enable_disable(handles,1);
    set(handles.pushbutton_stop_processing,'visible','off');
    changed = 1;
end
if strcmp(event.Key,'rightarrow') && isempty(event.Modifier)
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
    cc = cc + 1;
    if cc > size(frns,2)
        cc = 1;
    end
    fn = frns(rr,cc);
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
end
if strcmp(event.Key,'leftarrow') && isempty(event.Modifier)
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
    cc = cc - 1;
    if cc == 0
        cc = size(frns,2);
    end
    fn = frns(rr,cc);
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
end
if strcmp(event.Key,'uparrow') && isempty(event.Modifier)
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
    rr = rr - 1;
    if rr == 0
        rr = size(frns,1);
    end
    fn = frns(rr,cc);
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
end
if strcmp(event.Key,'downarrow') && isempty(event.Modifier)
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
    rr = rr + 1;
    if rr > size(frns,1)
        rr = 1;
    end
    fn = frns(rr,cc);
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
end
if strcmp(event.Key,'pagedown') && isempty(event.Modifier)
    md = get_meta_data(handles1);
    ffn = round(get(handles1.slider1,'Value'));
    ffn1 = ffn + disp.numFrames;
    if ffn1 > length(md.frame_times)
        ffn1 = ffn;
    end
    displayFrames(handles1,ffn1);
    sfn = get(handles1.figure1,'userdata');
    set(handles1.text_selected_frame,'String',sprintf('(%d)',sfn));
end
if strcmp(event.Key,'pageup') && isempty(event.Modifier)
    md = get_meta_data(handles1);
    ffn = round(get(handles1.slider1,'Value'));
    ffn1 = ffn - disp.numFrames;
    if ffn1 < 1
        ffn1 = 1;
    end
    displayFrames(handles1,ffn1);
    sfn = get(handles1.figure1,'userdata');
    set(handles1.text_selected_frame,'String',sprintf('(%d)',sfn));
end
if (strcmp(event.Key,'home') || strcmp(event.Key,'end')) && isempty(event.Modifier)
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
    if strcmp(event.Key,'home')
        cc = 1;
    end
    if strcmp(event.Key,'end')
        cc = size(frns,2);
    end
    fn = frns(rr,cc);
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
end

% if strcmp(event.Key,'home')
%     md = get_meta_data(handles1);
%     ffn = round(get(handles1.slider1,'Value'));
%     ffn1 = 1;
%     displayFrames(handles1,ffn1);
%     sfn = get(handles1.figure1,'userdata');
%     set(handles1.text_selected_frame,'String',sprintf('(%d)',sfn));
% end
% if strcmp(event.Key,'end')
%     md = get_meta_data(handles1);
%     ffn = round(get(handles1.slider1,'Value'));
%     ffn1 = length(md.frame_times) - disp.numFrames + 1;
%     displayFrames(handles1,ffn1);
%     sfn = get(handles1.figure1,'userdata');
%     set(handles1.text_selected_frame,'String',sprintf('(%d)',sfn));
% end
if changed
    if get(handles1.checkbox_saveOnTheGo,'Value')
        save_R_P_RDLC(handles);
    else
        set(handles1.pushbutton_saveData,'Enable','On');
    end
    dfn = round(get(handles1.slider1,'Value'));
    displayFrames(handles1,dfn,fn);
end

if (strcmp(event.Key,'N') || strcmp(event.Key,'n')) && isempty(event.Modifier)
    set(handles1.radiobutton35,'Value',1);
    uibg_changed(handles1,'Nose');
end

if (strcmp(event.Key,'B') || strcmp(event.Key,'b')) && isempty(event.Modifier)
    set(handles1.radiobutton31,'Value',1);
    uibg_changed(handles1,'Body');
end

if (strcmp(event.Key,'S') || strcmp(event.Key,'s')) && isempty(event.Modifier)
    set(handles1.radiobutton_string,'Value',1); uibg_changed(handles1,'String');
end

if (strcmp(event.Key,'H') || strcmp(event.Key,'h')) && isempty(event.Modifier)
    set(handles1.radiobutton33,'Value',1); uibg_changed(handles1,'Hands');
end

if (strcmp(event.Key,'E') || strcmp(event.Key,'e')) && isempty(event.Modifier)
    set(handles1.radiobutton32,'Value',1); uibg_changed(handles1,'Ears');
end

if strcmp(event.Key,'f11') && isempty(event.Modifier)
    currentFrame = get(handles1.figure1,'userdata');
    set(handles1.edit_fromFrame,'String',num2str(currentFrame));
end

if strcmp(event.Key,'f12') && isempty(event.Modifier)
    currentFrame = get(handles1.figure1,'userdata');
    set(handles1.edit_toFrame,'String',num2str(currentFrame));
end

if strcmp(event.Key,'f1') && isempty(event.Modifier)
    set(handles1.radiobutton_selectedFrame,'Value',1);
    set(handles.uibuttongroup_framesToProcess,'userdata',1);
end

if strcmp(event.Key,'f2') && isempty(event.Modifier)
    set(handles1.radiobutton_framesInDisplayWindow,'Value',1);
    set(handles.uibuttongroup_framesToProcess,'userdata',2);
end

if strcmp(event.Key,'f3') && isempty(event.Modifier)
    set(handles1.radiobutton_epoch,'Value',1);
    set(handles.uibuttongroup_framesToProcess,'userdata',3);
end

if strcmp(event.Key,'f4') && isempty(event.Modifier)
    set(handles1.radiobutton_frameRange,'Value',1);
    set(handles.uibuttongroup_framesToProcess,'userdata',4);
end


function uibg_changed(handles,object)
values = {'Body','Ears','Hands','Nose','String','All'};
panels = {'uipanel_body','uipanel_ears','uipanel_hands_identification_parameters','uipanel_nose','',''};
ind = find(strcmp(values,object));
for ii = 1:length(values)
    if ~isempty(panels{ii})
        if ii == ind
            cmdTxt = sprintf('set(handles.%s,''Visible'',''On'');',panels{ii});eval(cmdTxt);
            cmdTxt = sprintf('set(handles.%s,''Title'',''%s Settings'');',panels{ii},values{ii});eval(cmdTxt);
        else
            cmdTxt = sprintf('set(handles.%s,''Visible'',''Off'');',panels{ii});eval(cmdTxt);
        end
    end
end
set(handles.uibuttongroup_objectToProcess,'userdata',ind);
