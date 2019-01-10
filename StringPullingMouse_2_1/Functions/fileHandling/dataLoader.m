function [d,md] = dataLoader

timerobj = timerfind('Tag','SP_video_loader');
if ~isempty(timerobj)
    stop(timerobj);
    delete(timerobj);
    clear timerobj;
end

[file_name,file_path] = getFileInfo;
if ~ischar(file_name)
    d = [];
    md = [];
    return;
end


d = getData(file_name,file_path);
md = getMetaData(file_name,file_path,d);
% string_pulling_behavior_analytics(d,md);
% epochs = getEpochs(d,md);
n=0;
