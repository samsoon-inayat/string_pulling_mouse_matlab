function detectFeatures(handles,sfn,efn)

handColors = getParameter(handles,'Hands Color');
handDiffColors = getParameter(handles,'Hands Diff Color');


M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = handles.md.resultsMF.zoomWindow;
M.scale = handles.md.resultsMF.scale;
M.frameSize = handles.d.frameSize;

global frames;
zw = handles.md.resultsMF.zoomWindow;
frameNums = sfn:efn;
for ii = 1:length(frameNums)
    tic;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    tMasks = get_masks_KNN(handles,fn);
    Cs{1} = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
    Cs{2} = find_centroids(M,fn,'ears',tMasks,thisFrame,Cs);
    Cs{2} = findBoundary(Cs{2},size(thisFrame));
    thisRE = R(fn,2:6);
    C = getSubjectFit([thisRE(1)-zw(1) thisRE(2)-zw(2)],thisRE(3),thisRE(4),thisRE(5));
    
    mask = compute_masks_KNN_hands(handles,thisFrame);
    thisFramem1 = frames{fn-1};
    thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
    bD_frame = thisFrame - thisFramem1;
    I = (rgb2gray(thisFrame));
    regions_f = detectMSERFeatures(I,'ThresholdDelta',4);
    
    
    
%     I = rgb2gray(bD_frame);
%     regions_bDf = detectMSERFeatures(I,'ThresholdDelta',4);
% %     regions_f = reduceRegionsBasedOnColor(thisFrame,regions_f,handColors);
% %     regions_bDf = reduceRegionsBasedOnColor(bD_frame,regions_bDf,handDiffColors);
    figure(100);clf;
    subplot 121
    imshow(thisFrame); hold on;
    plot(regions_f);
    plot(C.Ellipse_xs,C.Ellipse_ys);
    subplot 122
    imshow(thisFrame); hold on;
    plot(regions_bDf);
    plot(C.Ellipse_xs,C.Ellipse_ys);
    pause(0.1);
end


