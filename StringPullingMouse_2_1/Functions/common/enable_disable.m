function enable_disable(handles,ed)

if ed
    en = 'On';
    set(handles.pushbutton_stop_processing,'visible','off');
    set(handles.checkbox_updateDisplay,'visible','off');
else
    en = 'off';
    set(handles.pushbutton_stop_processing,'visible','on');
    set(handles.checkbox_updateDisplay,'visible','on');
end

names = {'uibuttongroup_objectToProcess';'uibuttongroup_framesToProcess';
    'uipanel_colors_and_masks';'uipanel_zoom_scale';'uipanel_epochs';
    'uipanel_plots_misc';'uipanel_control_frame_display';'uipanel_process';'uipanel_Info';'pushbutton_setTouchingHandsThreshold';
    'uipanel_masks';'uipanel_body_estimation';
    'checkbox_over_write'};

for ii = 1:length(names)
    cmdTxt = sprintf('set(handles.%s,''visible'',''%s'')',names{ii},en);
    eval(cmdTxt);
end