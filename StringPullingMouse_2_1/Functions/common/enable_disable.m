function enable_disable(handles,ed)

if ed
    en = 'On';
else
    en = 'off';
end

names = {'uibuttongroup_objectToProcess';'uibuttongroup_framesToProcess';
    'uipanel_colors_and_masks';'uipanel_zoom_scale';'uipanel_epochs';
    'uipanel_plots_misc';'uipanel_control_frame_display';'uipanel_process';'uipanel_Info';'pushbutton_setTouchingHandsThreshold';
    'uipanel_masks'};

for ii = 1:length(names)
    cmdTxt = sprintf('set(handles.%s,''visible'',''%s'')',names{ii},en);
    eval(cmdTxt);
end