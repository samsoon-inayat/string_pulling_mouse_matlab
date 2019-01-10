function d = getData(file_name,file_path)
global frames;
global v;
global frameNumber;
global frameTimes;
v = VideoReader(fullfile(file_path,file_name));
d.file_path = file_path;
d.file_name = file_name;
number_of_frames = (ceil(v.FrameRate*v.Duration)-10);
frames = cell(1,number_of_frames);
bdFrames = cell(1,number_of_frames);
fdFrames = cell(1,number_of_frames);
numFrames = 1;
frameNumber = 0;
for ii = 1:20
    frameNumber = frameNumber + 1;
    frames{frameNumber} = readFrame(v);
    frameTimes(frameNumber) = v.CurrentTime;
end
d.number_of_frames = number_of_frames;
dt = frameTimes(2)-frameTimes(1);
% d.frames = frames;
temp = frameTimes(1):dt:v.Duration;
d.times = temp;%(1:d.number_of_frames);
d.frameSize = [size(frames{1},1) size(frames{1},2)];
