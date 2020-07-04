function eraseObject(handles,sfn,efn,object)
[globalR,globalP,~] = get_R_P_RDLC(handles);
handles.md = get_meta_data(handles);
frames = get_frames(handles);
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.md.frame_size;
M.pushbutton_stop_processing = handles.pushbutton_stop_processing;
masksMap = getParameter(handles,'Object Masks Order');
M.masksMap = masksMap;
dfn = round(get(handles.slider1,'Value'));

if sfn == 1 && efn == length(frames)
    frameNums = [];
else
    frameNums = sfn:efn;
end
[p,LiaR,LiaP] = checkIfDataPresent(handles,frameNums,object);
if p
    globalR(LiaR,:) = [];
    if ~strcmp(lower(object),'body')
        globalP(LiaP,:) = [];
    end
end

if get(handles.checkbox_saveOnTheGo,'Value')
    if strcmp(lower(object),'body')
        set_R_P_RDLC(handles,globalR,'','',1);
    else
        set_R_P_RDLC(handles,globalR,globalP,'',1);
    end
else
    set(handles.pushbutton_saveData,'Enable','On');
end

if sfn==efn
    displayFrames(handles,dfn,sfn);
else
    framesToProcess = get(handles.uibuttongroup_framesToProcess,'userdata');
    if framesToProcess == 4
        sfn = round(get(handles.slider1,'Value'));
        displayFrames(handles,sfn);
    else
        displayFrames(handles,sfn);
    end
end
