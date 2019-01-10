function find_masks_KNN (handles,object,sfn,efn)

masksMap = {'body','ears','hands','string','handsb','handsf'};
if strcmp(object,'all')
    os = [1 2 3];
else
    ind = find(strcmp(masksMap,object));
    os = ind;
end

global masks;
global frames;
frameNums = sfn:efn;
zw = handles.md.resultsMF.zoomWindow;
if isempty(zw)
    displayMessageBlinking(handles,'No Zoom Window Selected ... go to step 1',{'ForegroundColor','r'},3);
    return;
end

nFrames = length(frames);
thisFrame = frames{1};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);

fileName = sprintf('masks.mat');
fullfileName = fullfile(handles.md.processedDataFolder,fileName);
if exist(fullfileName,'file')
    fMasks = masks.frameMasks;
%     if ~get(handles.checkbox_over_write,'Value')
%         frameNums = setdiff(frameNums,masks.frameNums);
%     end
else
    fMasks = uint8(zeros(numel(thisFrame(:,:,1)),nFrames));
    masks.zoomWindow = zw;
%     frameNums = zeros(nFrames,length(masksMap));
end

% if isempty(frameNums) & ~get(handles.checkbox_over_write,'Value')
%     displayMessageBlinking(handles,'Masks already exist for these frames',{'ForegroundColor','r'},3);
%     return;
% end

% startTime = tic;
% hWaitBar = waitbar(0,sprintf('Processing Frame -'));

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
        bpMask = de2bi(pMask,6); % convert to binary for separating individual masks ... i.e. uncompress
        thisFrame = frames{fn};
        thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
        mask = compute_masks_KNN(handles,thisFrame,object);
        bpMask(:,ind) = reshape(mask,numel(mask),1);
        if strcmp(object,'hands') && fn > 1
            thisFramem1 = frames{fn-1};
            thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
            bthisFrame = thisFrame - thisFramem1;
            fthisFrame = thisFramem1 - thisFrame;
            mask = compute_masks_KNN(handles,bthisFrame,'handsb');
            bpMask(:,5) = reshape(mask,numel(mask),1);
            mask = compute_masks_KNN(handles,fthisFrame,'handsf');
            bpMask(:,6) = reshape(mask,numel(mask),1);
        end
        dpMask = (bi2de(bpMask));
        fMasks(:,fn) = uint8(dpMask);
        displayMessage(handles,sprintf('Finding %s masks ... Processing frame -%d, %d/%d ... time remaining %s',object,fn,jj,length(frameNums),getTimeRemaining(length(frameNums),jj)));
    end
end
masks.frameMasks = fMasks;
set(handles.pushbutton_saveMasks,'Enable','On');
displayMessage(handles,sprintf('Done processing frames from %d to %d ... don''t forget to save masks',sfn,sfn+jj-1));
% masks.frameNums = frameNums;
% tic
% % save(fullfileName, '-struct', 'masks','-v7.3');
% toc;
% displayMessage(handles,sprintf('Saved !!!'));
% 


%%%%% backup down below
% data = get(handles.epochs,'Data');
% currentSelection = get(handles.epochs,'userdata');
% if isempty(currentSelection)
%     displayMessageBlinking(handles,'Select an epoch for finding masks',{'FontSize',12,'foregroundColor','r'},3);
%     displayMessage(handles,'Select an epoch for finding masks',{'FontSize',12,'foregroundColor','r'});
%     return;
% end
% fn = data{currentSelection};
% if isempty(fn)
%     msgbox('Select an appropriate epoch');
% end
% startEnd = cell2mat(data(currentSelection(1),:));
% sfn = startEnd(1);
% efn = startEnd(2);
% frameNums = sfn:efn;
% if strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
%     startTime = tic;
%     global frames;
%     zw = handles.md.resultsMF.zoomWindow;
%     if isempty(zw)
%         return;
%     end
%     nFrames = length(frames);
%     thisFrame = frames{1};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     fileName = sprintf('masks.mat');
%     fullfileName = fullfile(handles.md.processedDataFolder,fileName);
%     if exist(fullfileName,'file')
%         MasksData = matfile(fullfileName,'writable',true);
%         fMasks = MasksData.frameMasks;
%         if ~get(handles.checkbox_overwriteMasks,'Value')
%             frameNums = setdiff(frameNums,MasksData.frameNums);
%         end
%     else
%         fMasks = zeros(numel(thisFrame(:,:,1)),nFrames);
%     end
%     if isempty(frameNums)
%         displayMessageBlinking(handles,'Masks already exist for these frames',{'ForegroundColor','r'},3);
%         return;
%     end
%     
%     
%     hWaitBar = waitbar(0,sprintf('Processing Frame -'));
%     ii = frameNums(1);
%     thisFrame = frames{ii};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     tic
%     tMasks = compute_masks_KNN(handles,thisFrame);
%     displayMasksOnTheGo(handles,ii,thisFrame,tMasks);
%     t = toc;
%     thisMask = [reshape(tMasks.Im,numel(tMasks.Im),1) reshape(tMasks.Ie,numel(tMasks.Im),1) ...
%         reshape(tMasks.Ih,numel(tMasks.Im),1) reshape(tMasks.Is,numel(tMasks.Im),1)];
%     thisMaskD = (bi2de(thisMask));
%     fMasks(:,ii) = thisMaskD;
%     waitbar(1/length(frameNums),hWaitBar,sprintf('Processing Frame %d/%d, Time Remaining = %.2f hrs',1,length(frameNums),((length(frameNums)-1)*t)/3600));
%     
%     for iii = 2:length(frameNums)
%         ii = frameNums(iii);
%         thisFrame = frames{ii};
%         thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%         thisFramem1 = frames{ii-1};
%         thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
%         bthisFrame = thisFrame - thisFramem1;
% %         bthisFrame = bthisFrame(zw(2):zw(4),zw(1):zw(3),:);
%         fthisFrame = thisFramem1 - thisFrame;
% %         fthisFrame = fthisFrame(zw(2):zw(4),zw(1):zw(3),:);
%         tic
%         tMasks = compute_masks_KNN(handles,thisFrame);
%         displayMasksOnTheGo(handles,ii,thisFrame,tMasks)
%         bmasks = find_mask_1(handles,bthisFrame,'hand');
%         fmasks = find_mask_1(handles,fthisFrame,'hand');
%         t = toc;
%         thisMask = [reshape(tMasks.Im,numel(tMasks.Im),1) reshape(tMasks.Ie,numel(tMasks.Im),1) ...
%             reshape(tMasks.Ih,numel(tMasks.Im),1) reshape(tMasks.Is,numel(tMasks.Im),1) ...
%             reshape(bmasks,numel(tMasks.Im),1) reshape(fmasks,numel(tMasks.Im),1)];
%         thisMaskD = (bi2de(thisMask));
%         fMasks(:,ii) = thisMaskD;
%         waitbar(iii/length(frameNums),hWaitBar,sprintf('Processing Frame %d/%d, Time Remaining = %.2f hrs',iii,length(frameNums),((length(frameNums)-iii)*t)/3600));
%         displayMessage(handles,sprintf('Finding masks for frame %d',ii));
%     end
%     close(hWaitBar);
%     totalTimeTaken = toc(startTime);
%     if exist('MasksData','var')
%         totalTimeTaken = MasksData.totalTimeTaken + totalTimeTaken;
%         frameNums = sort([frameNums MasksData.frameNums]);
%     end
% %     fileName = sprintf('masks.mat');
%     displayMessage(handles,sprintf('Saving masks file %s',fileName));
% %     if ~exist(fullfileName,'file')
%         frameMasks = uint8(fMasks);
%         zoomWindow = zw;
%         save(fullfileName,'frameNums','frameMasks','zoomWindow','totalTimeTaken');
%         displayMessage(handles,sprintf('Saved !!!'));
% %         return;
% %     end
% %     for ii = 1:length(frameNums)
% %         fn = frameNums(ii);
% %         MasksData.frameMasks(:,fn) = fMasks(:,fn);
% %     end
%     
% %     MasksData.frameNums = frameNums;
% %     displayMessage(handles,sprintf('Saved !!!'));
% %     handles.md.preprocessMF.frameMasks = frameMasks;
%     global masks;
%     masks = frameMasks;
% %     totalTimeTaken
%     n = 0;
% else
%     display('Please wait ... background loading of frames or finding frame subtraction in process');
% end