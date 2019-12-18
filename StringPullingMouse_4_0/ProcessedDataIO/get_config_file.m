function config = get_config_file(pdFolder)
fileName = fullfile(pdFolder,sprintf('%s.mat','config'));
config = load(fileName);
config.pd_folder = pdFolder;




