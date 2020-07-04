function [success,d] = load_meta_data(handles)

tags = {'Nose','Left Ear','Right Ear','Left Hand','Right Hand','String','Subject','Subject Props'};
tag_labels = {'N','LE','RE','LH','RH','S',''};
epoch_tags = {'Generic','L-Release','L-Reach','L-Grasp','L-Pull','L-Push','R-Release','R-Reach','R-Grasp','R-Pull','R-Push'};
if isfield(handles,'figure1')
    file_path = get(handles.text_folderName,'userdata');
    file_name = get(handles.text_fileName,'userdata');
    file_path = fullfile(file_path,sprintf('%s_processed_data',file_name(1:(end-4))));
else
    file_path = handles.pd_folder;
end
if ~exist(file_path,'dir')
    mkdir(file_path)
end

d.masks_folder = fullfile(file_path,'masks');
if ~exist(d.masks_folder,'dir')
    mkdir(d.masks_folder)
end

d.omasks_folder = fullfile(file_path,'object_masks');
if ~exist(d.omasks_folder,'dir')
    mkdir(d.omasks_folder)
end


results_file_name = 'results.mat';
resultsDLC_file_name = 'results_DLC.mat';
config_file_name = 'config.mat';

if ~exist(fullfile(file_path,config_file_name),'file')
    [names,values] = readConfigFile;
    save(fullfile(file_path,config_file_name),'names','values','-v7.3');
    d.params.names = names;
    d.params.values = values;
else
    d.params = load(fullfile(file_path,config_file_name));
end
d.processed_data_folder = file_path;
d.results_file_name = fullfile(file_path,results_file_name);
d.config_file_name = fullfile(file_path,config_file_name);
d.resultsDLC_file_name = fullfile(file_path,resultsDLC_file_name);
d.tags = tags;
d.tag_labels = tag_labels;
d.epoch_tags = epoch_tags;
success = 1;

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