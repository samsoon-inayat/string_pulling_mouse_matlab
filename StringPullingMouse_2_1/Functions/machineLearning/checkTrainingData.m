function storeTrainingData(handles,sfn,efn)

furPositiveFolder = fullfile(pwd,'functions','machineLearning','furPositiveData');
furNegativeFolder = fullfile(pwd,'functions','machineLearning','furNegativeData');

fileName = fullfile(furPositiveFolder,'furDataTable.mat');
temp = load(fileName);
furDataTable = temp.furDataTable; clear temp;
bboxes = furDataTable.bboxes;
fileNames = furDataTable.fileNames;

frameNums = sfn:efn;
for ii = 1:length(bboxes)
    fileName = fullfile(furPositiveFolder,fileNames{ii});
    bbox = bboxes{ii};
    img = imread(fileName);
    figure(1000);clf;
    imagesc(img);axis equal; hold on;
    rectangle(gca,'Position',bbox);
    pause(0.1);
end

