function find_object(handles,sfn,efn,object)
masksMap = {'body','ears','hands','nose','string'};
indexC = strfind(masksMap,lower(object));
ind_object = find(not(cellfun('isempty', indexC)));
dfn = round(get(handles.slider1,'Value'));
frameNums = sfn:efn;
epochFrameNums = getAllEpochFrameNums(handles);
if epochFrameNums(1) == sfn && strcmp(object,'hands')
    [p,LiaR,LiaP] = checkIfDataPresent(handles,sfn,object);
    if ~p
        displayMessageBlinking(handles,sprintf('For first frame in epoch, find hands manually'),{'ForegroundColor','r'},3);
        return;
    end
end
% motion = load_motion(handles);
startTime = tic;
[globalR,globalP,~] = get_R_P_RDLC(handles);
try
for ii = 1:length(frameNums)
    tic
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
        break;
    end
    fn = frameNums(ii);
    if fn == 1 && strcmp(object,'hands')
        continue;
    end
    if checkIfDataPresent(handles,fn,lower(object)) && ~get(handles.checkbox_over_write,'Value')
        displayMessage(handles,sprintf('Finding %s ... Processing frame %d - %d/%d ... found existing ... time remaining %s',object,fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
        continue;
    end
    if get(handles.checkbox_over_write,'Value')
        [p,LiaR,LiaP] = checkIfDataPresent(handles,fn,object);
        if p
            [globalR,globalP,~] = get_R_P_RDLC(handles);
            globalR(LiaR,:) = [];
            if ~strcmp(lower(object),'body')
                globalP(LiaP,:) = [];
                set_R_P_RDLC(handles,globalR,globalP,'',1);
            else
                set_R_P_RDLC(handles,globalR,'','',1);
            end
            
        end
    end
%     displayMessage(handles,sprintf('Finding %s ... Processing frame %d',object,fn));
    set(handles.pushbutton_stop_processing,'userdata',fn);
    if ~strcmp(object,'body') & ~strcmp(object,'ears') & ~strcmp(object,'hands')
        mask = get_mask(handles,fn,ind_object);
        if sum(mask(:)) == 0
            displayMessageBlinking(handles,sprintf('Can not find %s ... No mask found ... Processing frame %d - %d/%d ... time remaining %s',object,fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)),{'ForegroundColor','r'},2);
            continue;
        end
    end
    switch object
        case 'body'
            find_body(handles,fn);
        case 'ears'
            find_ears(handles,fn);
        case 'nose'
            find_nose(handles,fn);
        case 'hands'
            find_hands(handles,fn);
    end
    timeRemaining = getTimeRemaining(length(frameNums),ii);
    if ii > 1 && ii < length(frameNums)
        displayMessage(handles,sprintf('Finding %s ... Processing frame %d - %d/%d ... time remaining %s',object,fn+1,ii+1,length(frameNums),timeRemaining),{'foregroundcolor','b'});
    end
end
catch
    processingTime = toc(startTime);
    displayMessageBlinking(handles,sprintf('Done processing frames from %d to %d - Total Time Taken = %.3f s ... Error in frame %d ... use manual method',sfn,sfn+ii-2,processingTime,sfn+ii-1),{'foregroundcolor','r'},2);
    if get(handles.checkbox_saveOnTheGo,'Value')
        save_R_P_RDLC(handles);
    else
        set(handles.pushbutton_saveData,'Enable','On');
    end
    enable_disable(handles,1);
    set(handles.pushbutton_stop_processing,'visible','off');
    if get(handles.checkbox_rethrow_matlab_errors,'Value')
        rethrow(lasterror);
    end
    return;
end
processingTime = toc(startTime);

if get(handles.checkbox_saveOnTheGo,'Value')
    save_R_P_RDLC(handles);
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
displayMessage(handles,sprintf('Done processing frames from %d to %d - Total Time Taken = %.3f s',sfn,sfn+ii-1,processingTime),{'foregroundcolor','b'});
set(handles.axes_main,'Visible','Off');