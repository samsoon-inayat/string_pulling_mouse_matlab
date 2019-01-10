function setParameter(handles,paramName,value)

params = load(handles.md.config_file_name);
names = params.names;
values = params.values;
indexC = strcmp(names,paramName);
% indexC = strfind(names,paramName);
ind = find(indexC);%find(not(cellfun('isempty', indexC)));
if ~isempty(ind)
    values{ind} = value;
    save(handles.md.config_file_name,'names','values','-v7.3');
else
    names{length(names)+1} = paramName;
    values{length(values)+1} = value;
end

params.names = names;
params.values = values;
set(handles.text_params,'userdata',params);
save(handles.md.config_file_name,'names','values','-v7.3');

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





