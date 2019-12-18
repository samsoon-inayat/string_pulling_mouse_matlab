function data = get_file_data(pdFolder,sfn,efn,filename)

if ~isempty(sfn)
    fileName = fullfile(pdFolder,sprintf('%s_%d_%d.mat',filename,sfn,efn));
else
    fileName = fullfile(pdFolder,sprintf('%s.mat',filename));
end

if exist(fileName,'file')
    data = load(fileName);
else
    data = [];
end





