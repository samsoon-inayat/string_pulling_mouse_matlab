function ics = find_ICs(handles,frameNums)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
    selfRun = 1;
    [sfn,efn] = getFrameNums(handles);
    frameNums = sfn:efn;
else
    if ~isfield(handles,'figure1')
        handles.md.processed_data_folder = handles.pd_folder;
        selfRun = evalin('base','imrf');
    else
        selfRun = 0;
        handles.md = get_meta_data(handles);
    end
end

sfn = frameNums(1);
efn = frameNums(end);

fileName = sprintf('ics_%d_%d.mat',sfn,efn);
fileName = fullfile(handles.md.processed_data_folder,fileName);
if isfield(handles,'figure1')
    if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
        ics = load_ics(handles);
        viewICs_min_max(handles,ics,'ICs');
        return;
    end
end

fn = get_zoomed_frames(handles,frameNums,selfRun);
% fn_no_string = remove_string(handles,fn,cS,cF);
% play_frames(handles,fn,fn_no_string);

if isfield(handles,'figure1')
    num_comps = str2double(get(handles.edit_num_components,'String'));
else
    num_comps = 0.5;
end
if num_comps < 1
    num_comps = floor(num_comps * length(fn));
end

ics.nrows = size(fn{1},1);
ics.ncols = size(fn{1},2);
ics.nFrames = length(fn);

displayMessage(handles,'Finding ICs of image sequence');
f = convertToGrayScale(handles,fn);
ics.ics = get_ica(f,num_comps);

displayMessage(handles,'Finding ICs of motion profile');
motion = load_motion(handles);
speed = motion.speedInCmPerSec;
ics.ics_motion = get_ica(speed,num_comps);

displayMessage(handles,'Finding ICs of PCs');
pc = load_pcs(handles);
% hf = figure_window(handles,1000);
% plot(pc.explained);
% prompt = {'Explained Variance Threshold'};
% dlgtitle = 'Please Enter';
% dims = [1 35];
% definput = {'0.000'};
% answer = inputdlg(prompt,dlgtitle,dims,definput);
% if isempty(answer)
%     ev_thresh = 0.000;
% else
%     ev_thresh = str2double(answer{1});
% end
% close(hf);
ev_thresh = 0;
frames = pc.score;%(:,pc.explained>ev_thresh);%(:,1:npcs);
ics.pc.nrows = size(fn{1},1);
ics.pc.ncols = size(fn{1},2);
ics.pc.nFrames = length(fn);
ics.pc.ics = get_ica(frames,num_comps);

displayMessage(handles,'Finding ICs of PCs motion profile');
pc = pc.motion;
frames = pc.score;%(:,pc.explained>ev_thresh);%(:,1:npcs);
ics.pc.ics_motion = get_ica(frames,num_comps);

ics.pc.explained_variance_threshold = ev_thresh;


displayMessage(handles,'Saving ICs');
save(fileName,'-struct','ics');

if isfield(handles,'figure1')
    set(handles.pushbutton_find_ICs,'userdata',ics);
    viewICs_min_max(handles,ics,'ICs');
end
displayMessage(handles,'Done!');


function ics = get_ica(f,nics)
if length(size(f)) == 3
    nrows = size(f,1);
    ncols = size(f,2);
    nFrames = size(f,3);
    fs = reshape(f,nrows*ncols,nFrames);
else
    fs = f;
end
% nics = nFrames;%floor(0.75*nFrames);
% nics = 24;
rng(1);
[ics.Z, W, T, mu] = fastICA(fs',nics,'kurtosis',1);%,type,flag)



%% old code
% f = convertToGrayScale(handles,fn_no_string);
% ics.ics_image_sequence_no_string = get_ica(f);

% f = get_masks(fn,cF,[]);
% ics.ics_body_ears_nose = get_ica(f);

% f = get_masks(fn,[cF;cN;cE],[]);
% ics.ics_body_ears_nose = get_ica(f);
% 
% f = get_masks(fn,cS,[]);
% ics.ics_string = get_ica(f);
% 
% f = get_masks(fn,cH,[]);
% ics.ics_hands = get_ica(f);