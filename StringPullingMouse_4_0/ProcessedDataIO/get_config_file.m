function config = get_config_file(pdFolder)
fileName = fullfile(pdFolder,sprintf('%s.mat','config'));
try
    config = load(fileName);
catch
end
config.pd_folder = pdFolder;




