function userProcess(handles)

if ~strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
    displayMessageBlinking(handles,'Please wait for completion of file loading',{'ForegroundColor','r'},3);
    return;
end

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
M.TouchingHandsArea = getParameter(handles,'Touching Hands Area');
masksMap = getParameter(handles,'Masks Order');
tags = M.tags;
zw = M.zw;


[sfn,efn] = getFrameNums(handles);
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
props = {'FontSize',9,'ForegroundColor','b'};
displayMessage(handles,'',props);
global frames;
enable_disable(handles,0);
set(handles.pushbutton_stop_processing,'visible','on');
switch objectToProcess
    case 1
    case 2
        frameNums = sfn:efn;
        indexC = strfind(M.tags,'Left Ear');
        tagL = find(not(cellfun('isempty', indexC)));
        indexC = strfind(M.tags,'Right Ear');
        tagR = find(not(cellfun('isempty', indexC)));
        frameNums = sfn:efn;
        indsR = []; indsL = [];
        for ii = 1:length(frameNums)
            fn = frameNums(ii);
            LiaL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
            LiaR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
            if M.R(LiaL,5) == 1
                indsL = [indsL ii];
            end
            if M.R(LiaR,5) == 1
                indsR = [indsR ii];
            end
        end
        fns = unique([frameNums(indsR) frameNums(indsL)]);
        for ii = 1:length(fns)
            fn = fns(ii);
            manuallyTagEars(handles,fn);
        end
    case 3
    case 4
    case 5
end
enable_disable(handles,1);
set(handles.pushbutton_stop_processing,'visible','off');
unique([frameNums(indsR) frameNums(indsL)])
n = 0;