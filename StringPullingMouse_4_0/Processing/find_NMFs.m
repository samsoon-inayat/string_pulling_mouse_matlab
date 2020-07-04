function nmfs = find_NMFs(handles,frameNums)

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

fileName = sprintf('nmfs_%d_%d.mat',sfn,efn);
fileName = fullfile(handles.md.processed_data_folder,fileName);
if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
    nmfs = load_nmfs(handles);
    viewNMFs(handles,nmfs,'NMF');
    return;
end

[fns,image_resize_factor] = get_zoomed_frames(handles,frameNums,selfRun);
f = convertToGrayScale(handles,fns);

%% find NMFs
nrows = size(fn,1);
ncols = size(fn,2);
nFrames = size(fn,3);
fs = reshape(fn,nrows*ncols,nFrames);
displayMessage(handles,'Finding NMF of image sequence');
num_comps = str2double(get(handles.edit_num_components,'String'));
if num_comps < 1
    num_comps = floor(num_comps * nFrames);
end
% num_comps = floor(0.5*nFrames);
rng(1) % For reproducibility
[W,H,D] = nnmf(fs,num_comps);
nmfs.image_resize_factor = image_resize_factor;
nmfs.nrows = nrows;
nmfs.ncols = ncols;
nmfs.nFrames = nFrames;
nmfs.W = W;
nmfs.H = H;
nmfs.D = D;

motion = load_motion(handles);
if isempty(motion)
    nmfs.motion = [];
else
    displayMessage(handles,'Finding NMF of motion profile');
    fn = abs(motion.vxy);
    nrows = size(fn,1);
    ncols = size(fn,2);
    nFrames = size(fn,3);
    fs = reshape(fn,nrows*ncols,nFrames);
    rng(1) % For reproducibility
    [W,H,D] = nnmf(fs,num_comps);
    nmfsm.image_resize_factor = image_resize_factor;
    nmfsm.nrows = nrows;
    nmfsm.ncols = ncols;
    nmfsm.nFrames = nFrames;
    nmfsm.W = W;
    nmfsm.H = H;
    nmfsm.D = D;
    nmfs.motion = nmfsm;
end

save(fileName,'-struct','nmfs');
set(handles.pushbutton_find_NMFs,'userdata',nmfs);
viewNMFs(handles,nmfs,'NMF');


