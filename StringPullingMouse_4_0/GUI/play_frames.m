function play_frames(handles,fn,fn_no_string)

hf = figure_window(handles,1001);
for ii = 1:length(fn)
    figure(hf);clf;
    if isempty(fn_no_string)
        imagesc(fn{ii});axis equal; 
        title(ii);
        continue;
    end
    subplot 121; imagesc(fn{ii});axis equal; 
    subplot 122; imagesc(fn_no_string{ii});axis equal;
    title(ii);
    pause(0.1);
end
n = 0;