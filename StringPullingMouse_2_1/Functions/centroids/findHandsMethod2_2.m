function C = findHandsMethod2_2(handles,M,fn,type,masks,thisFrame,Cs)

global frames;
thisFramem1 = frames{fn-1};
zw = M.zw;
thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
bD_frame = thisFrame - thisFramem1;
sLeft = getRegion(M,fn-1,'Left Hand');
sRight = getRegion(M,fn-1,'Right Hand');
masks.thisFrame = thisFrame;
Cm = Cs{1};
tF = zeros(size(thisFrame(:,:,1)));
[allxs,allys] = meshgrid(1:size(tF,2),1:size(tF,1));
In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);masks.In = In;
startingVal = 1;
cIn = expandOrCompressMask(In,startingVal);
masks.cIn = cIn;
F1 = double(rgb2gray(thisFrame));
[s sp] = findRegions(M,Cs,masks,F1,masks.Ih);
if strcmp(type,'')
    C = sp;
    return;
end

if isempty(sRight)
    pf = 0;
    earsC = Cs{2};
    xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
    xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);
else
    pf = 1;
    xrp = sRight.Centroid(1); yrp = sRight.Centroid(2);
    xlp = sLeft.Centroid(1); ylp = sLeft.Centroid(2);
end

bD_mask = masks.bd;
fD_mask = masks.fd;

bDg = [];%double(rgb2gray(bD));
[sbD sbDo] = findRegions(M,Cs,masks,bDg,bD_mask);
[sfD sfDo] = findRegions(M,Cs,masks,bDg,fD_mask);

[~,ssb] = findDistsAndOverlaps(M,thisFrame,s,sbD);
if sum(ssb>0.1) > 0
    for ii = 1:size(ssb,2)
        thisssb = ssb(:,ii);
        if sum(thisssb>0.1) > 1
            inds = find(thisssb>0.1);
            zM = zeros(size(thisFrame(:,:,1)));
            for jj = 1:length(inds)
                zM(s(inds(jj)).PixelIdxList) = 1;
            end
            zM = bwconvhull(zM);
            ts = regionprops(zM,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
            'Orientation','Extrema');
            s(inds) = [];
            s(length(s)+1) = ts;
        end
    end
end

mo = findIfMoved(sbD,sfD);
co = findIfCoincident(handles,s,sbD);
if co>0 & ~strcmp(mo,'11')
    s = find_centroids_coincident(s(co),[xrp yrp],[xlp ylp]);
    C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
    return;
end

handColors = getParameter(handles,'Hands Color');
handDiffColors = getParameter(handles,'Hands Diff Color');

I = rgb2gray(thisFrame);
regions_f = detectMSERFeatures(I);
regions_f = reduceRegionsBasedOnColor(thisFrame,regions_f,handColors);

I = rgb2gray(bD_frame);
regions_bDf = detectMSERFeatures(I);
regions_bDf = reduceRegionsBasedOnColor(bD_frame,regions_bDf,handDiffColors);

% 
% In = expandOrCompressMask(masks.In,0.95);
% temp = bwboundaries(In);
% InBoundary = temp{1};
% 
% toDiscard = [];
% for ii = 1:regions_f.Count
%     thisLoc = regions_f.Location(ii,:);
%     [in,on] = inpolygon(thisLoc(1),thisLoc(2),InBoundary(:,2),InBoundary(:,1));
%     if in == 0
%         toDiscard = [toDiscard ii];
%     end
% end
% regions_f(toDiscard) = [];
% toDiscard = [];
% for ii = 1:regions_bDf.Count
%     thisLoc = regions_bDf.Location(ii,:);
%     [in,on] = inpolygon(thisLoc(1),thisLoc(2),InBoundary(:,2),InBoundary(:,1));
%     if in == 0
%         toDiscard = [toDiscard ii];
%     end
% end
% regions_bDf(toDiscard) = [];

figure(100);clf;
subplot 121
imagesc(thisFrame);axis equal
hold on;
plot(regions_f)

subplot 122
imagesc(thisFrame);axis equal
hold on;
plot(regions_bDf)

n = 0;

