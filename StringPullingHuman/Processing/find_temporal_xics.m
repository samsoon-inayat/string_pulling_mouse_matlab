function ds = find_temporal_xics(handles,frameNums)

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

fileName = sprintf('entropy_%d_%d.mat',sfn,efn);
fileName = fullfile(handles.md.processed_data_folder,fileName);

if isfield(handles,'figure1')
    if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
        ds = load(fileName);
        view_entropy(handles,ds,'entropy');
        return;
    end
end

[fn,imrf] = get_zoomed_frames(handles,frameNums,selfRun);
if imrf == 1
    displayMessage('Are you sure you want to use image resize factor equal to 1?');
end
%%
f = convertToGrayScale(handles,fn);

ds = load_entropy(handles);
options = {'Entropy','Higuchi Fractal Dimension','Fano Factor','P-values of Variance Ratio Test'};
if isfield(handles,'figure1')
    answer = generalGUIForSelection(options);
    if isequal(answer,0)
        return;
    end
else
    answer = evalin('base','find_temporal_xics_options');
end
% display(options{answer});
displayMessage(handles,'Finding values for image sequence',{'foregroundcolor','b'});
if any(ismember(answer,1))
    ds = find_entropy(f);
end
if any(ismember(answer,2))
    ds.HFD = find_higuchi(f);
end
if any(ismember(answer,3))
    ds.FF = find_fano_factor(f);
end
if any(ismember(answer,4))
    ds.pVRT = find_p_values_vratiotest(f);
end

motion = load_motion(handles);
if isempty(motion)
    ds.motion = [];
else
    speed = motion.speedInCmPerSec;
    displayMessage(handles,'Finding values for motion profile',{'foregroundcolor','b'});
    if any(ismember(answer,1))
        ds.motion = find_entropy(speed);
    end
    if any(ismember(answer,2))
        ds.HFD.motion = find_higuchi(speed);
    end
    if any(ismember(answer,3))
        ds.FF.motion = find_fano_factor(speed);
    end
    if any(ismember(answer,4))
        ds.pVRT.motion = find_p_values_vratiotest(speed);
    end
end

% cS = getColors(handles,'String',4:6,0);
% cF = getColors(handles,'Fur',4:6,0);
% cH = getColors(handles,'hands',4:6,0);
% cN = getColors(handles,'Nose',4:6,0);
% cE = getColors(handles,'Ears',4:6,0);
% 
% displayMessage(handles,'Finding entropy of body masks',{'foregroundcolor','b'});
% f = get_masks(fn,[cF;cN;cE],[]);
% ds_body = find_entropy(f);
% 
% displayMessage(handles,'Finding entropy of string masks',{'foregroundcolor','b'});
% f = get_masks(fn,cS,[]);
% ds_string = find_entropy(f);
% 
% displayMessage(handles,'Finding entropy of hand masks',{'foregroundcolor','b'});
% f = get_masks(fn,cH,[]);
% ds_hands = find_entropy(f);
% 
% 
% masks.body = ds_body;
% masks.string = ds_string;
% masks.hands = ds_hands;

% ds.masks = masks;

save(fileName,'-struct','ds');
view_entropy(handles,ds,'entropy');

displayMessage(handles,'Done!',{'foregroundcolor','b'});





