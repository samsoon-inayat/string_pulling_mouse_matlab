function motion = load_motion(handles)

if ~isfield(handles,'figure1')
    [sfn,efn] = getFrameNums(handles);
    motion = get_file_data(handles.pd_folder,sfn,efn,'motion');
    
    if ~isfield(motion,'speedInCmPerSec')
        speed = abs(motion.vxy);
        scale = getParameter(handles,'Scale');
        frameRate = getParameter(handles,'Frame Rate');
        pixels_per_mm = (1/scale)/motion.image_resize_factor;
        speed = (speed * frameRate /pixels_per_mm)/10 ;
        motion.speedInCmPerSec = speed;
        motion.vxy = (motion.vxy * frameRate /pixels_per_mm)/10 ;
    end
    
    return;
end

md = get_meta_data(handles);
[sfn,efn] = getFrameNums(handles);
motion = get(handles.pushbutton_estimate_motion,'userdata');
if isempty(motion)
    fileName = fullfile(md.processed_data_folder,sprintf('motion_%d_%d.mat',sfn,efn));
    if ~exist(fileName,'file')
        motion = [];
        return;
    else
        displayMessageBlinking(handles,'Please wait ... loading file',{'ForegroundColor','r'},2);
    end
    displayMessage(handles,'Please wait ... loading file');
    motion = load(fileName);
end
if ~isfield(motion,'speedInCmPerSec')
    speed = abs(motion.vxy);
    scale = getParameter(handles,'Scale');
    frameRate = getParameter(handles,'Frame Rate');
    pixels_per_mm = (1/scale)/motion.image_resize_factor;
    speed = (speed * frameRate /pixels_per_mm)/10 ;
    motion.speedInCmPerSec = speed;
    motion.vxy = (motion.vxy * frameRate /pixels_per_mm)/10 ;
    displayMessage(handles,'');
%     motion.vxy = temp.vxy; motion.image_resize_factor = temp.image_resize_factor;
%     motion.thisFrame = temp.thisFrame; motion.shift = temp.shift;motion.frameNums = temp.frameNums;
%     motion.pc = temp.pc;
%     fileName = fullfile(md.processed_data_folder,sprintf('motionA_%d_%d.mat',sfn,efn));
%     displayMessage(handles,'Please wait ... loading file');
%     temp = load(fileName);
%     displayMessage(handles,'');
%     motion.axy = temp.axy; 
%     fileName = fullfile(md.processed_data_folder,sprintf('motionJ_%d_%d.mat',sfn,efn));
%     displayMessage(handles,'Please wait ... loading file');
%     temp = load(fileName);
%     displayMessage(handles,'');
%     motion.jxy = temp.jxy; 
    set(handles.pushbutton_estimate_motion,'userdata',motion);
end

