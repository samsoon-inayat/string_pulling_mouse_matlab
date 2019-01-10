function C = findHandsMethod1(M,fn,type,masks,thisFrame,thisFramem1,Cs,Cshp)
if strcmp(Cshp(1).Hand,'Left Hand')
    sp_l = Cshp(1);
    sp_r = Cshp(2);
else
    sp_l = Cshp(2);
    sp_r = Cshp(1);
end
sp_l = rmfield(sp_l,'Hand');
sp_r = rmfield(sp_r,'Hand');
masks.thisFrame = thisFrame;
Cm = Cs{1};
tF = zeros(size(thisFrame(:,:,1)));
[allxs,allys] = meshgrid(1:size(tF,2),1:size(tF,1));
In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);
startingVal = 0.95;
cIn = expandOrCompressMask(In,startingVal);

F1 = double(rgb2gray(thisFrame));
F2 = double(rgb2gray(thisFramem1));
dF = F1-F2;
[GF1,GdFdir] = imgradient(F1);
inds = find(cIn);
mdF = mean(dF(inds)); sdF = std(dF(inds));
mGdF = mean(GF1(inds)); sGdF = std(GF1(inds));
uT = mdF + 5*sdF;lT = mdF - 5*sdF;
GuT = mGdF + 3*sGdF;
dFpre_mask = zeros(size(dF));
dFpre_mask(dF<lT) = 1; dFpre_mask(dF>lT) = 0;

dFnew_mask = zeros(size(dF));
dFnew_mask(dF<uT) = 0; dFnew_mask(dF>uT) = 1;

GdFnew_mask = zeros(size(dF));
GdFnew_mask(GF1<GuT) = 0; GdFnew_mask(GF1>GuT) = 1;

scale = M.scale;
[xlp ylp] = getxyFromR(M,fn-1,'Left Hand');
[xrp yrp] = getxyFromR(M,fn-1,'Right Hand');
xlp = xlp - M.zw(1); xrp = xrp - M.zw(1);
ylp = ylp - M.zw(2); yrp = yrp - M.zw(2);


leftHandC = [xlp ylp];
rightHandC = [xrp yrp];

if isempty(xlp) || isempty(xrp)
    C = [];
    return;
end
s = findRegions(M,Cs,masks,F1,masks.Ih);
snew = findRegions(M,Cs,masks,dF,dFnew_mask);
spre = findRegions(M,Cs,masks,dF,dFpre_mask);
sGnew = findRegions(M,Cs,masks,dF,GdFnew_mask);

[d_s_snew,o_s_snew] = findDistsAndOverlaps(M,thisFrame,s,snew);
[d_s_sGnew,o_s_sGnew] = findDistsAndOverlaps(M,thisFrame,s,sGnew);
[d_new_r,o_new_r] = findDistsAndOverlaps(M,thisFrame,snew,sp_r); % distances between previous right hand and newer regions found from diff frame
[d_new_l,o_new_l] = findDistsAndOverlaps(M,thisFrame,snew,sp_l); % distances between previous left hand and newer regions found from diff frame

% [d_s_spre,o_s_spre] = findDistsAndOverlaps(M,thisFrame,s,spre);
[d_pre_r,o_pre_r] = findDistsAndOverlaps(M,thisFrame,spre,sp_r); % distances between previous right hand and older regions found from diff frame
[d_pre_l,o_pre_l] = findDistsAndOverlaps(M,thisFrame,spre,sp_l); % distances between previous left hand and older regions found from diff frame

[d_s_r,o_s_r] = findDistsAndOverlaps(M,thisFrame,s,sp_r);
[d_s_l,o_s_l] = findDistsAndOverlaps(M,thisFrame,s,sp_l);



if isempty(snew) & ~isempty(spre) % highly likely that there is little movement
    % condition where the previous right and left are very close to one big
    % area ... when hands are close both touching string
    ind1 = find(o_s_l == max(o_s_l));
    ind2 = find(o_s_r == max(o_s_r));
    if ind1 == ind2
        ss = s(ind1);
    else
        if d_s_l(ind1) < d_s_r(ind2)
            ss = s(ind2);
        else
            ss = s(ind1);
        end
    end
    [ret C] = evaluateRegionsForOneTwo(M,Cs,masks,ss);
    if ret<0
        return;
    end
end

if ~isempty(snew) & isempty(spre) % highly likely that there is little movement
    ind1 = find(d_s_l == min(d_s_l));
    ind2 = find(d_s_r == min(d_s_r));
    if ind1 == ind2
        ss = s(ind1);
        [ret C] = evaluateRegionsForOneTwo(M,Cs,masks,ss);
        if ret<0
            return;
        end
    end
    n = 0;
end

if isempty(snew) & isempty(spre) % highly likely that there is little movement
    ind = find(d_s_r == min(d_s_r));
    ss = s(ind);
    [ret C] = evaluateRegionsForOneTwo(M,Cs,masks,ss);
    if ret<0
        return;
    end
end

if length(s) < 3
    [ret C] = evaluateRegionsForOneTwo(M,Cs,masks,s);
    if ret<0
        return;
    end
end

if length(spre) == 1 & length(snew) == 1
    [rrs ccs] = find(o_s_snew == max(o_s_snew(:)));
    ss(1) = s(rrs);
    [ret C] = evaluateRegionsForOneTwo(M,Cs,masks,ss);
    if ret<0
        return;
    end
end

if length(snew) > 1
    [rrs ccs] = find(o_s_snew == max(o_s_snew(:)));
    ss(1) = s(rrs);
    s(rrs) = [];
    
end



min_pre_l = min(d_pre_l); min_pre_r = min(d_pre_r);
% mingl = min(d_new_l); mingr = min(d_new_r);
if min_pre_l < min_pre_r% & mingl < mingr
    handMovedSig = 'left';
else
    handMovedSig = 'right';
end

if strcmp(handMovedSig,'left')
    temp.Centroid = [xrp yrp];
    d_s = findDistsAndOverlaps(M,thisFrame,s,temp);
    ind = find(d_s == min(d_s));
    C(1) = s(ind);
    s(ind) = [];
    d_s_r = findDistsAndOverlaps(M,thisFrame,s,snew);
    [row col] = find(d_s_r == min(d_s_r(:)));
    ind = min(row);
    C(2) = s(ind);
    C(1).Hand = 'Right Hand';
    C(2).Hand = 'Left Hand';
end

if strcmp(handMovedSig,'right')
    temp.Centroid = [xlp ylp];
    d_s = findDistsAndOverlaps(M,thisFrame,s,temp);
    ind = find(d_s == min(d_s));
    C(1) = s(ind);
    s(ind) = [];
    d_s_r = findDistsAndOverlaps(M,thisFrame,s,snew);
    [row col] = find(d_s_r == min(d_s_r(:)));
    ind = min(row);
    C(2) = s(ind);
    C(1).Hand = 'Left Hand';
    C(2).Hand = 'Right Hand';
end

function [dists,overlaps] = findDistsAndOverlaps(M,thisFrame,s1,s2)
dists = [];
overlaps = [];
for ii = 1:length(s1)
    centroid1 = s1(ii).Centroid;
    pixelInds1 = s1(ii).PixelIdxList;
    for jj = 1:length(s2)
        centroid2 = s2(jj).Centroid;
        dists(ii,jj) = sqrt(sum(((centroid2 - centroid1).^2)));
        pixelInds2 = s2(jj).PixelIdxList;
        overlaps(ii,jj) = length(intersect(pixelInds1,pixelInds2))/(length(pixelInds1)+length(pixelInds2)-length(intersect(pixelInds1,pixelInds2)));
    end
end

