function find_masks_KNN (handles,object,sfn,efn)

masksMap = {'body','ears','hands','nose','string'};
setParameter(handles,'Masks Order',masksMap);
if strcmp(object,'all')
    os = [1 2 3 4 5];
else
    ind = find(strcmp(masksMap,object));
    os = ind;
end
% os = 5;
global masks;
global frames;
global cmasks;
frameNums = sfn:efn;
% zw = handles.md.resultsMF.zoomWindow;
zw = getParameter(handles,'Auto Zoom Window');
if isempty(zw)
    displayMessageBlinking(handles,'No Zoom Window for Masks ... go to step 4',{'ForegroundColor','r'},3);
    return;
end

nFrames = length(frames);
thisFrame = frames{1};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
fileName = sprintf('masks.mat');
fullfileName = fullfile(handles.md.processedDataFolder,fileName);
if exist(fullfileName,'file')% & ~get(handles.checkbox_over_write,'Value')
    fMasks = masks.frameMasks;
    if ~isequal(masks.zoomWindow,zw)
        displayMessageBlinking(handles,'Old masks were calculated with a different zoom window',{'ForegroundColor','r'},3);
        opts.Interpreter = 'tex'; opts.Default = 'No';
        % Use the TeX interpreter to format the question
        quest = 'All old masks will be deleted ... proceed?';
        answer = questdlg(quest,'Please select',...
                          'Yes','No',opts);
        if strcmp(answer,'Yes')
            fMasks = uint8(zeros(numel(thisFrame(:,:,1)),nFrames));
            masks.zoomWindow = zw;
            cmasks = fMasks;
            fileName = sprintf('cmasks.mat');
            fullfileName = fullfile(handles.md.processedDataFolder,fileName);
            save(fullfileName, 'cmasks','-v7.3');
        else
            return;
        end
    end
else
    fMasks = uint8(zeros(numel(thisFrame(:,:,1)),nFrames));
    masks.zoomWindow = zw;
    cmasks = fMasks;
    fileName = sprintf('cmasks.mat');
    fullfileName = fullfile(handles.md.processedDataFolder,fileName);
    save(fullfileName, 'cmasks','-v7.3');
end



% startTime = tic;
% hWaitBar = waitbar(0,sprintf('Processing Frame -'));
if ~get(handles.checkbox_useSimpleMasks,'Value')
    displayMessageBlinking(handles,'Please wait ... starting process',{'ForegroundColor','r'},3);
    pause(0.1);
end
for oo = 1:length(os)
    object = masksMap{os(oo)};
    ind = find(strcmp(masksMap,object));
    for jj = 1:length(frameNums)
        tic
        if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
            break;
        end
        fn = frameNums(jj);
        pMask = fMasks(:,fn); % get the previous mask value. If not calculated before, it would be zeros
        bpMask = de2bi(pMask,7); % convert to binary for separating individual masks ... i.e. uncompress
        thisFrame = frames{fn};
        thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
        mask = compute_masks_KNN(handles,thisFrame,object);
        if get(handles.checkbox_updateDisplay,'Value')
            figure(100);clf;
            Im = imoverlay(thisFrame,mask);
            imagesc(Im);axis equal;
            title(fn);
        end
        bpMask(:,ind) = reshape(mask,numel(mask),1);
%         if strcmp(object,'hands') && fn > 1
%             thisFramem1 = frames{fn-1};
%             thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
%             bthisFrame = thisFrame - thisFramem1;
%             fthisFrame = thisFramem1 - thisFrame;
%             mask = compute_masks_KNN(handles,bthisFrame,'handsb');
%             bpMask(:,6) = reshape(mask,numel(mask),1);
% %             mask = compute_masks_KNN(handles,fthisFrame,'handsf');
% %             bpMask(:,7) = reshape(mask,numel(mask),1);
%         end
        dpMask = (bi2de(bpMask));
        fMasks(:,fn) = uint8(dpMask);
        displayMessage(handles,sprintf('Finding %s masks ... Processing frame -%d, %d/%d ... time remaining %s',object,fn,jj,length(frameNums),getTimeRemaining(length(frameNums),jj)));
    end
end
masks.frameMasks = fMasks;
fileName = sprintf('masks.mat');
fullfileName = fullfile(handles.md.processedDataFolder,fileName);
save(fullfileName, '-struct', 'masks','-v7.3');
% set(handles.pushbutton_saveMasks,'Enable','On');
displayMessage(handles,sprintf('Done processing frames from %d to %d',sfn,sfn+jj-1));

