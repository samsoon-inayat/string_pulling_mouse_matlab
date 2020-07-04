function margins = get_grid_specs(handles)


varNames = {'edit_grid_vert','edit_grid_horiz','edit_grid_thresh'};

for ii = 1:length(varNames)
    cmdText = sprintf('margins(ii) = str2double(get(handles.%s,''String''));',varNames{ii});
    eval(cmdText);
end