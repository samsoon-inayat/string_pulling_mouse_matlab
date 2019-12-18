function value = getParameter(handles,paramName)

if ~isfield(handles,'figure1')
    % in case one passes a config file to this function 
    value = get_parameter_from_config(handles,paramName);         
    return;
end

params = get(handles.text_params,'userdata');
names = params.names;
values = params.values;

if ~exist('paramName','var')
    value.names = names;
    value.values = values;
    return;
end

if strcmp(paramName,'all_names') 
    value = names;
    return;
end

indexC = strcmp(names,paramName);
% indexC = strfind(names,paramName);
ind = find(indexC);%find(not(cellfun('isempty', indexC)));
if isempty(ind)
    value = [];
    return;
end
value = values{ind};


function paramVal = get_parameter_from_config(config,param)
ind = strcmp(config.names,param);
paramVal = config.values{ind};
