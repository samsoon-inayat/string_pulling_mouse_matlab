function [success,data] = load_data(handles,varargin)
% disp('Please wait ... I am loading data');

if isfield(handles,'figure1')
    displayMessage(handles,'Getting file info');

    [file_name,file_path] = getFileInfo;
    if ~ischar(file_name)
        displayMessageBlinking(handles,'No file selected',{'ForegroundColor','r'},3);
        displayMessage(handles,sprintf('Welcome to String Pulling Behavioral Analytics'),{'FontSize',12,'ForegroundColor','b'});
        success = 0; data = [];
        return;
    end
    fileName = fullfile(file_path,file_name);
    if ~exist(fileName,'file')
        displayMessageBlinking(handles,'Non-existent File',{'ForegroundColor','r'},3);
        displayMessage(handles,sprintf('Welcome to String Pulling Behavioral Analytics'),{'FontSize',12,'ForegroundColor','b'});
        success = 0; data = [];
        return;
    end

    displayMessage(handles,'Please wait ... I am loading data');
    save('file_path.mat','file_path');
else
    file_name = handles.file_name; file_path = handles.file_path;
end
try
    if nargin == 1
        [success,frames,frame_times,video_object] = load_file(handles,file_name,file_path);
    else
        [success,frames,frame_times,video_object] = load_file_frames(handles,file_name,file_path,varargin{1});
    end
    setParameter(handles,'Frame Rate',video_object.FrameRate);
catch
    success = 0; data = [];
end
if isfield(handles,'figure1')
    if ~success
        displayMessageBlinking(handles,'Loading stopped or loading error !!!',{'ForegroundColor','r'},3);
        displayMessage(handles,sprintf('Welcome to String Pulling Behavioral Analytics'),{'FontSize',12,'ForegroundColor','b'});
        data = [];
        return;
    end
end
data.file_name  = file_name;
data.file_path = file_path;
data.frames = frames;
data.frame_times  = frame_times;
if isfield(handles,'figure1')
    data.video_object = video_object;
end
data.number_of_frames = length(frames);
data.frame_size = size(frames{1});


function [success,frames,frame_times,video_object] = load_file(handles,file_name,file_path)
if isfield(handles,'figure1')
    set(handles.pushbutton_fileOpen,'userdata',0,'String','Stop Loading');
end
success = 1;
video_object = VideoReader(fullfile(file_path,file_name));
number_of_frames = (ceil(video_object.FrameRate*video_object.Duration)-1);
frameNumber = 1;
while hasFrame(video_object)
    frames{frameNumber} = readFrame(video_object);
    frame_times(frameNumber) = video_object.CurrentTime;
    frameNumber = frameNumber + 1;
    str = sprintf('File: %s ... loading frame %d/%d',file_name,frameNumber,number_of_frames);
    displayMessage(handles,str);
    if isfield(handles,'figure1')
        if get(handles.pushbutton_fileOpen,'userdata')
            success = 0;
    %         displayMessageBlinking(handles,'Loading Stopped',{'ForegroundColor','r'},2);
    %         displayMessage(handles,sprintf('Welcome to String Pulling Behavioral Analytics'),{'ForegroundColor','b','FontSize',12});
            break;
        end
    end
%     if frameNumber == number_of_frames
%         break;
%     end
end
if ~success
    frames = [];
    frame_times = [];
    return;
end
displayMessage(handles,'Loading complete !!!');


function [success,frames,frame_times,video_object] = load_file_frames(handles,file_name,file_path,frameNums)

success = 1;
video_object = VideoReader(fullfile(file_path,file_name));
number_of_frames = (ceil(video_object.FrameRate*video_object.Duration)-1);
frameNumber = 1;
for ii = 1:5
    t_frames{ii} = readFrame(video_object);
    t_frame_times(ii) = video_object.CurrentTime;
end
dt = t_frame_times(2)-t_frame_times(1);
startTime = dt * frameNums(1);
endTime = (dt * frameNums(end));
video_object.CurrentTime = startTime;
while video_object.CurrentTime <= endTime
    try
        frames{frameNumber} = readFrame(video_object);
    catch
        break;
    end
    frame_times(frameNumber) = video_object.CurrentTime;
    frameNumber = frameNumber + 1;
    str = sprintf('File: %s ... loading frame %d/%d',file_name,(frameNumber),length(frameNums));
    displayMessage(handles,str);
end
if ~success
    frames = [];
    frame_times = [];
    return;
end
displayMessage(handles,'Loading complete !!!');


% azw = getParameter(handles,'Auto Zoom Window');
% if ~isempty(azw)
% %     epochs = getParameter(handles,'Epochs');
%     for ii = 1:size(cmasks,2)
%         str = sprintf('Uncompressing masks - %s ... frame %d/%d',handles.d.file_name,ii,size(cmasks,2));
%         displayMessage(handles,str);
%         tMask = masks.frameMasks(:,ii);
%         btMask = de2bi(tMask,8);
%         uc_masks(:,:,ii) = btMask;
% %         for jj = 1:8
% %             thisMask = reshape(btMask(:,jj),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
% %             uc_masks(jj).masks(:,:,ii) = thisMask;
% %         end
%         tMask = cmasks(:,ii);
%         btMask = de2bi(tMask,8);
%         uc_cmasks(:,:,ii) = btMask;
% %         for jj = 1:8
% %             thisMask = reshape(btMask(:,jj),azw(4)-azw(2)+1,azw(3)-azw(1)+1);
% %             uc_cmasks(jj).masks(:,:,ii) = thisMask;
% %         end
%         if get(handles.pushbutton_fileOpen,'userdata')
%             success = 0;
%             displayMessageBlinking(handles,'Loading Stopped',{'ForegroundColor','r'},2);
%             displayMessage(handles,sprintf('Welcome to String Pulling Behavioral Analytics'),{'ForegroundColor','b','FontSize',12});
%             break;
%         end
%     end
% end
% if ~success
%     frames = [];
%     uc_masks = [];
%     uc_cmasks = [];
%     return;
% end
% handles.d.number_of_frames = frameNumber;


