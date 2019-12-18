function save_file_data(pdFolder,sfn,efn,filename,data)

if ~isempty(sfn)
    fileName = fullfile(pdFolder,sprintf('%s_%d_%d.mat',filename,sfn,efn));
else
    fileName = fullfile(pdFolder,sprintf('%s.mat',filename));
end

save(fileName,'-struct','data');




