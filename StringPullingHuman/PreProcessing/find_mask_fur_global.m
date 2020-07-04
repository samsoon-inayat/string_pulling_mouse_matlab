function mask = find_mask_fur_global (handles,frame)
% hsvMean = selectPixelsAndGetHSV(frame(425:600,150:325,:),5)
% % % maskpca = pcaMask(frame);
% % % mask = edge(maskpca,'sobel');
% % % n = 0;
% % % % mask = imgradient(maskpca);
% % % return;
% % % gFrame = double(rgb2gray(frame));
% % % maskg = find_mask_threshold(gFrame,2);
% % % gradFrame = imgradient(rgb2gray(frame));
% % % mask = (~maskg) & find_mask_threshold(gradFrame,2);
% % % % mask = compute_masks_KNN(handles,frame,'background',1);
% % % return;
% % % % % % % % % MMT = str2double(get(handles.edit_mouseMaskTol,'String'));
% % % % % % % % % % EMT = str2double(get(handles.edit_earMaskTol,'String'));
% % % % % % % % % EMT = MMT;
% % % % % % % % % BMT = MMT;
% % % % % % % % % hsvFrame = rgb2hsv(frame);
% % % % % % % % % rgbFrame = double(frame);
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % mouseColors = getParameter(handles,'Fur Color');
% % % % % % % % % mouseColors = getOldColorFormat(mouseColors,0);
% % % % % % % % % earColors = getParameter(handles,'Ears Color');
% % % % % % % % % earColors = getOldColorFormat(earColors,0);
% % % % % % % % % 
% % % % % % % % % backColors = getParameter(handles,'Background Color');
% % % % % % % % % backColors = getOldColorFormat(backColors,0);
% % % % % % % % % 
% % % % % % % % % 
% % % % % % % % % mask = colorDetectHSV(rgb2hsv(hsvFrame),backColors(1,:),BMT*backColors(2,:));
% % % % % % % % % return;


hsvFrame = rgb2hsv(frame);
rgbFrame = double(frame);
frame1 = imresize(frame,0.25);
% if ~get(handles.text_fur,'userdata')
    Im = compute_masks_KNN(handles,frame1,'body',0);%colorDetectHSV(rgb2hsv(hsvFrame),mouseColors(1,:),MMT*mouseColors(2,:));
%     Ie = compute_masks_KNN(handles,frame1,'ears',0);%colorDetectHSV(rgb2hsv(hsvFrame),earColors(1,:),EMT*earColors(2,:));
%     Is = compute_masks_KNN(handles,frame1,'string',0);%colorDetectHSV(rgb2hsv(hsvFrame),earColors(1,:),EMT*earColors(2,:));
%     Ib = compute_masks_KNN(handles,frame1,'background',0);%colorDetectHSV(rgb2hsv(hsvFrame),backColors(1,:),BMT*earColors(2,:));


    
%     masks.ImTitle = 'Fur HSV';
% else
%     Im = colorDetectHSV(rgbFrame,mouseColors(3,:),MMT*mouseColors(4,:));
%     Ie = colorDetectHSV(rgbFrame,earColors(3,:),EMT*earColors(4,:));
% %     masks.ImTitle = 'Fur RGB';
% end
% mask = (~Ib) & (Im | Ie);% | Iel;
mask = Im;%(~Is) & (Im | Ie);% | Iel;
mask = imresize(mask,4,'OutputSize',[size(frame,1) size(frame,2)]);
% Im = imfill(Im);
% Im = bwareaopen(Im,100);
% Im = bwconvhull(Im,'objects',4);

function maskpca1 = pcaMask(thisFrame)
rows = size(thisFrame,1);
columns = size(thisFrame,2);
img = double(reshape(thisFrame,rows*columns,3));
img = cat(2,img,double(reshape(thisFrame,rows*columns,3)));
[coeff,score,latent,tsquared,explained,mu] = pca(img);
transformedImagePixelList = img * coeff;
pca1Image = reshape(transformedImagePixelList(:,1), rows, columns);
maskpca1 = pca1Image;
% maskpca1 = find_mask_threshold(pca1Image,1);
