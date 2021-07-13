function pc = find_PCs(handles,frameNums)

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
        [sfn,efn] = getFrameNums(handles);frameNums = sfn:efn;
    else
        handles.md = get_meta_data(handles);
        selfRun = 0;
    end
end

sfn = frameNums(1);
efn = frameNums(end);

fileNamePC = sprintf('pcs_%d_%d.mat',sfn,efn);
fileNamePC = fullfile(handles.md.processed_data_folder,fileNamePC);
if isfield(handles,'figure1')
    if exist(fileNamePC,'file') && ~get(handles.checkbox_over_write,'Value')
        pc = load_pcs(handles);
        viewPCs(handles,pc,'PCs');
        return;
    end
end

[fns,image_resize_factor] = get_zoomed_frames(handles,frameNums,selfRun);
fn = convertToGrayScale(handles,fns);

%% find PCs
displayMessage(handles,'Finding PCs of image sequence');
pc.image_resize_factor = image_resize_factor;
pc.nrows = size(fn,1);
pc.ncols = size(fn,2);
pc.nFrames = size(fn,3);
fs = reshape(fn,pc.nrows*pc.ncols,pc.nFrames);
[pc.score,pc.coeff,pc.latent,pc.tsquared,pc.explained,pc.mu] = pca(fs');

motion = load_motion(handles);
if isempty(motion)
    pc.motion = [];
else
    displayMessage(handles,'Finding PCs of motion profile');
    fn = motion.speedInCmPerSec;
    pcm.image_resize_factor = image_resize_factor;
    pcm.nrows = size(fn,1);
    pcm.ncols = size(fn,2);
    pcm.nFrames = size(fn,3);
    fs = reshape(fn,pcm.nrows*pcm.ncols,pcm.nFrames);
    [pcm.score,pcm.coeff,pcm.latent,pcm.tsquared,pcm.explained,pcm.mu] = pca(fs');
    pc.motion = pcm;
end

save(fileNamePC,'-struct','pc');
if isfield(handles,'figure1')
    set(handles.pushbutton_find_PCs,'userdata',pc);
end
viewPCs(handles,pc,'PCs',[101,102]);
