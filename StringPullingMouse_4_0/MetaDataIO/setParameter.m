function setParameter(handles,paramName,value)

md = get_meta_data(handles);
for ii = 1:10
    try
        params = load(md.config_file_name);
        break;
    catch
        disp(sprintf('couln''t read config file ... try 1 of %d',ii));
    end
end
names = params.names;
values = params.values;
indexC = strcmp(names,paramName);
% indexC = strfind(names,paramName);
ind = find(indexC);%find(not(cellfun('isempty', indexC)));
if ~isempty(ind)
    values{ind} = value;
%     save(md.config_file_name,'names','values','-v7.3');
else
    names{length(names)+1} = paramName;
    values{length(values)+1} = value;
end

params.names = names;
params.values = values;
set(handles.text_params,'userdata',params);
for ii = 1:10
    try
        save(md.config_file_name,'names','values','-v7.3');
        break;
    catch
        disp(sprintf('couln''t write config file ... try 1 of %d',ii));
    end
end

% params = load(handles.md.config_file_name);
% names = params.names;
% values = params.values;
% 
% indexC = strcmp(names,paramName);
% ind = find(not(cellfun('isempty', indexC)));
% if ~isempty(ind)
%     values{ind} = value;
%     save(handles.md.config_file_name,'names','values','-v7.3');
% else
%     names{length(names)+1} = paramName;
%     values{length(values)+1} = value;
% end
% 
% params.names = names;
% params.values = values;
% set(handles.text_params,'userdata',params);
% save(handles.md.config_file_name,'names','values','-v7.3');





