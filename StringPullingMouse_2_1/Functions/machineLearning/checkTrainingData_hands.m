function checkTrainingData_hands(handles,sfn,efn)

positiveFolder = fullfile(pwd,'functions','machineLearning','handsPositiveData');

fileName = fullfile(positiveFolder,'dataTable.mat');
temp = load(fileName);
dataTable = temp.dataTable; clear temp;
bboxes = dataTable.bboxes;
fileNames = dataTable.fileNames;

frameNums = 1:2:length(bboxes);
for ii = 1:length(bboxes)
    fileName = fullfile(positiveFolder,fileNames{ii});
    bbox = bboxes{ii};
    img = imread(fileName);
    figure(100);clf;
    imagesc(img);axis equal; hold on;
    rectangle(gca,'Position',bbox);
    pause(0.1);
end

