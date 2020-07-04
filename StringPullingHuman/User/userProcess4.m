function userProcess4(handles)

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

frameNums = sfn:efn;
for ii = 1:length(frameNums)
    ii
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    if ii == 1
        rows = size(thisFrame,1);
        columns = size(thisFrame,2);
        img = double(reshape(thisFrame,rows*columns,3));
    else
        img = cat(2,img,double(reshape(thisFrame,rows*columns,3)));
    end
end
n = 0;

[coeff,score,latent,tsquared,explained,mu] = pca(img);
transformedImagePixelList = img * coeff;


for ii = 1:3:size(coeff,1)
    % transformedImagePixelList is also an N by 3 matrix of values.
    % Column 1 is the values of principal component #1, column 2 is the PC2, and column 3 is PC3.
    % Extract each column and reshape back into a rectangular image the same size as the original image.
    pca1Image = reshape(transformedImagePixelList(:,ii), rows, columns);
    pca2Image = reshape(transformedImagePixelList(:,ii+1), rows, columns);
    pca3Image = reshape(transformedImagePixelList(:,ii+2), rows, columns);
    rgbImg = cat(3,pca1Image,pca2Image,pca3Image);
    figure(100);clf;
    imagesc(thisFrame);axis equal;
    
    figure(101);clf;
    subplot 131;imagesc(pca1Image);axis equal;
    subplot 132;imagesc(pca2Image);axis equal;
    subplot 133;imagesc(pca3Image);axis equal;
    pause(0.1);
    n = 0;
end
% 

maskpca1 = find_mask_threshold(pca1Image,1);
figure(101);clf;imagesc(imoverlay(thisFrame,maskpca1));axis equal