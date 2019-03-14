function enable_disable(handles,category,ed)

if ed
    en = 'On';
else
    en = 'off';
end
if category == 1
    names = {'uibuttongroup_objectToProcess';'uibuttongroup_framesToProcess';
        'uipanel_colors_and_masks';'uipanel_zoom_scale';'uipanel_epochs';
        'uipanel_plots_misc';'uipanel_control_frame_display';'uipanel_process';'uipanel_Info';
        'uipanel_select_objects_and_frames'};
end

if category == 2
    names = {'uibuttongroup_objectToProcess';'uibuttongroup_framesToProcess';
        'uipanel_colors_and_masks';'uipanel_zoom_scale';'uipanel_epochs';
        'uipanel_plots_misc';'uipanel_control_frame_display';'uipanel_process';'uipanel_Info';'pushbutton_setTouchingHandsThreshold';
        'pushbutton_saveMasks';'uipanel_masks';'uipanel_body_estimation';'uipanel_hands_identification_parameters';
        'checkbox_over_write';
        'uipanel_select_objects_and_frames'};
end


for ii = 1:length(names)
    cmdTxt = sprintf('set(handles.%s,''visible'',''%s'')',names{ii},en);
    eval(cmdTxt);
end