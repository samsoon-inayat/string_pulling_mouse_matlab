function userProcess2(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end

[sfn,efn] = getFrameNums(handles);

% out = get_all_params(handles,sfn,efn,0);
zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;

n = 0;

% global masks;
frames = get_frames(handles);



frameNums = sfn:efn;
% fmasks = masks.frameMasks;
fileName = fullfile(handles.md.processedDataFolder,sprintf('epoch_%d_%d.tif',sfn,efn));
h = waitbar(1/length(frameNums),'Processing image frames');
for ii = 1:length(frameNums)
    waitbar(ii/length(frameNums),h,sprintf('Processing frames %d/%d',ii,length(frameNums)));
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    img = rgb2gray(thisFrame);
    imwrite(img,fileName,'Write','append');
end
close(h);
display('Done writing multitiff');

