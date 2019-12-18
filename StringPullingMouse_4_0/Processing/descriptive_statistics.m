function ds = descriptive_statistics(handles,frameNums)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
    [sfn,efn] = getFrameNums(handles);
    frameNums = sfn:efn;
    selfRun = 1;
else
    if ~isfield(handles,'figure1')
        handles.md.processed_data_folder = handles.pd_folder;
        selfRun = evalin('base','imrf');
    else
        handles.md = get_meta_data(handles);
        selfRun = 0;
    end
end

sfn = frameNums(1);
efn = frameNums(end);

fileName = sprintf('descriptive_statistics_%d_%d.mat',sfn,efn);
fileName = fullfile(handles.md.processed_data_folder,fileName);
if isfield(handles,'figure1')
    if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
        ds = load(fileName);
        view_descriptive_statistics(handles,ds,'descriptive_stats');
        return;
    end
end

fn = get_zoomed_frames(handles,frameNums,selfRun);

%%

% fR = getColorComponent(fn,'R');
% outR = get_ds_vals(fR);
mouse_color = getParameter(handles,'Mouse Color');

if strcmp(mouse_color,'Black')
    f = convertToGrayScale(handles,fn,1);
else
    f = convertToGrayScale(handles,fn,0);
end
ds = get_ds_vals(f);
meanframe = ds.mean; threshold = mean(meanframe(:)); mask = zeros(size(meanframe)); 

% mask(meanframe < threshold) = 1;

mask(meanframe > threshold) = 1;

ds.mean_mask = mask;

motion = load_motion(handles);
if isempty(motion)
    ds.motion = [];
else
    speed = motion.speedInCmPerSec;
    ds.motion = get_ds_vals(speed);
end

% % % % cS = getColors(handles,'String',4:6,0);    cF = getColors(handles,'Fur',4:6,0);    cH = getColors(handles,'hands',4:6,0);
% % % % cN = getColors(handles,'Nose',4:6,0);    cE = getColors(handles,'Ears',4:6,0);
% % % % displayMessage(handles,'Finding descriptive stats of body masks',{'foregroundcolor','b'});
% % % % f = get_masks(fn,cF,[]);
% % % % ds_body = get_ds_vals(f);
% % % % 
% % % % % displayMessage(handles,'Finding descriptive stats of nose masks',{'foregroundcolor','b'});
% % % % % f = get_masks(fn,[cN],[]);
% % % % % ds_nose = get_ds_vals(f);
% % % % % 
% % % % % displayMessage(handles,'Finding descriptive stats of ears masks',{'foregroundcolor','b'});
% % % % % f = get_masks(fn,[cE],[]);
% % % % % ds_ears = get_ds_vals(f);
% % % % 
% % % % displayMessage(handles,'Finding descriptive stats of hand masks',{'foregroundcolor','b'});
% % % % f = get_masks(fn,cH,[]);
% % % % ds_hands = get_ds_vals(f);
% % % % 
% % % % displayMessage(handles,'Finding descriptive stats of string masks',{'foregroundcolor','b'});
% % % % f = get_masks(fn,cS,[]);
% % % % ds_string = get_ds_vals(f);
% % % %     
% % % % 
% % % % 
% % % % 
% % % % masks.body = ds_body;
% % % % % masks.ears = ds_ears;
% % % % % masks.nose = ds_nose;
% % % % masks.string = ds_string;
% % % % masks.hands = ds_hands;
% % % % 
% % % % 
% % % % ds.masks = masks;

save(fileName,'-struct','ds');
view_descriptive_statistics(handles,ds,'descriptive_stats');

displayMessage(handles,'Done!',{'foregroundcolor','b'});



