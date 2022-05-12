%%
% clear all
colormaps = load('colorblind_colormap.mat');
% colormaps.colorblind = flipud(colormaps.colorblind);
mData.colors = mat2cell(colormaps.colorblind,[ones(1,size(colormaps.colorblind,1))]);%{[0 0 0],[0.1 0.7 0.3],'r','b','m','c','g','y'}; % mData.colors = getColors(10,{'w','g'});
%%

reloadConfig = 0; reloadData = 0; reloadData_NN = 0;

if reloadConfig
    clc

    mainFolder = 'D:\Dropbox\OneDrive\Data\String_Pulling\Surjeet';
    pdfFolder = 'D:\Dropbox\OneDrive\Data\String_Pulling\Surjeet\pdfs';
    mainFolder = 'D:\OneDrive - University of Lethbridge\Data\StringPulling\Surjeet';
    pdfFolder = 'D:\OneDrive - University of Lethbridge\Data\StringPulling\Surjeet';
    if ~exist(pdfFolder,'dir')
        mkdir(pdfFolder)
    end

    dataFolders = {'Pantomime_OLD_Whole_body';'Pantomime_PARK_Whole_body';'Pantomime_YOUNG_Whole_body';'Real_OLD_Whole_body';'REAL_PARK_Whole_body';'Real_YOUNG_Whole_body'};
    metaFiles = {'vid_name_range (1).mat';'vid_name_range (1).mat';'vid_name_range.mat';'vid_name_range.mat';'vid_name_range.mat';'vid_name_range.mat';};
    for dii = 1:6
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
    return;
end
%%
if reloadData
    allLoadingFunctions = {'load_motion','load_ds','load_entropy','load_pcs','load_ics','load_fractal_dim_and_entropy'};
    allVarNames = {'motion','ds','ent','pcs','ics','fd_ent'};
    selInd = 1:length(allLoadingFunctions);
    allLoadingFunctions = allLoadingFunctions(selInd);
    allVarNames = allVarNames(selInd);
    for dii = 1:6
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
    for dii = 1:6
        for ii = 1:number_of_files(dii)
            config = configs{dii,ii};
            [sfn,efn] = getFrameNums(config);
            N_frames(dii,ii) = efn - sfn + 1;
        end
    end
    return;
end

%%
if reloadData_NN
    fileName = 'ALL_Park_Params_for_Sam_Updated.mat';
    fileName = fullfile(mainFolder,fileName);
    NN = load(fileName);
    return;
end
%%
ind = 1;
for dii = 1:6
    for ii = 1:number_of_files(dii)
        [dii ii]
        this_ds = ds_b{dii,ii}; this_ent = ent_b{dii,ii};
        this_pc = pcs_b{dii,ii}; this_ic = ics_b{dii,ii};
%         this_ds = get_mean_mask(this_ds,this_ent,this_pc,this_ic);
        ds_b{dii,ii} = set_mean_mask(this_ds);
%         this_ds = get_mean_mask(this_ds,this_ent,this_pc,this_ic);
%         ds_b{dii,ii} = this_ds;
    end
end
disp('Done');





