function margins = get_margins(handles,object)


varNamesB = {'edit_margin_left','edit_margin_right','edit_margin_top','edit_margin_bottom'};

varNamesH = {'edit_margin_leftH','edit_margin_rightH','edit_margin_topH','edit_margin_bottomH'};

if strcmp(object,'body')
    varNames = varNamesB;
else
    varNames = varNamesH;
end

for ii = 1:length(varNames)
    cmdText = sprintf('margins(ii) = str2double(get(handles.%s,''String''));',varNames{ii});
    eval(cmdText);
end