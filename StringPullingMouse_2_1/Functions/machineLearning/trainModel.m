function trainModel(handles,sfn,efn)

furPositiveFolder = fullfile(pwd,'functions','machineLearning','furPositiveData');
furNegativeFolder = fullfile(pwd,'functions','machineLearning','furNegativeData');

fileName = fullfile(furPositiveFolder,'furDataTable.mat');
temp = load(fileName);
furDataTable = temp.furDataTable; clear temp;

positiveInstances = furDataTable;

imDir = furPositiveFolder;


negativeFolder = furNegativeFolder;

negativeImages = imageDatastore(negativeFolder);

trainCascadeObjectDetector('furDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',5);

% detector = vision.CascadeObjectDetector('stopSignDetector.xml');
% img = imread('stopSignTest.jpg');
% bbox = step(detector,img);
% detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');
% figure; imshow(detectedImg);
