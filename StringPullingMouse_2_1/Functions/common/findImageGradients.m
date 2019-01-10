function findImageGradients(handles)
% if strcmp(get(handles.text_fileName,'String'),sprintf('File: %s',handles.d.file_name))
%     global frames;
%     zw = handles.md.resultsMF.zoomWindow;
%     if isempty(zw)
%         display('Zoom window not defined yet');
%         return;
%     end
%     nFrames = length(frames);
%     thisFrame = frames{1};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     [rows,cols] = size(thisFrame(:,:,1));
%     hWaitBar = waitbar(0,sprintf('Processing Frame -'));
%     for ii = 1:length(frames)
%         thisFrame = frames{ii};
%         thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%         tic
%         thisGradient = imgradient(rgb2gray(thisFrame));
%         gradients(:,ii) = reshape(thisGradient,rows*cols,1);
%         t = toc;
%         waitbar(ii/length(frames),hWaitBar,sprintf('Processing Frame %d/%d ... Time Remaining = %.2f hrs',ii,length(frames),((length(frames)-ii)*t)/3600));
%     end
%     waitbar(100,hWaitBar,sprintf('Saving data ... plz wait ... this will take a while'));
%     gradients = single(gradients);
%     frameMasks = handles.md.preprocessMF.frameMasks;
%     zoomWindow = zw;
%     save(handles.md.preprocessMF.Properties.Source,'gradients','frameMasks','zoomWindow');
%     close(hWaitBar);
% else
%     display('Please wait ... background loading of frames or finding frame subtraction in process');
% end
