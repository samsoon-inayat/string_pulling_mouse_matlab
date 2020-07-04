function userPlot(handles)

fn = 4;
if fn == 1
    figure_images_montage(handles);
end

if fn == 2
    figure_masks(handles);
end

if fn == 3
    figure_fur(handles);
end

if fn == 4
    figure_body_params(handles);
end

if fn == 5
    figure_hands(handles);
end

if fn == 6
    figure_kinematics(handles);
end

if fn == 7
    figure_higher_order_processing(handles);
end


% generateColorHistograms(handles);


