function C = find_centroids(M,fn,type,masks,thisFrame,Cs)
Im = masks.Im; Ih = masks.Ih; Is = masks.Is; Ie = masks.Ie;
if strcmp(type,'ears')
    if ~isempty(M.R)
        indexC = strfind(M.tags,'Right Ear');
        tagR = find(not(cellfun('isempty', indexC)));
        indR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
        indexC = strfind(M.tags,'Left Ear');
        tagL = find(not(cellfun('isempty', indexC)));
        indL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
        if any(indL) | any(indR)
            if any(indR)
                C(1).Centroid(1) = M.R(indR,3);
                C(1).Centroid(2) = M.R(indR,4);
                C(1).Area = M.R(indR,5);
                C(1).ear = 'Right Ear';
            end
            if any(indL)
                C(2).Centroid(1) = M.R(indL,3);
                C(2).Centroid(2) = M.R(indL,4);
                C(2).Area = M.R(indL,5);
                C(2).ear = 'Left Ear';
            end

            indR = ismember(M.P(:,[1 2]),[fn tagR],'rows');
            indL = ismember(M.P(:,[1 2]),[fn tagL],'rows');
            [Xm,Ym] = meshgrid(1:size(thisFrame,2),1:size(thisFrame,1));
            zw = M.zw;
            if any(indR)
                pixelsI = M.P(indR,3);
                [yb,xb] = ind2sub(M.frameSize,pixelsI);
                yb = yb - zw(2); xb = xb - zw(1);
                C(1).xb = xb;
                C(1).yb = yb;
                in = inpolygon(Xm,Ym,xb,yb);
                C(1).PixelIdxList = find(in);
            end
            if any(indL)
                pixelsI = M.P(indL,3);
                [yb,xb] = ind2sub(M.frameSize,pixelsI);
                yb = yb - zw(2); xb = xb - zw(1);
                C(2).xb = xb;
                C(2).yb = yb;
                in = inpolygon(Xm,Ym,xb,yb);
                C(2).PixelIdxList = find(in);
            end
            if exist('C','var')
                return;
            end
        end
    end
    
    Cm = Cs{1};%find_centroids(M,fn,'mouse');
%     tIm = expandOrCompressMask(Im,1.05);
    tIm = Im;
    if Cm.Orientation < 0
        x = Cm.Major_axis_xs(1);
        y = Cm.Major_axis_ys(1);
    else
        x = Cm.Major_axis_xs(2);
        y = Cm.Major_axis_ys(2);
    end
%     Ih = bwmorph(Ih,'clean');
%     tIh = bwmorph(Ie,'open');
    [allxs,allys] = meshgrid(1:size(Im,2),1:size(Im,1));
    In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);
    inds = find(allys > Cm.Centroid(2));
%     In = expandOrCompressMask(In,1);
    chs = Ie&~In;
    chs(inds) = 0;
%     chs = tIh.*(~tIm);
    chs = bwmorph(chs,'open');
%     chs = bwconvhull(chs);
    s = regionprops(chs,'centroid','area','PixelIdxList','PixelList');
    for ii = 1:length(s)
        distances(ii) = sqrt((s(ii).Centroid(1)-x)^2+(s(ii).Centroid(2)-y)^2);
        areas(ii) = s(ii).Area*M.scale;
        centroidYs(ii) = s(ii).Centroid(2);
    end
    
    if ~exist('centroidYs','var')
        C = [];
        return;
    end
    
    toDiscard = find(centroidYs>(Cm.Centroid(2)-Cm.MajorAxisLength/16));
    s(toDiscard) = [];areas(toDiscard) = []; centroidYs(toDiscard) = [];
    
    % find areas greater than 100 to see blobls that are big and of
    % importance
    inds = find(areas>(50*M.scale));
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
    xindsR = (txs < x & abs(txs-x)>20);
    xindsL = (txs > x & abs(txs-x)>20);
    yinds = (abs(tys-y)<150);
    indsR = inds(xindsR&yinds);
    indsL = inds(xindsL&yinds);
    if length(indsR) > 1
        theAreasR = areas(indsR);
        iiR = find(theAreasR == max(theAreasR));
    else
        iiR = 1;
    end
    if length(indsL) > 1
        theAreasL = areas(indsL);
        iiL = find(theAreasL == max(theAreasL));
    else
        iiL = 1;
    end
    if ~isempty(indsR)
        iiR = indsR(iiR);     C(1) = s(iiR);
    end
    if ~isempty(indsL)
         iiL = indsL(iiL);    C(2) = s(iiL);
    end
%     sDists = distances(inds);
%     ii = find(sDists == min(sDists));
    if ~exist('C','var')
        C = [];
    end
    C(1).ear = 'Right Ear';
    C(2).ear = 'Left Ear';
    return;
end
if strcmp(type,'mouse')
    if ~isempty(M.R)
        indexC = strfind(M.tags,'Subject');
        tag = find(not(cellfun('isempty', indexC)));
        jj = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
        indexC = strfind(M.tags,'Subject Props');
        tag = find(not(cellfun('isempty', indexC)));
        iii = ismember(M.R(:,[1 2]),[fn tag],'rows');
        if any(iii)
            zw = M.zw;
            C = getSubjectFit(M.R(jj,[3 4])-[zw(1) zw(2)],M.R(iii,3),M.R(iii,4),M.R(iii,5));
            return;
        end
    end
    
    
%     pIm = imfill(Im);
%     pIm = bwareaopen(pIm,100);
    pIm = bwconvhull(Im);
    pIm = expandOrCompressMask(pIm,0.99);
    C = regionprops(pIm,'centroid','MajorAxisLength','MinorAxisLength','Orientation','area','PixelIdxList','PixelList');
    for ii = 1:length(C)
        areas(ii) = C(ii).Area;
    end
    C = C(areas == max(areas));
    thetad = C.Orientation;
    theta = pi*C.Orientation/180;
    xd = (C.MajorAxisLength/2)*cosd(-C.Orientation);
    yd = (C.MajorAxisLength/2)*sind(-C.Orientation);
    C.Major_axis_xs = [(C.Centroid(1)-xd) (C.Centroid(1)+xd)];
    C.Major_axis_ys = [(C.Centroid(2)-yd) (C.Centroid(2)+yd)];

    xd = (C.MinorAxisLength/2)*cosd(-C.Orientation+90);
    yd = (C.MinorAxisLength/2)*sind(-C.Orientation+90);
    C.Minor_axis_xs = [(C.Centroid(1)-xd) (C.Centroid(1)+xd)];
    C.Minor_axis_ys = [(C.Centroid(2)-yd) (C.Centroid(2)+yd)];
    xbar = C.Centroid(1);
    ybar = C.Centroid(2);
    a = C.MajorAxisLength/2;
    b = C.MinorAxisLength/2;


    R = [ cos(theta)   sin(theta)
         -sin(theta)   cos(theta)];
    phi = linspace(0,2*pi,50);
    cosphi = cos(phi);
    sinphi = sin(phi);
    xy = [a*cosphi; b*sinphi];
    xy = R*xy;

    x = xy(1,:) + xbar;
    y = xy(2,:) + ybar;

    C.Ellipse_xs = x;
    C.Ellipse_ys = y;
    return;
end    

