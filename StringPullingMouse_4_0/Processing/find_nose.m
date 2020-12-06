function find_nose(handles,fn)

set(handles.pushbutton_stop_processing,'userdata',fn);
frames = get_frames(handles);

thisFrame = frames{fn};
M = populateM(handles,thisFrame,fn);
thisFrame = M.thisFrame;


useMouseString_IntX = get(handles.checkbox_use_mouse_string_intx,'Value');
if useMouseString_IntX
    ow = get(handles.checkbox_over_write,'Value');
    msint = find_mouse_string_intersection(handles,fn,1);
    msint = msint - [M.zw(1) M.zw(2)];
    xrange = (msint(1)-5):(msint(1)+5);
    yrange = (msint(2)-5):(msint(2)+5);
    zf = zeros(size(thisFrame(:,:,1)));
    zf(yrange,xrange) = 1;
    C = findRegions(zf);
    saveValsNose(handles,M,fn,C,0);
    return;
end

% masksMap = {'body','ears','hands','nose','string'};
In = get_mask(handles,fn,4);

if get(handles.checkbox_check_relationship_regions_nose,'Value')
    Cs{1} = getRegions(handles,fn,'body',1);
    if isempty(Cs{1})
        displayMessageBlinking(handles,sprintf('Can not find nose in frame %d ... find body first',fn),{'ForegroundColor','r'},2);
        return;
    end
end
if fn > 1
    Cs{2} = getRegions(handles,fn-1,'nose');
else
    Cs{2} = [];
end


if isempty(Cs{2})
    firstFrame = 1;
else
    firstFrame = 0;
    M.sNose = Cs{2}(1);
end
Ih = imfill(In,'holes');
Ih = bwareaopen(Ih,str2double(get(handles.edit_smallest_area_to_neglect_nose,'String')),8);
% Ih = bwareaopen(Ih,100,8);
Ih = bwconvhull(Ih,'objects');
s_r1 = findRegions(Ih,str2double(get(handles.edit_smallest_area_to_neglect_nose,'String')));
plotStringAndRegions(100,[],[],M,{s_r1},[]);
pause(0.15);
if get(handles.checkbox_check_relationship_regions_nose,'Value')
    bC = Cs{1};
    toDiscard = [];
    for ii = 1:length(s_r1)
        thisX = s_r1(ii).Centroid(1);
        thisY = s_r1(ii).Centroid(2);
        if thisX < min(bC.Ellipse_xs) | thisX > max(bC.Ellipse_xs) | thisY < min(bC.Ellipse_ys)
            toDiscard = [toDiscard ii];
        end
    end
    s_r1(toDiscard) = [];
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
end
if ~firstFrame
    [d_l,ol_l,bd_l] = findDistsAndOverlaps(M,M.thisFrame,M.sNose,s_r1);
    toDiscard = d_l*M.scale > 10;
    s_r1(toDiscard) = [];
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
end
if length(s_r1) > 1 & get(handles.checkbox_use_spatial_clustering,'Value')
    s_r1 = reduceRegionsBySpatialClusteringNose(M,s_r1);
end
if isempty(s_r1)
    return;
end
plotStringAndRegions(100,[],[],M,{s_r1},[]);
pause(0.15);
if ~firstFrame
    if length(s_r1) > 1 & get(handles.checkbox_combine_regions_across_string,'Value')
        s_r1 = combineRegionsAcrossString(handles,M,fn,s_r1,11);
    end
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
    [d_l,ol_l,bd_l] = findDistsAndOverlaps(M,M.thisFrame,M.sNose,s_r1);
    if sum(ol_l>0.1) == 1
        C(1) = s_r1(ol_l > 0.1);
    end
    if sum(ol_l>0.1) > 1
        ind = ol_l > 0.1 & bd_l == min(bd_l);
        if sum(ind) == 1
            C(1) = s_r1(ind);
        else
            ind = ind & ol_l == max(ol_l);
            C(1) = s_r1(ind);
        end
    end
    if sum(ol_l>0.1) == 0
        ind = bd_l == min(bd_l);
        if sum(ind) > 1
            ind = d_l == min(d_l);
        end
        C(1) = s_r1(ind);
    end
    n = 0;
%     C = updateRegionsBasedOnColor(handles,M,C,'Nose');
    saveValsNose(handles,M,fn,C,0);
    return;
end

Cm = Cs{1};
if Cm.Orientation < 0
    x = Cm.Major_axis_xs(1);
    y = Cm.Major_axis_ys(1);
else
    x = Cm.Major_axis_xs(2);
    y = Cm.Major_axis_ys(2);
end
centroids = getRegionValues(s_r1,'Centroid');
inds = centroids(:,2) > (Cm.Centroid(2) - abs((y-Cm.Centroid(2))/4)) | centroids(:,2) < y;
s_r1(inds) = [];
plotStringAndRegions(100,[],[],M,{s_r1},[]);
pause(0.15);
if length(s_r1) > 1
    s_r1 = reduceRegionsBySpatialClusteringEars(M,s_r1);
end
plotStringAndRegions(100,[],[],M,{s_r1},[]);
pause(0.15);

%     C_re = getSubjectFit(Cm.Centroid,Cm.Ma
s = s_r1;
for ii = 1:length(s)
    distances(ii) = sqrt((s(ii).Centroid(1)-x)^2+(s(ii).Centroid(2)-y)^2);
    areas(ii) = s(ii).Area*M.scale;
    centroidYs(ii) = s(ii).Centroid(2);
end

if ~exist('centroidYs','var')
    C = [];
    return;
end

% find areas greater than 100 to see blobls that are big and of
% importance
inds = find(areas>(10*M.scale));
if isempty(inds)
    C = [];
    return;
end
% find the closest centroid that is on the left for left ear and on the
% right for right ear
for ii = 1:length(inds)
    txs(ii) = s(inds(ii)).Centroid(1);
    tys(ii) = s(inds(ii)).Centroid(2);
end
xindsR = (abs(txs-x)<50);
if sum(xindsR) == 1
    C(1) = s(xindsR);
end
if sum(xindsR) > 1
    indsR = inds(xindsR);
    if length(indsR) > 1
        theAreasR = areas(indsR);
        iiR = find(theAreasR == max(theAreasR));
    else
        iiR = 1;
    end
    if ~isempty(indsR)
        iiR = indsR(iiR);     C(1) = s(iiR);
    end
end
if sum(xindsR) == 0
    xd = abs(txs-x);
    ind = xd == min(xd);
    C(1) = s(ind);
end
if ~exist('C','var')
    C = [];
end
n = 0;
% C = updateRegionsBasedOnColor(handles,M,C,'Nose');
plotStringAndRegions(100,thisFrame,[],M,{C},[]);
pause(0.15);
saveValsNose(handles,M,fn,C,0);

