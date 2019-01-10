function value = getParameter(handles,paramName)

params = get(handles.text_params,'userdata');
names = params.names;
values = params.values;

indexC = strcmp(names,paramName);
% indexC = strfind(names,paramName);
ind = find(indexC);%find(not(cellfun('isempty', indexC)));
value = values{ind};





