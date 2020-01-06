% load data
clear all
clc
mainFolder = 'G:\OneDrives\OneDrive\Data\String_Pulling';
pdfFolder = 'G:\OneDrives\OneDrive\OneDrive_U_Leth\Google Drive\Projects\String_Pulling_Mouse_Matlab\StringPullingMouse_4_0\FiguresForPaper\pdfs';

blackFolder = fullfile(mainFolder,'Black_Videos - v4');
whiteFolder = fullfile(mainFolder,'White_Videos - v4');

temp = dir(blackFolder);
ind = 1;
for ii = 1:length(temp)
    if ~temp(ii).isdir
        blackFiles{ind} = temp(ii).name;
        ind = ind + 1;
    end
end

blackFiles = blackFiles(1:5);

temp = dir(whiteFolder);
ind = 1;
for ii = 1:length(temp)
    if ~temp(ii).isdir
        whiteFiles{ind} = temp(ii).name;
        ind = ind + 1;
    end
end

for ii = 1:5
    ii
    %black
    pd_folder = fullfile(blackFolder,sprintf('%s_processed_data',blackFiles{ii}(1:(end-4))));
    config = get_config_file(pd_folder);
    [success,d] = load_meta_data(config);
    config.md = d;
    config_b{ii} = config;
    
    pd_folder = fullfile(whiteFolder,sprintf('%s_processed_data',whiteFiles{ii}(1:(end-4))));
    config = get_config_file(pd_folder);
    [success,d] = load_meta_data(config);
    config.md = d;
    config_w{ii} = config;
end

allLoadingFunctions = {'load_motion','load_ds','load_dsm','load_entropy','load_pcs','load_ics','load_fractal_dim_and_entropy'};
allVarNames = {'motion','ds','dsm','ent','pcs','ics','fd_ent'};
sel = [1:7]; sel_bw = [1 1]; animal_numbers = [1:5];
selectedLoadingFunctions = allLoadingFunctions(sel); selectedVarNames = allVarNames(sel);
for iii = 1:length(animal_numbers)
    ii = animal_numbers(iii);
    %black
    if sel_bw(1) == 1
        pd_folder = fullfile(blackFolder,sprintf('%s_processed_data',blackFiles{ii}(1:(end-4))));
        config = config_b{ii};
        for ss = 1:length(selectedLoadingFunctions)
            cmdTxt = sprintf('%s_b{ii} = %s(config);',selectedVarNames{ss},selectedLoadingFunctions{ss});
            eval(cmdTxt);
        end
    end
     %white
    if sel_bw(2) == 1
        pd_folder = fullfile(whiteFolder,sprintf('%s_processed_data',whiteFiles{ii}(1:(end-4))));
        config = config_w{ii};
        for ss = 1:length(selectedLoadingFunctions)
            cmdTxt = sprintf('%s_w{ii} = %s(config);',selectedVarNames{ss},selectedLoadingFunctions{ss});
            eval(cmdTxt);
        end
    end
end


for ii = 1:5
    config = config_b{ii};
    [sfn,efn] = getFrameNums(config);
    N_b(ii) = efn - sfn + 1;
    config = config_w{ii};
    [sfn,efn] = getFrameNums(config);
    N_w(ii) = efn - sfn + 1;
end

imrf = 4;
for ii = 1:5
    ii
    config = config_b{ii};
    [sfn,efn] = getFrameNums(config);
    frames_b{ii} = get_zoomed_frames(config,sfn:efn,imrf);
    config = config_w{ii};
    [sfn,efn] = getFrameNums(config);
    frames_w{ii} = get_zoomed_frames(config,sfn:efn,imrf);
end

for ii = 1:5
    ii
    config = config_b{ii};
    [~,p_data_b{ii}] = load_processed_data(config);
    config = config_w{ii};
    [~,p_data_w{ii}] = load_processed_data(config);
end

for ii = 1:5
    ii
    config = config_b{ii};
    all_params_b{ii} = get_all_params(config);
    config = config_w{ii};
    all_params_w{ii} = get_all_params(config);
end

for ii = 1:5
    ii
    config = config_b{ii};
    scale_b(ii) = getParameter(config,'Scale');
    config = config_w{ii};
    scale_w(ii) = getParameter(config,'Scale');
end

n = 0;


%     motion_b{ii} = load_motion(config);
%     ds_b{ii} = load_ds(config);
%     ent_b{ii} = load_entropy(config);
%     pcs_b{ii} = load_pcs(config);
%     ics_b{ii} = load_ics(config);