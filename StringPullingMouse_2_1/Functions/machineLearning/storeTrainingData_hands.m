function storeTrainingData_hands(handles,sfn,efn)

tags = handles.md.tags;
indexC = strfind(tags,'Left Hand');
tag(1) = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Right Hand');
tag(2) = find(not(cellfun('isempty', indexC)));


positiveFolder = fullfile(pwd,'functions','machineLearning','handsPositiveData');
justHandsFolder = fullfile(pwd,'functions','machineLearning','justHands');
negativeFolder = fullfile(pwd,'functions','machineLearning','handsNegativeData');

global frames;
zw = handles.md.resultsMF.zoomWindow;

frameNums = sfn:efn;
P = handles.md.resultsMF.P;
ind = 1;
for ii = 1:length(frameNums)
    tic;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    fileNames{ind,1} = sprintf('frame_%d.jpg',fn);
    fileName = fullfile(positiveFolder,fileNames{ind});
    LiaL = ismember(P(:,[1 2]),[fn tag(1)],'rows');
    boundaryPixels = P(LiaL,3);
    [rr,cc] = ind2sub(handles.md.frameSize,boundaryPixels);
    bbox = [min(cc-zw(1)) min(rr-zw(2)) max(cc)-min(cc) max(rr)-min(rr)];
%     fileNameL = sprintf('frame_%d_L.jpg',fn);
%     fileNameL = fullfile(justHandsFolder,fileNameL);
%     imwrite(thisFrame,fileNameL);
%     
    bboxes{ind,1} = floor(bbox);
    ind = ind + 1;
    LiaR = ismember(P(:,[1 2]),[fn tag(2)],'rows');
    boundaryPixels = P(LiaR,3);
    [rr,cc] = ind2sub(handles.md.frameSize,boundaryPixels);
    bbox = [min(cc-zw(1)) min(rr-zw(2)) max(cc)-min(cc) max(rr)-min(rr)];
    bboxes{ind,1} = floor(bbox);
    fileNames{ind,1} = sprintf('frame_%d.jpg',fn);
    ind = ind + 1;
    imwrite(thisFrame,fileName);
    fileName = sprintf('frame_%d.jpg',fn);
    fileName = fullfile(justHandsFolder,fileName);
    displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
%     figure(100);clf;imagesc(thisFrame);axis equal;hold on;
%     rectangle(gca,'Position',bboxes{ind-2});
%     rectangle(gca,'Position',bboxes{ind-1});
%     n=0;
    I = rgb2gray(thisFrame);
    points = detectSURFFeatures(I);
    figure(100);clf
    imshow(I); hold on;
    plot(points.selectStrongest(10));
    pause(0.1);
end
dataTable = table(fileNames,bboxes);
fileName = fullfile(positiveFolder,'dataTable.mat');
save(fileName,'dataTable');
displayMessage(handles,sprintf('Done processing frames %d to %d',sfn,efn));