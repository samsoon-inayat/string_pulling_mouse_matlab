function userProcess1(handles)

[sfn,efn] = getFrameNums(handles);

out = get_all_params(handles,sfn,efn,0);
zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;

n = 0;

global masks;
frames = get_frames(handles);



% frameNums = sfn:efn;
% fmasks = masks.frameMasks;
for ii = 1:length(frameNums)
    fn = frameNums(ii);
    tMask = fmasks(:,fn);
    btMask = de2bi(tMask,7);
    thisMask = reshape(btMask(:,5),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
    figure(100);clf;
    imagesc(thisMask);
    axis equal;
    hold on;
    nC = out.nose.centroid(ii,:);
    plot(nC(1)-zw(1),nC(2)-zw(2),'r*');
    title(ii);
    pause(0.01);
    string_masks(:,:,ii) = thisMask;
    nose_centroids(ii,:) = [nC(1)-zw(1) nC(2)-zw(2)];
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    frame_images{ii} = thisFrame;
end

save('String_Masks_and_Nose_Centroids_2.mat','frame_images','string_masks','nose_centroids');