function dispFigureWindowKeyReleaseFcn(event,handles)
[globalR,globalP,~] = get_R_P_RDLC(handles);
handles1 = guidata(handles.figure1);
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
if strcmp(event.Key,'delete')
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
if strcmp(event.Key,'return')
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
if changed
    if get(handles1.checkbox_saveOnTheGo,'Value')
        save_R_P_RDLC(handles);
    else
        set(handles1.pushbutton_saveData,'Enable','On');
    end
    dfn = round(get(handles1.slider1,'Value'));
    displayFrames(handles1,dfn,fn);
end

