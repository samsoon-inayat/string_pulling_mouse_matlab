function erase_masks (handles,object,sfn,efn)

% if ~get(handles.checkbox_useSimpleMasks,'Value')
%     displayMessageBlinking(handles,'Please wait ... starting process',{'ForegroundColor','r'},3);
%     pause(0.1);
% end
md = get_meta_data(handles);
st = floor((getParameter(handles,'String Thickness in Pixels')));
masksMap = {'body','ears','hands','nose','string','hands_bd','background'};
objectsMap = {'Fur';'Ears';'hands';'Nose';'String';'';'Background'};
string_thickness = {st;st/2;st/2;st/2;st/2;st;st};
omasksMap = {'body','right ear','left ear','nose','right hand','left hand','string','background'};
setParameter(handles,'Masks Order',masksMap);
setParameter(handles,'Object Masks Order',omasksMap);
if strcmp(object,'all')
    os = 7;%[1 2 3 4 5];
else
    ind = find(strcmp(masksMap,object));
    os = ind;
end
% os = 6;
frames = get_frames(handles);
thisFrame = frames{1};
frameNums = sfn:efn;
% zw = handles.md.resultsMF.zoomWindow;
zw = getParameter(handles,'Auto Zoom Window');
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
if isempty(zw)
    displayMessageBlinking(handles,'No Zoom Window for Masks ... go to step 4',{'ForegroundColor','r'},3);
    return;
end
startTime = tic;
for oo = 1:length(os)
    object = masksMap{os(oo)};
    ind = find(strcmp(masksMap,object));
    for jj = 1:length(frameNums)
        tic
        pause(0.1);
        if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
            axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
            break;
        end
        fn = frameNums(jj);
        try
            mask = get_mask(handles,fn,ind);
        catch
            displayMessage(handles,'Inconsistent data set, auto zoom window was perhaps changed after finding masks, find all masks again');
            return;
        end
%         if sum(mask(:))>0 && ~get(handles.checkbox_over_write,'Value')
%             displayMessage(handles,sprintf('Finding %s masks ... Processing frame -%d, %d/%d ... time remaining %s',object,fn,jj,length(frameNums),getTimeRemaining(length(frameNums),jj)));
%             continue;
%         end
        displayMessage(handles,sprintf('Erasing %s masks ... Processing frame -%d, %d/%d ... time remaining %s',object,fn,jj,length(frameNums),getTimeRemaining(length(frameNums),jj)));
        if sum(mask(:))==0
            continue;
        end
        mask = zeros(size(thisFrame,1),size(thisFrame,2));
        save_mask(handles,fn,object,mask);
    end
end
endTime = toc(startTime);
displayMessage(handles,sprintf('Done processing frames from %d to %d - Total Time Taken = %.3f s',sfn,sfn+jj-1,endTime));
