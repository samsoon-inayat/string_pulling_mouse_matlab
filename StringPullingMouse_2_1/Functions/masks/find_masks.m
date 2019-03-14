function masks = find_masks (handles,frame)
% hsvMean = selectPixelsAndGetHSV(frame(425:600,150:325,:),5)
HMT = str2num(get(handles.edit_handMaskTol,'String'));
EMT = str2num(get(handles.edit_earMaskTol,'String'));
SMT = str2num(get(handles.edit_stringMaskTol,'String'));
MMT = str2num(get(handles.edit_mouseMaskTol,'String'));
hsvFrame = rgb2hsv(frame);
rgbFrame = double(frame);

% v = hsvFrame(:,:,3);
% v = imadjust(v);
% hsvFrame(:,:,3) = v;

stringColors = getParameter(handles,'String Color');
stringColors = getOldColorFormat(stringColors);
handColors = getParameter(handles,'Hands Color');
handColors = getOldColorFormat(handColors);
colorsRGB{1} = stringColors(3,:); colorsRGB{2} = handColors(3,:);
mouseColors = getParameter(handles,'Fur Color');
mouseColors = getOldColorFormat(mouseColors,0);
earColors = getParameter(handles,'Ear Color');
earColors = getOldColorFormat(earColors);

if ~get(handles.text_string,'userdata')
    Is = colorDetectHSV(rgb2hsv(hsvFrame),stringColors(1,:),SMT*stringColors(2,:));
    masks.IsTitle = 'String HSV';
else
    Is = colorDetectHSV(rgbFrame,stringColors(3,:),SMT*stringColors(4,:));
    masks.IsTitle = 'String RGB';
end
Is = imfill(Is);
masks.Is = bwareaopen(Is,100);

if ~get(handles.text_hand,'userdata')
    Ih = colorDetectHSV(rgb2hsv(hsvFrame),handColors(1,:),HMT*handColors(2,:));
    masks.IhTitle = 'Hand HSV';
else
    Ih = colorDetectHSV(rgbFrame,handColors(3,:),HMT*handColors(4,:));
    masks.IhTitle = 'Hand RGB';
end
Ih = imfill(Ih);
masks.Ih = bwareaopen(Ih,100);
% inds = find(temp);
% rTemp = rgbFrame(:,:,1); gTemp = rgbFrame(:,:,2); bTemp = rgbFrame(:,:,3);
% ab = [rTemp(inds) gTemp(inds) bTemp(inds)];
% nColors = 6;
% % repeat the clustering 3 times to avoid local minima
% options = statset('UseParallel',1);
% [cluster_idx, cluster_center] = kmeans(ab,nColors,'Options',options,'distance','sqEuclidean','Replicates',3);
% mTemp = zeros(size(rgbFrame(:,:,1)));
% diff_cc = abs(cluster_center - repmat(colorsRGB{2},nColors,1));
% dists_diff_cc = sqrt(diff_cc(:,1).^2 + diff_cc(:,2).^2 + diff_cc(:,3).^2);
% colorsClus = find(dists_diff_cc == min(dists_diff_cc));
% mTemp(inds(cluster_idx == colorsClus)) = 1;
% masks.Ih = temp;

if ~get(handles.text_ear,'userdata')
    Ie = colorDetectHSV(rgb2hsv(hsvFrame),earColors(1,:),EMT*earColors(2,:));
    masks.IeTitle = 'Ear HSV';
else
    Ie = colorDetectHSV(rgbFrame,earColors(3,:),EMT*earColors(4,:));
    masks.IeTitle = 'Ear RGB';
end
Ie = imfill(Ie);
masks.Ie = bwareaopen(Ie,100);
% masks.Ih = bwconvhull(Ih,'objects',4);

if ~get(handles.text_fur,'userdata')
    Im = colorDetectHSV(rgb2hsv(hsvFrame),mouseColors(1,:),MMT*mouseColors(2,:));
    masks.ImTitle = 'Fur HSV';
else
    Im = colorDetectHSV(rgbFrame,mouseColors(3,:),MMT*mouseColors(4,:));
    masks.ImTitle = 'Fur RGB';
end
Im = imfill(Im);
Im = bwareaopen(Im,100);
masks.Im = bwconvhull(Im,'objects',4);
return;
sm = regionprops(Im,'centroid','area','PixelIdxList');
for ii = 1:length(sm)
    areasM(ii) = sm(ii).Area;
end
areasM = areasM * getParameter(handles,'Scale');
inds = find(areasM>350);
maskTemp = zeros(size(Im));
for ii = 1:length(inds)
    maskTemp(sm(inds(ii)).PixelIdxList) = 1;
end
masks.Im = maskTemp;
% masks.Im = bwconvhull(maskTemp,'union');

% nrows = size(rgbFrame,1);
% ncols = size(rgbFrame,2);
% ab = reshape(rgbFrame,nrows*ncols,3);
% nColors = 6;
% % repeat the clustering 3 times to avoid local minima
% options = statset('UseParallel',0);
% [cluster_idx, cluster_center] = kmeans(ab,nColors,'Options',options,'distance','sqEuclidean','Replicates',3);
% % [cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);
% pixel_labels = reshape(cluster_idx,nrows,ncols);
% for ii = 1:length(colorsRGB)
%     diff_cc = abs(cluster_center - repmat(colorsRGB{ii},nColors,1));
%     dists_diff_cc = sqrt(diff_cc(:,1).^2 + diff_cc(:,2).^2 + diff_cc(:,3).^2);
%     colorsClus(ii) = find(dists_diff_cc == min(dists_diff_cc));
%     mask{ii} = zeros(size(pixel_labels));
%     mask{ii}(pixel_labels == colorsClus(ii)) = 1;
% end
% 
% % masks.Is = mask{1}&masks.Is;
% % masks.Ih = mask{2}&masks.Ih;
% % n=0;
% tempFrame = zeros(nrows,ncols);
% vals = linspace(0.2,1   ,nColors);
% for ii = 1:nColors
%     tempFrame(cluster_idx == ii) = vals(ii);
% end
% figure(10);clf;imagesc(tempFrame);axis equal;colorbar;