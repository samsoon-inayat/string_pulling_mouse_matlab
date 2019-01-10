function C = findHandsMethod2_1(handles,M,fn,type,masks,thisFrame,Cs)
global frames;
thisFramem1 = frames{fn-1};
zw = M.zw;
thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
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
% zw = handles.md.resultsMF.zoomWindow;
F1 = double(rgb2gray(thisFrame));
% zw1 = handles.md.resultsMF.zoomWindow;
% global gradients;
% thisGradient = reshape(gradients(:,fn),zw1(4)-zw1(2)+1,zw1(3)-zw1(1)+1);
% maskGradient = find_mask_threshold(thisGradient,2);
% maskG = imfill(maskGradient);
% maskG = bwareaopen(maskG,100);
% sg = findRegions(M,Cs,masks,F1,maskG);
% sbDhs = findRegions(M,Cs,masks,bDg,bDhs_mask);

I = (rgb2gray(thisFrame));
[regions_f,rrs] = detectMSERFeatures(I);
mask_r = makeMaskFromRegions(rrs);
temp = masks.Ih & mask_r;
if sum(temp(:)) == 0
    [s sp] = findRegions(M,Cs,masks,F1,masks.Ih);
else
    [s sp] = findRegions(M,Cs,masks,F1,temp);
end
if strcmp(type,'')
    C = sp;
    return;
end
% if length(s) > 4
%     s = narrowDownRegions(s,sbDhs);
%     n = 0;
% end

% see if you can find which hand moved and how much it moved
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
tempCode1;

bD_mask = masks.bd;
fD_mask = masks.fd;
% bDhs_mask = find_mask_1(handles,bD,'handString');
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


if strcmp(mo,'00')
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    indl = find(ol == max(ol));
    indr = find(or == max(or));
    if indl == indr
        ss(1) = s(indl);
        ss = find_centroids_coincident(ss,[xrp yrp],[xlp ylp]);
        C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    else
        ss(1) = s(indl);
        ss(2) = s(indr);
        C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
end



if strcmp(mo,'01')
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    [d,o] = findDistsAndOverlaps(M,thisFrame,s,sbD);
    if sum(o(:)>0) > 0
        [rr,cc] = find(o == max(o(:)));
        ss(1) = s(rr);
        s(rr) = [];
    end
    [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    if max(ol) > max(or)
        ind = find(ol == max(ol));
    else
        ind = find(or == max(or));
    end
    ss(2) = s(ind);
    C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
    return;
end

if strcmp(mo,'10') 
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    clear ss;
    [d,o] = findDistsAndOverlaps(M,thisFrame,s,sfD);
    if sum(o(:)>0) > 0
        [rr,cc] = find(o == max(o(:)));
        ss(1) = s(rr);
        s(rr) = [];
    end
    [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    if exist('ss','var')
        if max(ol) > max(or)
            ind = find(ol == max(ol));
        else
            ind = find(or == max(or));
        end
        ss(2) = s(ind);
        C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    else
        ind = find(ol == max(ol));
        ss(1) = s(ind);
        ind = find(or == max(or));
        ss(2) = s(ind);
        C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
end

leftF = 0; rightF = 0;
if strcmp(mo,'11')
    if length(s) == 1
        s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
        C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
    end
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    if length(s) == 2
        if co == 1 && (max(areas)/min(areas)) > 10
            ind = find(areas == max(areas));
            s = find_centroids_coincident(s(ind),[xrp yrp],[xlp ylp]);
            C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
            return;
        end
        C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
    end
    [ss,inds] = findBasedOnPreviousHandPositions(M,thisFrame,s,sLeft,sRight); % see if previous hand positions can be used to find current hand positions
    if length(ss) == 2 && (inds(1) ~= inds(2))
        C = ss;%find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
    if length(ss) == 1
        if strcmp(ss(1).Hand,'Left Hand')
            leftF = 1;
        else
            rightF = 1;
        end
    end
    if ~rightF & leftF
        s(inds) = [];
        [d,o] = findDistsAndOverlaps(M,thisFrame,s,sRight);
        if sum(o>0.1) > 0
            [rr,cc] = find(o == max(o(:)));
        else
            [rr,cc] = find(d == min(d(:)));
        end
        s(rr).Hand = 'Right Hand';
        ss(2) = s(rr);
        C = ss;%find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
    if ~leftF & rightF
        s(inds) = [];
        [d,o] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
        if sum(o>0.1) > 0
            [rr,cc] = find(o == max(o(:)));
        else
            [rr,cc] = find(d == min(d(:)));
        end
        s(rr).Hand = 'Left Hand';
        ss(2) = s(rr);
        C = ss;%find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
    if ~leftF & ~rightF
        [db,ob] = findDistsAndOverlaps(M,thisFrame,s,sbD);
        if length(sbD) == 1
            [db,ob] = findDistsAndOverlaps(M,thisFrame,s,sbD);
            if sum(ob>0.1) > 0
                [rr,cc] = find(ob == max(ob(:)));

            end
            ssi = ssi + 1;
            ss(ssi) = s(rr);
            s(rr) = [];
            if ssi == 2
                C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
                return;
            end
    %         [df,of] = findDistsAndOverlaps(M,thisFrame,s,sfD);
    %         if sum(of(:)>0.1) > 0
    %             o = of;
    %             [rr,cc] = find(o == max(o(:)));
    %             ss(2) = s(rr);
    %             C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
    %             return;
    %         else
    %             [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    %             [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    %             if max(ol) > max(or)
    %                 ind = find(ol == max(ol));
    %             else
    %                 ind = find(or == max(or));
    %             end
    %             ss(2) = s(ind);
    %             C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
    %             return;
    %         end
        end

        if length(sbD) == 2
            [d,o] = findDistsAndOverlaps(M,thisFrame,s,sbD);
            clear ss;
            if sum(o(:)>0.1) > 0
                sii = 0;
                for ii = 1:size(o,2)
                    to = o(:,ii);
                    if sum(to>0.1) > 0
                    ind = find(to == max(to));
                    sii = sii + 1;
                    ss(sii) = s(ind);
                    end
                end
            end
            C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
            return;
        end
        if length(sbD) > 2
            [d,o] = findDistsAndOverlaps(M,thisFrame,s,sbD);
            clear ss;
            if sum(o(:)>0.1) > 0
                sii = 0;
                for ii = 1:size(o,2)
                    to = o(:,ii);
                    if sum(to>0.1) > 0
                    ind = find(to == max(to));
                    sii = sii + 1;
                    ss(sii) = s(ind);
                    end
                end
            end
            C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
            return;
        end
    end
    n = 0;
end

% C = [];
return;


function [ss,inds] = findBasedOnPreviousHandPositions(M,thisFrame,s,sLeft,sRight)
inds = [];
ssi = 0;
[~,sl] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
[~,sr] = findDistsAndOverlaps(M,thisFrame,s,sRight);
if sum(sl>0.1) > 0 & sum(sr>0.1) == 0
    if sum(sl>0.1) == 1
        ind = find(sl == max(sl));
        ssi = ssi + 1;
        ss(ssi) = s(ind);
        ss(ssi).Hand = 'Left Hand';
        inds = [inds ind];
    end
end
if sum(sr>0.1) > 0 & sum(sl>0.1) == 0 
    if sum(sr>0.1) == 1
        ind = find(sr == max(sr));
        ssi = ssi + 1;
        ss(ssi) = s(ind);
        ss(ssi).Hand = 'Right Hand';
        inds = [inds ind];
    end
end
if sum(sr>0.1) > 0 & sum(sl>0.1) > 0 
    ind = find(sl == max(sl));
    ssi = ssi + 1;
    ss(ssi) = s(ind);
    ss(ssi).Hand = 'Left Hand';
    inds = [inds ind];
    ind = find(sr == max(sr));
    ssi = ssi + 1;
    s(ind).Hand = 'Right Hand';
    ss(ssi) = s(ind);
    ss(ssi).Hand = 'Right Hand';
    inds = [inds ind];
end
if ~exist('ss','var')
    ss = [];
end
