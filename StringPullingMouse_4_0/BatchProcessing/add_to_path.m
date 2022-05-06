function add_to_path

currentDir = pwd;
strpos = findstr(currentDir,'GitHub');
github_dir = currentDir(1:(strpos+length('GitHu')));
interDir = fullfile(github_dir,'Common');

temp = fullfile(interDir,'Matlab');addpath(temp);
temp = fullfile(interDir,'Matlab','Common');addpath(temp);
temp = fullfile(interDir,'Matlab','FigureFunctions');addpath(temp);
temp = fullfile(interDir,'Matlab','Fitting');addpath(temp);
temp = fullfile(interDir,'Matlab','Statistical_Package');addpath(temp);

addpath('D:\Dropbox\OneDrive\Data\String_Pulling\Surjeet\New_Processed_Data_May_2022');



