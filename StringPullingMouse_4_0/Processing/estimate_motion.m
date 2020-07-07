function estimate_motion(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end

% string_thickness = getParameter(handles,'String Thickness in Pixels');
md = get_meta_data(handles);

[sfn,efn] = getFrameNums(handles);
frameNums = (sfn+1):efn;
if isempty(sfn) || length(frameNums) < 2
    displayMessageBlinking(handles,'Select frames ... frame list empty',{'ForegroundColor','r'},3);
    return;
end

fileName = fullfile(md.processed_data_folder,sprintf('motion_%d_%d.mat',sfn,efn));
if isfield(handles,'figure1')
    if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
        displayMessageBlinking(handles,'File already exists ... select overwrite to calculate again',{'ForegroundColor','r'},3);
        return;
    end
else
    if exist(fileName,'file') & handles.ow == 0
        return;
    end
end

% out = get_all_params(handles,sfn,efn,0);
zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;

frames = get_frames(handles);

if isfield(handles,'figure1')
    if get(handles.checkbox_Reduce_Image_Size,'Value')
        try
            image_resize_factor = str2double(get(handles.edit_reduce_image_factor,'String'));
        catch
            displayMessageBlinking(handles,'Enter a number for image resize factor',{'ForegroundColor','r'},2);
            return;
        end
    end
else
    image_resize_factor = evalin('base','image_resize_factor');
end
% ratio = 0.5;alpha = 0.01;minWidth = string_thickness;nOuterFPIterations = 15;nInnerFPIterations = 3;nSORIterations = 30;

prompt = {'alpha','ratio','minWidth','nOuterFPIterations','nInnerFPIterations','nSORIterations'};
dlgtitle = 'Enter CLG parameters';
dims = [1 35];
definput = {'0.01','0.5',sprintf('%d',20),'7','1','30'};
if isfield(handles,'figure1')
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    if isempty(answer)
        return;
    end
else
    answer = definput;
end

for ii = 1:length(prompt)
    cmdTxt = sprintf('%s_1 = %.2f;',prompt{ii},str2double(answer{ii}));
    eval(cmdTxt);
end

para_CLG = [alpha_1,ratio_1,minWidth_1,nOuterFPIterations_1,nInnerFPIterations_1,nSORIterations_1];

hf = figure(10);clf;
add_window_handle(handles,hf);
    startTime = tic;
    for ii = 1:length(frameNums)
        if isfield(handles,'figure1')
            if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
                axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
                return;
            end
        end
        fn = frameNums(ii);
        thisFrame = frames{fn};
        thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
        thisFramem1 = frames{fn-1};
        thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
        tic
        shift(ii,:) = POCShift(rgb2gray(thisFramem1),rgb2gray(thisFrame));
        if isfield(handles,'figure1')
            if get(handles.checkbox_Reduce_Image_Size,'Value')
                frame1 = imresize(thisFramem1,(1/image_resize_factor)); frame2 = imresize(thisFrame,(1/image_resize_factor));
            else
                frame1 = thisFramem1; frame2 = thisFrame;
            end
        else
            frame1 = imresize(thisFramem1,(1/image_resize_factor)); frame2 = imresize(thisFrame,(1/image_resize_factor));
        end
        [vx,vy,~] = Coarse2FineTwoFrames(frame1,frame2,para_CLG);
    %     if get(handles.checkbox_Reduce_Image_Size,'Value')
    %         vx = imresize(vx,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
    %         vy = imresize(vy,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
    %     end
    %     figure(hf);clf;subplot 131;imagesc(frame1); axis equal;subplot 132;imagesc(frame2); axis equal;subplot 133;imagesc(warpI2);axis equal
        timeRemaining = getTimeRemaining(length(frameNums),ii);
        if ii > 1 && ii < length(frameNums)
            displayMessage(handles,sprintf('Estimating %s ... Processing frame %d - %d/%d ... time remaining %s','motion',fn+1,ii+1,length(frameNums),timeRemaining),{'foregroundcolor','b'});
        end
        if isfield(handles,'figure1')
            if get(handles.checkbox_updateDisplay,'Value')
                figure(hf);
                plot_optical_flow(handles,hf,fn,frame1,frame2,vx+i*vy,5,1,[])
                title(fn);
                pause(0.05);
            end
        else
            figure(hf);
            plot_optical_flow(handles,hf,fn,frame1,frame2,vx+i*vy,5,1,[])
            title(fn);
            pause(0.05);
        end
        vxy(:,:,ii) = vx + i*vy;
    end
    displayMessage(handles,'Saving file ... it might take a while');
    fileName = fullfile(md.processed_data_folder,sprintf('motion_%d_%d.mat',sfn,efn));
    save(fileName,'frameNums','shift','vxy','image_resize_factor','thisFrame','para_CLG');
 
    motion.vxy = vxy; %motion.axy = axy; motion.jxy = jxy;
    motion.image_resize_factor = image_resize_factor;
    motion.thisFrame = thisFrame; motion.shift = shift;motion.frameNums = frameNums;
%     motion.pc = pc;
    if isfield(handles,'figure1')
        set(handles.pushbutton_estimate_motion,'userdata',motion);
    end
    endTime = toc(startTime);
    displayMessage(handles,sprintf('Done processing frames from %d to %d - Total Time Taken = %.3f s',sfn,sfn+ii-1,endTime));
    close(hf);

%     uv = abs(vxy);
%     pc.nrows = size(uv,1);
%     pc.ncols = size(uv,2);
%     pc.nFrames = size(uv,3);
%     fs = reshape(uv,pc.nrows*pc.ncols,pc.nFrames);
%     [pc.coeff,pc.score,pc.latent,pc.tsquared,pc.explained,pc.mu] = pca(fs);
%     fileNamePC = fullfile(md.processed_data_folder,sprintf('PCs_motion_%d_%d.mat',sfn,efn));
%     save(fileNamePC,'-struct','pc');
%     displayMessage(handles,'Estimating second order motion ... please wait');
%     axy = runCLG(handles,abs(vxy));
%     if isempty(axy)
%         return;
%     end
%     fileName = fullfile(md.processed_data_folder,sprintf('motionA_%d_%d.mat',sfn,efn));
%     save(fileName,'frameNums','shift','axy','image_resize_factor','thisFrame');
%     
%     displayMessage(handles,'Estimating third order motion ... please wait');
%     jxy = runCLG(handles,abs(axy));
%     if isempty(jxy)
%         return;
%     end
%     fileName = fullfile(md.processed_data_folder,sprintf('motionJ_%d_%d.mat',sfn,efn));
%     save(fileName,'frameNums','shift','jxy','image_resize_factor','thisFrame');



% frame_width = zw(3)-zw(1)+1;
% frame_height = zw(4)-zw(2)+1;
% 
% divisor = 32;
% 
% nw = floor(frame_width/divisor);
% nh = floor(frame_height/divisor);
% 
% ew = floor((frame_width - nw * divisor)/2);
% eh = floor((frame_height - nh * divisor)/2);
% 
% sws = ew:divisor:frame_width;
% csws = sws + divisor/2;
% csws = csws(1:2:end);
% ews = (ew+15):divisor:frame_width;
% cews = ews + divisor/2;
% cews = cews(2:2:end);
% shs = eh:divisor:frame_height;
% cshs = shs + divisor/2;
% cshs = cshs(1:2:end);
% ehs = (eh+15):divisor:frame_height;
% cehs = ehs + divisor/2;
% cehs = cehs(2:2:end);
% 
% mtemp = min([length(csws) length(cews)]);
% csws = csws(1:mtemp); cews = cews(1:mtemp);
% mtemp = min([length(cshs) length(cehs)]);
% cshs = cshs(1:mtemp); cehs = cehs(1:mtemp);
% 
% 
% add_window_handle(handles,hf);
% thisFrame = frames{sfn};
% thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
% imagesc(thisFrame);
% axis equal;
% hold on;
% for cc = 1:length(csws)
%     for rr = 1:length(cshs)
%         plot([csws(cc) csws(cc)], [cshs(rr) cehs(rr)],'r');
%         plot([cews(cc) cews(cc)], [cshs(rr) cehs(rr)],'r');
%         plot([csws(cc) cews(cc)], [cshs(rr) cshs(rr)],'r');
%         plot([csws(cc) cews(cc)], [cehs(rr) cehs(rr)],'r');
%     end
% end
% 
% 
% 
% for ii = 1:length(frameNums)
%     fn = frameNums(ii);
%     thisFrame = frames{fn};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     thisFramem1 = frames{fn-1};
%     thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
%     figure(hf);
%     subplot 121
%     imagesc(thisFrame);
%     axis equal;
%     subplot 122
%     imagesc(thisFramem1);
%     axis equal;
%     for cc = 1:length(csws)
%         for rr = 1:length(cshs)
%             if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
%                 return;
%             end
%             subFrame1 = thisFrame(cshs(rr):cehs(rr),csws(cc):cews(cc),:);
%             subFrame2 = thisFramem1(cshs(rr):cehs(rr),csws(cc):cews(cc),:);
%             shift = POCShift(rgb2gray(subFrame1),rgb2gray(subFrame2))
%             figure(hf);clf
%             subplot 121
%             imagesc(subFrame1);
%             axis equal;
%             subplot 122
%             imagesc(subFrame2);
%             axis equal;
%             title(shift)
%             pause(0.1);
%         end
%     end
%     if ii > 1 && ii < length(frameNums)
%         displayMessage(handles,sprintf('Estimating %s ... Processing frame %d - %d/%d ... time remaining %s','motion',fn+1,ii+1,length(frameNums),timeRemaining),{'foregroundcolor','b'});
%     end
% end
% n = 0;


% function uv = get_optical_flow(frame1,frame2)
