function C = findHandsMethod2_1w(handles,M,fn,type,masks,thisFrame,Cs)
M.text_processing = handles.text_processing;
M.masks = masks;
M.thisFrame = thisFrame;
M.TouchingHandsArea = getParameter(handles,'Touching Hands Area');
M.numberOfPixelsFromAbove = (size(Cs{1}.In,1)-Cs{1}.Centroid(2))/2.5;

zw = M.zw;
sLeft = getRegion(M,fn-1,'Left Hand');
sRight = getRegion(M,fn-1,'Right Hand');
M.sLeft = sLeft;
M.sRight = sRight;
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

% Is = masks.Is;
% Is = imfill(Is,'holes');
% Is = bwareaopen(Is,100);
temp = [];
if get(handles.checkbox_userMSERMethod,'Value') & get(handles.checkbox_useHandsColorMask,'Value')
    I = (rgb2gray(thisFrame));
    MSER_th = getParameter(handles,'MSER Threshold');
    [regions_f,rrs] = detectMSERFeatures(I,'ThresholdDelta',MSER_th);
    mask_r = makeMaskFromRegions(handles,thisFrame,rrs);
    temp = mask_r & masks.Ih; %~Is & mask_r & expandOrCompressMask(masks.cIn,0.95) & masks.Ih;
end
if get(handles.checkbox_userMSERMethod,'Value')
    I = (rgb2gray(thisFrame));
    MSER_th = getParameter(handles,'MSER Threshold');
    [regions_f,rrs] = detectMSERFeatures(I,'ThresholdDelta',MSER_th);
    mask_r = makeMaskFromRegions(handles,thisFrame,rrs);
    temp = mask_r; %~Is & mask_r & expandOrCompressMask(masks.cIn,0.95);
end
if get(handles.checkbox_useHandsColorMask,'Value')
%     temp = ~Is & expandOrCompressMask(masks.cIn,0.95) & masks.Ih;
    temp = masks.Ih & expandOrCompressMask(Cs{1}.eIn,1.1);
end
if isempty(temp)
    C = -1;
    return;
end
Cm = Cs{1};

s_r1 = findRegions(temp);
plotStringAndRegions(100,[],[],M,{s_r1},Cs);
pause(0.15);
if length(s_r1) > 1
    s = reduceRegionsBySpatialClustering(M,s_r1);
else
    s = s_r1;
end
s = selectAppropriateRegions(M,Cs,M.masks,s);
plotStringAndRegions(100,[],[],M,{s},Cs);
pause(0.15);
s = selectRegionsSC(M,s,Cs);
plotStringAndRegions(100,[],[],M,{s},[]);
pause(0.15);
% s_in = s_r1;
if ~isempty(s)
    C = processS(M,Cs,s,xrp,yrp,xlp,ylp);
else
    C = [];
end
n = 0;
return;


function s = processS(M,Cs,s,xrp,yrp,xlp,ylp)
plotStringAndRegions(100,[],[],M,{s},[]);
pause(0.15);
if isempty(s)
    return;
end
if isfield(s(1),'Hand')
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
%     if s(1).Area > s(2).Area
%         areaRatio = s(1).Area/s(2).Area;
%         toDiscard = 2;
%     else
%         areaRatio = s(2).Area/s(1).Area;
%         toDiscard = 1;
%     end
%     if areaRatio > 5
%         s(toDiscard) = [];
%     end
    if length(s) == 2
        if s(1).Area > (M.TouchingHandsArea/0.90)
            s(2) = [];
        elseif s(2).Area > (M.TouchingHandsArea/0.90)
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
            ind1 = find(ol_l > 0.01);
            ind2 = find(ol_r > 0.01);
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
    sL = length(s);
    [d_l,ol_l,bd_l] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
    [d_r,ol_r,bd_r] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
    centroids = getRegionValues(s,'Centroid');
    cisR = kmeans_optimal(centroids);
%     cis = kmeans_opt(bd_r')
    
    ind1 = find(bd_l*M.scale < 1 & bd_r*M.scale > 0);
    ind2 = find(bd_r*M.scale < 1 & bd_r*M.scale > 0);
    if length(ind1) > 1
        s = combineRegions(s,ind1,size(M.thisFrame(:,:,1)));
        s = processS(M,Cs,s,xrp,yrp,xlp,ylp);
        if isfield(s,'Hand')
            return;
        end
    end
    if length(ind2) > 1
        s = combineRegions(s,ind2,size(M.thisFrame(:,:,1)));
        s = processS(M,Cs,s,xrp,yrp,xlp,ylp);
        if isfield(s,'Hand')
            return;
        end
    end
    
    ind1 = find(ol_l > 0.005);
    ind2 = find(ol_r > 0.005);
    if length(ind1) > 1
        s = combineRegions(s,ind1,size(M.thisFrame(:,:,1)));
        s = processS(M,Cs,s,xrp,yrp,xlp,ylp);
        if isfield(s,'Hand')
            return;
        end
    end
    if length(ind2) > 1
        s = combineRegions(s,ind2,size(M.thisFrame(:,:,1)));
        s = processS(M,Cs,s,xrp,yrp,xlp,ylp);
        if isfield(s,'Hand')
            return;
        end
    end
    if sum(ol_l > 0) == 1 & sum(ol_r > 0) == 1
        ind1 = find(ol_l > 0.001);
        ind2 = find(ol_r > 0.001);
        if ind1 ~= ind2
            toDiscard = setxor(1:length(s),[ind1 ind2]);
            s(toDiscard) = [];
            s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        else
            if s(ind1).Area > M.TouchingHandsArea
                s = find_centroids_coincident(s(ind1),[xrp yrp],[xlp ylp]);
                s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
            else
                s1(1) = s(ind1); s(ind1) = [];
    %             s = spatialClustering(s,size(M.thisFrame(:,:,1)),length(s)-1,M);
                [d_l,ol_l,bd_l] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
                [d_r,ol_r,bd_r] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
                [~,indR] = min(d_r); [~,indL] = min(d_l);
                [~,indRb] = min(bd_r); [~,indLb] = min(bd_l);
                if indR == indL & indRb == indLb
                    s1(2) = s(indR);
                else
                    s = [];
                end
                s = find_centroids_from_two(M,Cs,s1,xrp,yrp,xlp,ylp);
            end
        end
    else
        if sum(ol_l > 0) == 1 & sum(ol_r > 0) ~= 1
            ind = find(ol_l > 0.001);
            s1(1) = s(ind);
            s(ind) = [];
            [d,ol] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
            [~,ind] = min(d);
            s1(2) = s(ind);
            s = s1;
            s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        elseif sum(ol_l > 0) ~= 1 & sum(ol_r > 0) == 1
            ind = find(ol_r > 0.001);
            s1(1) = s(ind);
            s(ind) = [];
            [~,ol,d] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
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
