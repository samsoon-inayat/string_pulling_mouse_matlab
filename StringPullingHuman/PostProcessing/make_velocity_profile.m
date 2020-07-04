function make_velocity_profile(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end

[sfn,efn] = getFrameNums(handles);

% out = get_all_params(handles,sfn,efn,0);
zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;

frame_width = zw(3)-zw(1)+1;
frame_height = zw(4)-zw(2)+1;

frames = get_frames(handles);

motion = load_motion(handles);
if isempty(motion)
    displayMessageBlinking(handles,'Non-existent motion file',{'ForegroundColor','r'},2);
    return;
end
fn = getSelectedFrame(handles);
[present,rinds,pinds] = checkIfDataPresent(handles,fn,'right hand');
[R,P,~] = get_R_P_RDLC(handles);
Ps = P(pinds,:);

[r,c] = ind2sub(size(frames{1}(:,:,1)),Ps(:,3));

region = zeros(size(frames{1}(:,:,1)));
region(Ps(:,3)) = 1;
region = region(zw(2):zw(4),zw(1):zw(3));
region = imresize(region,1/motion.image_resize_factor);
region(region>0) = 1;
[r,c] = find(region);
vp = Velocity_Profile(motion.vxy,1,50,1,c(1:10:end),r(1:10:end));
hf = figure(100);clf;
add_window_handle(handles,hf);
thisFrame = frames{fn};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
thisFrame = imresize(thisFrame,1/motion.image_resize_factor);

figure(100);clf
str = streamline(vp.str);
hold on;
imagesc(thisFrame);
axis equal;hold on;
set(gca,'YDir','Reverse');
set(str,'Color','w');
n = 0;
% 
% 
% handles.md = get_meta_data(handles);
% SSParamsPathName = fullfile(handles.md.processed_data_folder,'SourceSinkAnalysis');
% SaveFullFileName = fullfile(SSParamsPathName,'\SourceSinkSpiralResults.mat');
% 
% try
%     SoSi = load(SaveFullFileName);
% catch
%     mask = ones(size(motion.vxy,1),size(motion.vxy,2));
%     calc_save_SourceSink(handles,motion.vxy,mask);
% end
% SoSi = load(SaveFullFileName);
% n = 0;