function d = getMetaData(file_name,file_path,d1)
tags = {'Nose','Left Ear','Right Ear','Left Hand','Right Hand','String','Subject','Subject Props'};
tag_labels = {'N','LE','RE','LH','RH','S',''};
epoch_tags = {'Generic','L-Release','L-Reach','L-Grasp','L-Pull','L-Push','R-Release','R-Reach','R-Grasp','R-Pull','R-Push'};

file_path = fullfile(file_path,sprintf('%s_processed_data',file_name(1:(end-4))));

if ~exist(file_path,'dir')
    mkdir(file_path)
end

% results_file_name = sprintf('%s_results.mat',file_name(1:(end-4)));
% config_file_name = sprintf('%s_config.mat',file_name(1:(end-4)));
results_file_name = 'results.mat';
config_file_name = 'config.mat';
masks_file_name = 'masks.mat';
cmasks_file_name = 'cmasks.mat';
% preprocess_file_name = sprintf('%s_pre_processed_data.mat',file_name(1:(end-4)));
if ~exist(fullfile(file_path,results_file_name),'file')
    R = []; RE = []; 
    P = [];
    save(fullfile(file_path,results_file_name),'R','RE','P','-v7.3');
end
% if ~exist(fullfile(file_path,preprocess_file_name),'file')
%     frameMasks = uint8([]);
%     save(fullfile(file_path,preprocess_file_name),'frameMasks','-v7.3');
% end
if ~exist(fullfile(file_path,config_file_name),'file')
    [names,values] = readConfigFile;
    save(fullfile(file_path,config_file_name),'names','values','-v7.3');
end
d.processedDataFolder = file_path;
d.resultsMF = matfile(fullfile(file_path,results_file_name),'writable',true);
% d.preprocessMF = matfile(fullfile(file_path,preprocess_file_name),'writable',true);
% d.preprocess_file_name = fullfile(file_path,preprocess_file_name);
d.results_file_name = fullfile(file_path,results_file_name);
d.config_file_name = fullfile(file_path,config_file_name);
d.tags = tags;
d.tag_labels = tag_labels;
d.epoch_tags = epoch_tags;
d.frameSize = d1.frameSize;
global masks;
global cmasks;
disp('Please wait ... loading preprocessed variables');
tic;
if exist(fullfile(file_path,masks_file_name),'file')
    masks = load(fullfile(file_path,masks_file_name));
%     masks = MasksData.frameMasks;
end
if exist(fullfile(file_path,cmasks_file_name),'file')
    temp = load(fullfile(file_path,cmasks_file_name));
    cmasks = temp.cmasks;
    d.cmasksMF = matfile(fullfile(file_path,cmasks_file_name),'writable',true);
%     masks = MasksData.frameMasks;
end
% if isfield(d.resultsMF,'zoomWindow')
%     d.resultsMF.zoomWindow = d.preprocessMF.zoomWindow;
% end
% gradients = d.preprocessMF.gradients;
% toc


function [names,values] = readConfigFile
fileName = fullfile(pwd,'default_config.txt');
f = fopen(fileName);
ind = 1;
while 1
    thisS = fgetl(f);
    if isnumeric(thisS)
        if thisS == -1
            break;
        end
    else
        loc = strfind(thisS,'=');
        names{ind} = thisS(1:(loc-2));
        temp = thisS((loc+2):end);
        if ~isempty(str2num(temp))
            values{ind} = str2num(temp);
        else
            values{ind} = temp;
        end
        ind = ind + 1;
    end
end
fclose(f);