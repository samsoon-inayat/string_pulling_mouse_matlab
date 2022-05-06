% clear all
clc
overwrite = 0;
mainFolder = 'D:\Dropbox\OneDrive\Data\String_Pulling\Surjeet';
pdfFolder = 'D:\Dropbox\OneDrive\Data\String_Pulling\Surjeet\pdfs';


dataFolders = {'Pantomime_OLD_Whole_body';'Pantomime_PARK_Whole_body';'Pantomime_YOUNG_Whole_body';'Real_OLD_Whole_body';'REAL_PARK_Whole_body';'Real_YOUNG_Whole_body'};
metaFiles = {'vid_name_range (1).mat';'vid_name_range (1).mat';'vid_name_range.mat';'vid_name_range.mat';'vid_name_range.mat';'vid_name_range.mat';};
dii = 6;
data_folder = fullfile(mainFolder,dataFolders{dii});
filename = fullfile(data_folder,metaFiles{dii});

file_list = load(filename);
vid_files = file_list.vid_name_range;

for ii = 1:length(vid_files)
    files_to_process{ii} = vid_files(ii).name;
end
files_to_process_indices = 1:length(files_to_process);
image_resize_factor = 4; imrf = image_resize_factor; % define both variables because both are being used in different files
readConfigs = 0; setEpochs = 0; defineZoomWindows = 0; defineZoomWindowsICA = 0; miscFunc = 0; processData = 1;
%% Load Config Files
while readConfigs
    for ii = 1:length(vid_files)
        pd_folder = fullfile(data_folder,sprintf('%s_processed_data',files_to_process{ii}(1:(end-4))));
        config = get_config_file(pd_folder);
        [success,d] = load_meta_data(config);
        config.md = d;
        config.file_name = files_to_process{ii};
        config.file_path = data_folder;
        config_info{ii} = config;
    end
    return;
end

%% set Epochs
while setEpochs
    for ii = 1:length(vid_files)
        config = config_info{ii};
        data = {vid_files(ii).startstopF(1),vid_files(ii).startstopF(2)};
        setParameter(config,'Epochs',data);
        tconfig = get_config_file(config.pd_folder); config.names = tconfig.names; config.values = tconfig.values;
        config_info{ii} = config;
    end
    return;
end

%% defining zoom windows
while defineZoomWindows
    for ii = 1:length(vid_files)
        if ~ismember(files_to_process_indices,ii)
            continue;
        end
%         ii =  1;
        config = config_info{ii}; config1 = config;
        [sfn,efn] = getFrameNums(config);
        [success,config.data] = load_data(config,sfn:efn);
        [success,config1.data] = load_data(config,1:5);
        no_gui_set_zoom_window_manually(config1,1);
        tconfig = get_config_file(config.pd_folder); config.names = tconfig.names; config.values = tconfig.values;
        zw = getParameter(config,'Auto Zoom Window');
        zw = [zw(1)-100 zw(2)-200 zw(3)+100 zw(4)];
        if zw(1) < 0
            zw(1) = 1;
        end
        if zw(2) < 0
            zw(2) = 1;
        end
        if zw(3) > config1.data.frame_size(2)
            zw(3) = config1.data.frame_size(2);
        end
        if zw(4) > config1.data.frame_size(1)
            zw(4) = config1.data.frame_size(1);
        end
        setParameter(config,'Auto Zoom Window',zw);
        tconfig = get_config_file(config.pd_folder); config.names = tconfig.names; config.values = tconfig.values;
        playFrames(config,10);
        no_gui_set_scale(config1,1);
        config = rmfield(config,'data');
        config_info{ii} = config;
        n = 0;
    end
    return;
end

%% defining zoom windows ICA
while defineZoomWindowsICA
    for ii = 1:length(vid_files)
        if ~ismember(files_to_process_indices,ii)
            continue;
        end
%         ii =  1;
        config = config_info{ii}; config1 = config;
        disp(config.pd_folder);
        [sfn,efn] = getFrameNums(config);
        frames = get_zoomed_frames(config,sfn:efn,imrf);
        rgbFrames = [];
        for fn = 1:length(frames)
%             fn
            temp = rgb2gray(frames{fn});
%             tempR = imresize(temp,rfact);
            rgbFrames(:,:,fn) = temp;
        end
        d_rgbFrames = diff(rgbFrames,1,3);
        md_rgbFrames = max(d_rgbFrames,[],3);
        mask = bwconvhull(md_rgbFrames > mean(md_rgbFrames(:)));
        figure(100);clf;subplot 121;imagesc(md_rgbFrames);axis equal;subplot 122;imagesc(mask);axis equal;
        ds = load_ds(config);
        try
            ds = rmfield(ds,'mean_mask');
        catch
        end
        ds.mean_mask_from_diff = mask;
        ds.max_diff_grayFrames = md_rgbFrames;
        ds.mean_diff_grayFrames = mean(d_rgbFrames,3);
        fileName = sprintf('descriptive_statistics_%d_%d.mat',sfn,efn);
        fileName = fullfile(config.md.processed_data_folder,fileName);
        save(fileName,'-struct','ds');
        n = 0;
    end
    return;
end

%% check the epoch frame numbers
for ii = 1:length(vid_files)
    config = config_info{ii};
    [sfn,efn] = getFrameNums(config);
    if vid_files(ii).startstopF(1) == sfn && vid_files(ii).startstopF(2) == efn
        disp(sprintf('%d = good',ii));
    else
        disp(sprintf('%d = bad',ii));
        error
    end
end


%% checking zoom window and epochs
if miscFunc
    for ii = 1:length(vid_files)
        if ~ismember(files_to_process_indices,ii)
            continue;
        end
%         ii =  1;
        config = config_info{ii};
%         winopen(config.pd_folder);
%         [sfn,efn] = getFrameNums(config);
%         [success,temp] = load_data(config);
%         [success,config.data] = load_data(config,sfn:efn);
%         tconfig = get_config_file(config.pd_folder); config.names = tconfig.names; config.values = tconfig.values;
        scale(ii) = getParameter(config,'Scale');
        zw(ii,:) = getParameter(config,'Auto Zoom Window');
%         playEpoch(config,1,10);
    end
    return;
end


%% Whole Body Analysis
if processData
    find_temporal_xics_options = [1 2 3];%{'Entropy','Higuchi Fractal Dimension','Fano Factor'};
    for ii =1:length(vid_files)
        if ~ismember(files_to_process_indices,ii)
            continue;
        end
        config = config_info{ii};
        [success,config.data] = load_data(config);
        tconfig = get_config_file(config.pd_folder); config.names = tconfig.names; config.values = tconfig.values;
        estimate_motion(config);
        descriptive_statistics(config);
        find_temporal_xics(config);
        find_PCs(config);
        find_ICs(config);
        find_fractal_dimensions_and_entropy(config);
        clear config;
    end
end
