% clear all
clc
mainFolder = 'G:\OneDrives\OneDrive\Data\String_Pulling\Surjeet';
pdfFolder = 'G:\OneDrives\OneDrive\Data\String_Pulling\Surjeet\pdfs';
mainFolder = 'E:\Users\samsoon.inayat\OneDrive - University of Lethbridge\Data\StringPulling\Surjeet';
pdfFolder = 'E:\Users\samsoon.inayat\OneDrive - University of Lethbridge\Data\StringPulling\Surjeet\pdfs';
if ~exist(pdfFolder,'dir')
    mkdir(pdfFolder)
end

dataFolders = {'Pantomime_OLD_Whole_body';'Pantomime_PARK_Whole_body';'Real_OLD_Whole_body';'REAL_PARK_Whole_body'};
metaFiles = {'vid_name_range (1).mat';'vid_name_range (1).mat';'vid_name_range.mat';'vid_name_range.mat'};
for dii = 1:4
    data_folder = fullfile(mainFolder,dataFolders{dii});
    filename = fullfile(data_folder,metaFiles{dii});
    file_list = load(filename);
    vid_files = file_list.vid_name_range;
    for ii = 1:length(vid_files)
        files_to_process{ii} = vid_files(ii).name;
    end
    image_resize_factor = 4; imrf = image_resize_factor; % define both variables because both are being used in different files
    number_of_files(dii) = length(vid_files);
    for ii = 1:length(vid_files)
        pd_folder = fullfile(data_folder,sprintf('%s_processed_data',files_to_process{ii}(1:(end-4))));
        config = get_config_file(pd_folder);
        [success,d] = load_meta_data(config);
        config.md = d;
        config.file_name = files_to_process{ii};
        config.file_path = data_folder;
        configs{dii,ii} = config;
    end
end

allLoadingFunctions = {'load_motion','load_ds','load_entropy','load_pcs','load_ics','load_fractal_dim_and_entropy'};
allVarNames = {'motion','ds','ent','pcs','ics','fd_ent'};

for dii = 1:4
    for ii = 1:number_of_files(dii)
        config = configs{dii,ii};
        pd_folder = config.pd_folder;
        for ss = 1:length(allLoadingFunctions)
            [dii ii ss]
            cmdTxt = sprintf('%s_b{dii,ii} = %s(config);',allVarNames{ss},allLoadingFunctions{ss});
            eval(cmdTxt);
        end
    end
end


return
