function detectFeatures(handles,sfn,efn)

handColors = getParameter(handles,'Hands Color');
handDiffColors = getParameter(handles,'Hands Diff Color');


M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;

global frames;
zw = M.zw;
frameNums = sfn:efn;

for ii = 1:length(frameNums)
    tic;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    I1 = (rgb2gray(thisFrame));
    [regions_f,rrs] = detectMSERFeatures(I1);
    mask_r = makeMaskFromRegions(rrs);
    Im = imoverlay(thisFrame,mask_r);
    figure(10);clf;imagesc(Im);axis equal;
    pause(0.3);
end

for ii = 1:length(frameNums)
    tic;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    I1 = (rgb2gray(thisFrame));
%     points1 = detectHarrisFeatures(I1);
    points1 = detectSURFFeatures(I1);
    [features{ii},valid_points{ii}] = extractFeatures(I1,points1);
    ii
end
n = 0;
for ii = 2:length(frameNums)
    fn = frameNums(ii-1);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    thisFramem1 = thisFrame;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    ftf = imfuse(thisFramem1,thisFrame);
    features1 = features{ii-1};
    features2 = features{ii};
    valid_points1 = valid_points{ii-1};
    valid_points2 = valid_points{ii};
    indexPairs{ii-1} = matchFeatures(features1,features2);
    indexPairs1 = indexPairs{ii-1};
    matchedPoints1 = valid_points1(indexPairs1(:,1),:);
    matchedPoints2 = valid_points2(indexPairs1(:,2),:);
    figure(100);clf;imagesc(ftf);axis equal;
    hold on;
    plot(matchedPoints1);
    plot(matchedPoints2);
    pause(0.1);
end
ind1 = indexPairs{1};
for ii = 2:length(frameNums)
    ind2 = indexPairs{ii};
    [~,iis1,iis2] = intersect(ind1(:,2),ind2(:,1));
    if isempty(iis1)
        ii
        break;
    end
    ind1 = [ind1(iis1,1) ind2(iis2,2)];
end

n = 0;

% for ii = 1:length(frameNums)
%     tic;
%     fn = frameNums(ii);
%     thisFrame = frames{fn};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     tMasks = get_masks_KNN(handles,fn);
%     Cs{1} = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
%     Cs{2} = find_centroids(M,fn,'ears',tMasks,thisFrame,Cs);
%     Cs{2} = findBoundary(Cs{2},size(thisFrame));
%     thisRE = R(fn,2:6);
%     C = getSubjectFit([thisRE(1)-zw(1) thisRE(2)-zw(2)],thisRE(3),thisRE(4),thisRE(5));
%     
%     mask = compute_masks_KNN_hands(handles,thisFrame);
%     thisFramem1 = frames{fn-1};
%     thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
%     bD_frame = thisFrame - thisFramem1;
%     I = (rgb2gray(thisFrame));
%     regions_f = detectMSERFeatures(I,'ThresholdDelta',4);
%     
%     
%     
% %     I = rgb2gray(bD_frame);
% %     regions_bDf = detectMSERFeatures(I,'ThresholdDelta',4);
% % %     regions_f = reduceRegionsBasedOnColor(thisFrame,regions_f,handColors);
% % %     regions_bDf = reduceRegionsBasedOnColor(bD_frame,regions_bDf,handDiffColors);
%     figure(100);clf;
%     subplot 121
%     imshow(thisFrame); hold on;
%     plot(regions_f);
%     plot(C.Ellipse_xs,C.Ellipse_ys);
%     subplot 122
%     imshow(thisFrame); hold on;
%     plot(regions_bDf);
%     plot(C.Ellipse_xs,C.Ellipse_ys);
%     pause(0.1);
% end
% 
% 
