function userProcess(handles)

if ~strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
    displayMessageBlinking(handles,'Please wait for completion of file loading',{'ForegroundColor','r'},3);
    return;
end
framesToProcess = get(handles.uibuttongroup_framesToProcess,'userdata');
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');
props = {'FontSize',9,'ForegroundColor','b'};
displayMessage(handles,'',props);
global frames;
switch framesToProcess
    case 1
        sfn = get(handles.figure1,'userdata');
        efn = sfn;
    case 2
        sfn = round(get(handles.slider1,'Value'));
        efn = sfn + 19;
    case 3
        data = get(handles.epochs,'Data');
        currentSelection = get(handles.epochs,'userdata');
        fn = data{currentSelection};
        if isempty(fn)
            msgbox('Select an appropriate epoch');
        end
        startEnd = cell2mat(data(currentSelection(1),:));
        sfn = startEnd(1);
        efn = startEnd(2);
    case 4
        sfn = 1;
        efn = length(frames);
end
enable_disable(handles,0);
set(handles.pushbutton_stop_processing,'visible','on');
% try
%     if get(handles.checkbox_useSimpleMasks,'Value')
%         thisFrame = frames{sfn};
%         tMasks = find_masks(handles,thisFrame);
%     else
%         tMasks = get_masks_KNN(handles,sfn);
%     end
% %     tMasks = find_masks_knn(handles,sfn);
% catch
%     props = {'FontSize',10,'ForegroundColor','r'};
%     displayMessage(handles,sprintf('Could not retrieve masks. As a first step, define colors and save masks'),props);
%     enable_disable(handles,1);
%     set(handles.pushbutton_stop_processing,'visible','off');
%     return;
% end
try
    switch objectToProcess
        case 1
            % for fur
%            storeTrainingData(handles,sfn,efn);
%             checkTrainingData(handles,sfn,efn);
%             trainModel(handles,sfn,efn);
%             findBody_ML(handles,sfn,efn);

            % for hands
%             storeTrainingData_hands(handles,sfn,efn);
%             checkTrainingData_hands(handles,sfn,efn);
%             trainModel_hands(handles,sfn,efn);
%             trainModel_hands_RCNN(handles,sfn,efn);
%             findHands_ML(handles,sfn,efn);
            


        case 2
        case 3
            detectFeatures(handles,sfn,efn);
        case 4
    end
catch
    fn = get(handles.pushbutton_stop_processing,'userdata');
    props = {'FontSize',12,'ForegroundColor','r'};
    displayMessage(handles,sprintf('Sorry ... :-( ... error occurred in frame %d',fn),props);
end
enable_disable(handles,1);
set(handles.pushbutton_stop_processing,'visible','off');