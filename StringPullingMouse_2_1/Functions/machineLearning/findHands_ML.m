function findHands_ML(handles,sfn,efn)


tags = handles.md.tags;
indexC = strfind(tags,'Left Hand');
tag(1) = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Right Hand');
tag(2) = find(not(cellfun('isempty', indexC)));

positiveFolder = fullfile(pwd,'functions','machineLearning','handsPositiveData');
fileName = fullfile(positiveFolder,'dataTable.mat');
temp = load(fileName);
dataTable = temp.dataTable; clear temp;
bboxes = dataTable.bboxes;
fileNames = dataTable.fileNames;


detector = vision.CascadeObjectDetector('handsDetector.xml');
global frames;
zw = handles.md.resultsMF.zoomWindow;
frameNums = sfn:efn;
for ii = 1:length(frameNums)
    tic;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    bbox_ML = step(detector,thisFrame);
    detectedImg = insertObjectAnnotation(thisFrame,'rectangle',bbox_ML,'Fur');
%     detectedImg = insertObjectAnnotation(thisFrame,'rectangle',bbox,'Fur');
    figure(100);clf;imshow(detectedImg);
    pause(0.1);
    n = 0;
%     displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
end
% displayMessage(handles,sprintf('Done processing frames %d to %d',sfn,efn));
