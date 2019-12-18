function C = find_hands(handles,fn,varargin)

set(handles.pushbutton_stop_processing,'userdata',fn);
Cs{1} = getRegions(handles,fn,'body');
Cs{2} = getRegions(handles,fn,'right ear');
Cs{3} = getRegions(handles,fn,'left ear');
Cs{4} = getRegions(handles,fn,'nose');

frames = get_frames(handles);
thisFrame = frames{fn};
M = populateM(handles,thisFrame,fn);
% msint = find_mouse_string_intersection(handles,fn)
% M.numberOfPixelsFromAbove = (size(Cs{1}.In,1)-Cs{1}.Centroid(2))/2.5;


% Ih = get_masks(handles,fn,3);
thisFrame = M.thisFrame;


% motion = load_motion(handles);
% motionFrame = abs(motion.vxy(:,:,fn-1));
% motionFrame = imresize(motionFrame,motion.image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);

% string_thickness = floor((getParameter(handles,'String Thickness in Pixels')/2));
% Ih = find_mask_grid_way(handles,thisFrame,getColors(handles,'hands',4:6,0),string_thickness,0.5);
Ih = get_mask(handles,fn,'hands');
if sum(Ih(:)) == 0
    displayMessageBlinking(handles,'Mask doesn''t exist',{'foregroundcolor','r'},3);
    set(handles.pushbutton_stop_processing,'visible','off');
    return;
end

if fn > 1
    sLeft = getRegions(handles,fn-1,'Left Hand');
    sLeft = rmfield(sLeft,'mask');
    sRight = getRegions(handles,fn-1,'Right Hand');
    sRight = rmfield(sRight,'mask');
else
    sLeft = [];
    sRight = [];
end
M.sLeft = sLeft;
M.sRight = sRight;
if isempty(sRight)
    pf = 0;
    earsC(1) = Cs{2};earsC(2) = Cs{3};
    xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
    xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);
    displayMessageBlinking(handles,'No hands found in previous frame ... use manual tagging',{'foregroundcolor','r'},5);
    set(handles.pushbutton_stop_processing,'visible','off');
    return;
else
    pf = 1;
    xrp = sRight.Centroid(1); yrp = sRight.Centroid(2);
    xlp = sLeft.Centroid(1); ylp = sLeft.Centroid(2);
end

bdFrame = frames{fn} - frames{fn-1};
bdFrame = bdFrame(M.zw(2):M.zw(4),M.zw(1):M.zw(3),:);

zf = zeros(size(thisFrame(:,:,1)));

temp = [];
if get(handles.checkbox_userMSERMethod,'Value') & get(handles.checkbox_useHandsColorMask,'Value')
    I = (rgb2gray(thisFrame));
    MSER_th = getParameter(handles,'MSER Threshold');
    [regions_f,rrs] = detectMSERFeatures(I,'ThresholdDelta',MSER_th);
    mask_r = makeMaskFromRegions(handles,thisFrame,rrs);
    temp = mask_r & Ih; %~Is & mask_r & expandOrCompressMask(masks.cIn,0.95) & masks.Ih;
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
    if get(handles.checkbox_find_within_body_ellipse,'Value')
        temp = Ih & expandOrCompressMask(Cs{1}.eIn,1.1);
    else
        temp = Ih;
    end
end

if isempty(temp)
    C = -1;
    return;
end
Cs{1} = Cs{1};

s_r1 = findRegions(temp);
% s_r1 = selectAppropriateRegions(M,Cs,s_r1);
plotStringAndRegions(100,thisFrame,[],M,{s_r1},Cs);
pause(0.15);
if length(s_r1) > 1
    s = reduceRegionsBySpatialClustering(M,s_r1);
else
    s = s_r1;
end
% s = s_r1;
plotStringAndRegions(100,thisFrame,[],M,{s},Cs);
pause(0.15);
% s = removeBackgroundRegions(M,s);
% plotStringAndRegions(100,thisFrame,[],M,{s},Cs);
% pause(0.15);
s = selectAppropriateRegions(M,Cs,s);
plotStringAndRegions(100,thisFrame,[],M,{s},Cs);
pause(0.15);
s = selectRegionsSC(M,s,Cs);
plotStringAndRegions(100,thisFrame,[],M,{s},[]);
pause(0.15);

s_bd = [];
try
    Ihbd = get_masks(handles,fn,6);
    s_bd = findRegions(Ihbd);
    if length(s_bd) > 1
        s_bd = reduceRegionsBySpatialClustering(M,s_bd);
    end
    s_bd = selectAppropriateRegions(M,Cs,s_bd);
catch
end

% s_in = s_r1;
if ~isempty(s)
    C = processS(M,Cs,s,xrp,yrp,xlp,ylp,s_bd);
else
    C = [];
end
if isempty(C)
    erroneous;
end
C = findBoundary(C,size(thisFrame));
if nargin == 2
    saveValsHands(handles,M,fn,C,0);
else
    return
end


function s = processS(M,Cs,s,xrp,yrp,xlp,ylp,s_bd)
if ~exist('s_bd','var')
    s_bd = [];
end
thisFrame = M.thisFrame;
plotStringAndRegions(100,thisFrame,[],M,{s,s_bd},[]);
pause(0.15);
if isempty(s)
    return;
end
if isfield(s(1),'Hand')
    return;
end
if length(s) == 1
%     if s.Area > M.TouchingHandsArea
        s = find_centroids_coincident(M,s,[xrp yrp],[xlp ylp]);
%         s = processS(M,Cs,s,xrp,yrp,xlp,ylp);
        s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
%     else
%         s = [];
%     end
end
if length(s) == 2
%     if isempty(s_bd)
%         areas = getRegionValues(s,'Area');
%         ind = areas == max(areas);
%         s = find_centroids_coincident(M,s(ind),[xrp yrp],[xlp ylp]);
%         s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
%         return;
%     end
    % If there are two regions and one of them is big area with two hands
    if s(1).Area > s(2).Area
        areaRatio = s(1).Area/s(2).Area;
        toDiscard = 2;
    else
        areaRatio = s(2).Area/s(1).Area;
        toDiscard = 1;
    end
    if areaRatio > 10
        s(toDiscard) = [];
    end
    if length(s) == 2
        if ~(s(1).Area > (M.TouchingHandsArea/0.90) && s(2).Area > (M.TouchingHandsArea/0.90))
            if s(1).Area > (M.TouchingHandsArea/0.90)
                s(2) = [];
            elseif s(2).Area > (M.TouchingHandsArea/0.90)
                s(1) = [];
            end
        end
    end
    if length(s) == 1
        s = find_centroids_coincident(M,s,[xrp yrp],[xlp ylp]);
        s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
    end
    if length(s) == 2
        try
            [d_ln,ol_ln] = findDistsAndOverlaps(M,M.thisFrame,Cs{4},s);
            if sum(ol_ln>0) >= 1
                [d_l,ol_l] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
                [d_r,ol_r] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
                ind1 = find(ol_l>0);
                ind2 = find(ol_r>0);
                if sum(ol_l > 0) == 1 && sum(ol_r > 0) == 1 && ind1 ~= ind2
                    ind1 = find(ol_l > 0.01);
                    ind2 = find(ol_r > 0.01);
                    if ind1 ~= ind2
                        toDiscard = setxor(1:length(s),[ind1 ind2]);
                        s(toDiscard) = [];
                    end
                end
                if ind1 == ind2
                    s(3-ind1) = [];
                end
            end
        catch
            s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
            return;
        end
    end
    if length(s) == 1
        s = find_centroids_coincident(M,s,[xrp yrp],[xlp ylp]);
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
    if ~isempty(s_bd)
        [d_bd,ol_bd,bd_bd] = findDistsAndOverlaps(M,M.thisFrame,s_bd,s);
        [d_l_bd,ol_l_bd,bd_l_bd] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s_bd);
        [d_r_bd,ol_r_bd,bd_r_bd] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s_bd);
        if sum(ol_bd(:)>0) == 1
            [rr,cc] = find(ol_bd > 0);
            s1 = s(cc);
            [d_l_bd,ol_l_bd,bd_l_bd] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s1);
            [d_r_bd,ol_r_bd,bd_r_bd] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s1);
            if sum(ol_l>0) == 1 && sum(ol_r>0) == 1
                s = find_centroids_coincident(M,s1,[xrp yrp],[xlp ylp]);
                s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
                return;
            end
            n = 0;
        end
        n = 0;
    end
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
                s = find_centroids_coincident(M,s(ind1),[xrp yrp],[xlp ylp]);
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
                    [d_l_s1,~,~] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s1);
                    [d_r_s1,~,~] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s1);
                    if d_l_s1 < d_r_s1
                        s1(2) = s(indR);
                    else
                        s1(2) = s(indL);
                    end
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


