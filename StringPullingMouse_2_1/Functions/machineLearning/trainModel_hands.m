function trainModel_hands(handles,sfn,efn)

positiveFolder = fullfile(pwd,'functions','machineLearning','handsPositiveData');
negativeFolder = fullfile(pwd,'functions','machineLearning','handsNegativeData');

fileName = fullfile(positiveFolder,'dataTable.mat');
temp = load(fileName);
dataTable = temp.dataTable; clear temp;

positiveInstances = dataTable;

imDir = positiveFolder;


negativeFolder = negativeFolder;

negativeImages = imageDatastore(negativeFolder);

trainCascadeObjectDetector('handsDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.01,'NumCascadeStages',10);

% detector = vision.CascadeObjectDetector('stopSignDetector.xml');
% img = imread('stopSignTest.jpg');
% bbox = step(detector,img);
% detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'stop sign');
% figure; imshow(detectedImg);
