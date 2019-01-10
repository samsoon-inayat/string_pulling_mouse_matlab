function storeTrainingData(handles,sfn,efn)

positiveFolder = fullfile(pwd,'functions','machineLearning','furPositiveData');
negativeFolder = fullfile(pwd,'functions','machineLearning','furNegativeData');

global frames;
zw = handles.md.resultsMF.zoomWindow;

frameNums = sfn:efn;
RE = handles.md.resultsMF.RE;
for ii = 1:length(frameNums)
    tic;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    fileNames{ii,1} = sprintf('frame_%d.jpg',fn);
    fileName = fullfile(positiveFolder,fileNames{ii});
    thisRE = RE(fn,2:end);
    C = getSubjectFit([thisRE(1)-zw(1) thisRE(2)-zw(2)],thisRE(3),thisRE(4),thisRE(5));
    bbox = [min(C.Ellipse_xs) min(C.Ellipse_ys) max(C.Ellipse_xs)-min(C.Ellipse_xs) max(C.Ellipse_ys)-min(C.Ellipse_ys)];
    bboxes{ii,1} = floor(bbox);
    imwrite(thisFrame,fileName);
    displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
end
furDataTable = table(fileNames,bboxes);
fileName = fullfile(positiveFolder,'dataTable.mat');
save(fileName,'dataTable');
displayMessage(handles,sprintf('Done processing frames %d to %d',sfn,efn));