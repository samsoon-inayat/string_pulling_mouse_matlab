function C = findHandsMethod2_1(handles,M,fn,type,masks,thisFrame,Cs)
zw = M.zw;
sLeft = getRegion(M,fn-1,'Left Hand');
sRight = getRegion(M,fn-1,'Right Hand');
M.sLeft = sLeft;
M.sRight = sRight;
M.text_processing = handles.text_processing;
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
zf = zeros(size(thisFrame(:,:,1)));
masks.thisFrame = thisFrame;
Cm = Cs{1};
cIn = expandOrCompressMask(Cm.In,0.99);
masks.cIn = cIn;

Is = masks.Is;
Is = imfill(Is,'holes');
Is = bwareaopen(Is,100);
temp = [];
if get(handles.checkbox_userMSERMethod,'Value') & get(handles.checkbox_useHandsColorMask,'Value')
    I = (rgb2gray(thisFrame));
    MSER_th = getParameter(handles,'MSER Threshold');
    [regions_f,rrs] = detectMSERFeatures(I,'ThresholdDelta',MSER_th);
    mask_r = makeMaskFromRegions(handles,thisFrame,rrs);
    temp = ~Is & mask_r & expandOrCompressMask(masks.cIn,0.95) & masks.Ih;
end
if get(handles.checkbox_userMSERMethod,'Value')
    I = (rgb2gray(thisFrame));
    MSER_th = getParameter(handles,'MSER Threshold');
    [regions_f,rrs] = detectMSERFeatures(I,'ThresholdDelta',MSER_th);
    mask_r = makeMaskFromRegions(handles,thisFrame,rrs);
    temp = ~Is & mask_r & expandOrCompressMask(masks.cIn,0.95);
end
if get(handles.checkbox_useHandsColorMask,'Value')
%     temp = ~Is & expandOrCompressMask(masks.cIn,0.95) & masks.Ih;
    temp = masks.Ih;
end
if isempty(temp)
    C = -1;
    return;
end

M.masks = masks;
M.thisFrame = thisFrame;
M.TouchingHandsArea = getParameter(handles,'Touching Hands Area');
s_r1 = findRegions(temp);
plotStringAndRegions(100,[],[],M,{s_r1},[]);
pause(0.15);
if length(s_r1) > 1
    s_r1 = reduceRegionsBySpatialClustering(M,s_r1);
end
s_in = selectAppropriateRegions(M,Cs,M.masks,s_r1);
pause(0.15);
if ~isempty(s_in)
    C = processS(M,Cs,s_in,xrp,yrp,xlp,ylp);
else
    C = [];
end
n = 0;
return;


function s = processS(M,Cs,s,xrp,yrp,xlp,ylp)
plotStringAndRegions(100,[],[],M,{s},[]);
pause(0.15);
if isfield(s(1),'Hand') | isempty(s)
    return;
end
if length(s) == 1
%     if s.Area > M.TouchingHandsArea
        s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
%         s = processS(M,Cs,s,xrp,yrp,xlp,ylp);
        s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
%     else
%         s = [];
%     end
end
if length(s) == 2
    % If there are two regions and one of them is big area with two hands
    if s(1).Area > s(2).Area
        areaRatio = s(1).Area/s(2).Area;
        toDiscard = 2;
    else
        areaRatio = s(2).Area/s(1).Area;
        toDiscard = 1;
    end
    if areaRatio > 5
        s(toDiscard) = [];
    end
    if length(s) == 2
        if s(1).Area > (M.TouchingHandsArea/1.3)
            s(2) = [];
        elseif s(2).Area > (M.TouchingHandsArea/1.3)
            s(1) = [];
        end
    end
    if length(s) == 1
        s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
        s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
    end
    if length(s) == 2
        [d_l,ol_l] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
        [d_r,ol_r] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
        if sum(ol_l > 0) == 1 & sum(ol_r > 0) == 1
            ind1 = find(ol_l > 0);
            ind2 = find(ol_r > 0);
            if ind1 ~= ind2
                toDiscard = setxor(1:length(s),[ind1 ind2]);
                s(toDiscard) = [];
            end
        end
    end
    if length(s) == 1
        s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
        s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
    end
    s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
end
% if length(s) == 3 | length(s) == 4
if length(s) > 2
    [d_l,ol_l,bd_l] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
    [d_r,ol_r,bd_r] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
    if sum(ol_l > 0) == 1 & sum(ol_r > 0) == 1
        ind1 = find(ol_l > 0);
        ind2 = find(ol_r > 0);
        if ind1 ~= ind2
            toDiscard = setxor(1:length(s),[ind1 ind2]);
            s(toDiscard) = [];
            s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        else
            [ds,ols] = findDistsAndOverlaps(M,M.thisFrame,s,s);
            [rr,cc] = find(ds == min(ds(ds(:)>0)));
            toDiscard = setxor(1:length(s),[rr(1) cc(1)]);
            s(toDiscard) = [];
            s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        end
    else
        if sum(ol_l > 0) == 1 & sum(ol_r > 0) ~= 1
            ind = find(ol_l > 0);
            s1(1) = s(ind);
            s(ind) = [];
            [d,ol] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
            [~,ind] = min(d);
            s1(2) = s(ind);
            s = s1;
            s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        elseif sum(ol_l > 0) ~= 1 & sum(ol_r > 0) == 1
            ind = find(ol_r > 0);
            s1(1) = s(ind);
            s(ind) = [];
            [d,ol] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
            [~,ind] = min(d);
            s1(2) = s(ind);
            s = s1;
            s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        else
            [~,indl] = min(bd_l);
            [~,indr] = min(bd_r);
            if indl ~= indr
                s1(1) = s(indl);
                s1(2) = s(indr);
                s = s1;
                s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
            else
                s1(1) = s(indl);
                s(indl) = [];
                [d_l,ol_l,bd_l] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
                [d_r,ol_r,bd_r] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
                [~,indl] = min(bd_l);
                [~,indr] = min(bd_r);
                if indl == indr
                    s1(2) = s(indl);
                    s = s1;
                    s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
                else
                    s = [];
                end
            end
        end
    end
    s = processS(M,Cs,s,xrp,yrp,xlp,ylp);
end
% if length(s) > 4
%     s = [];
% end