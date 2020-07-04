function ds = descriptive_statistics(handles,frameNums)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
    [sfn,efn] = getFrameNums(handles);
    frameNums = sfn:efn;
    selfRun = 1;
else
    selfRun = 0;
end

handles.md = get_meta_data(handles);
sfn = frameNums(1);
efn = frameNums(end);

fileName = sprintf('descriptive_statistics_masks_%d_%d.mat',sfn,efn);
fileName = fullfile(handles.md.processed_data_folder,fileName);
if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
    ds = load(fileName);
    view_descriptive_statistics_masks(handles,ds,'descriptive_stats_masks');
    return;
end

%%


% omasksMap = {'body','right ear','left ear','nose','right hand','left hand','string','background'};
f = get_zoomed_object_masks(handles,frameNums,selfRun,{[1];[4];[2 3];[5 6]});
ds_body = get_ds_vals(f{1});
ds_nose = get_ds_vals(f{2});
ds_ears = get_ds_vals(f{3});
ds_hands = get_ds_vals(f{4});
% ds_string = get_ds_vals(f{5});


masks.body = ds_body;
masks.ears = ds_ears;
masks.nose = ds_nose;
masks.hands = ds_hands;
% masks.string = ds_string;


ds.masks = masks;

save(fileName,'-struct','ds');
view_descriptive_statistics_masks(handles,ds,'descriptive_stats_masks');

displayMessage(handles,'Done!',{'foregroundcolor','b'});



