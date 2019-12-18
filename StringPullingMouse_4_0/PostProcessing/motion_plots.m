function motion_plots(handles)

[sfn,efn] = getFrameNums(handles);
if isempty(sfn)
    return;
end
if sfn == 1
    sfn = 2;
end
md = get_meta_data(handles);
motion = load_motion(handles);
if isempty(motion)
    displayMessageBlinking(handles,'Non-existent motion file',{'ForegroundColor','r'},2);
    return;
end
shift = motion.shift;
frameNums = motion.frameNums;
hf = figure(1000);clf;
add_window_handle(handles,hf);
subplot 311
plot(frameNums,(shift(:,1)));
ylabel('X Shift (pixels)');

subplot 312
plot(frameNums,(shift(:,2)));
ylabel('Y Shift (pixels)');

subplot 313
plot(frameNums,sqrt(sum(shift.^2,2)));
ylabel('Abs Shift (pixels)');
xlabel('Frames');
image_resize_factor = motion.image_resize_factor;
thisFrame = motion.thisFrame;
hf = figure(10);clf;
add_window_handle(handles,hf);
uv = abs(motion.vxy);
% for ii = 1:size(temp.vxy,3)
%     mask = get_mask(handles,temp.frameNums(ii)-1,'string');
%     masks(:,:,1)= imresize(mask,(1/temp.image_resize_factor));
% end
% uv = uv.*(~masks);
mask = ones(size(uv,1),size(uv,2));
% calc_save_SourceSink(handles,motion.vxy,mask);
nrows = size(uv,1);
ncols = size(uv,2);
nFrames = size(uv,3);
% fs = reshape(uv,nrows*ncols,nFrames);
% [coeff,score,latent,tsquared,explained,mu] = pca(fs);close(hf);
% pcs = load_pcs(handles)
% viewPCs(handles,pcs,'');


miuv = min(uv(:));
mauv = max(uv(:));
for ii = 1:size(uv,3)
%     vx = real(temp.vxy(:,:,ii));
%     vy = imag(temp.vxy(:,:,ii));
    if motion.image_resize_factor ~= 1
%         vx = imresize(vx,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
%         vy = imresize(vy,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
        tuv = uv(:,:,ii);
        tuv = imresize(tuv,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
    end
    try
        figure(hf);clf
        fn = motion.frameNums(ii);
        plot_optical_flow(handles,hf,fn,thisFrame,[],tuv,5,1,[miuv mauv])
        title(motion.frameNums(ii));
        pause(0.1);
    catch
        return;
    end
end
