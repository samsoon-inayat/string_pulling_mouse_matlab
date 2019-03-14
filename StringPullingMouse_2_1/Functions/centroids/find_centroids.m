function C = find_centroids(M,fn,type,masks,thisFrame,Cs)
Im = masks.Im; Ih = masks.Ih; %Is = masks.Is; 
Ie = masks.Ie; In = masks.In;
masks.thisFrame = thisFrame;
M.masks = masks;
M.thisFrame = thisFrame;
M.fn = fn;
zw = M.zw;
% M.TouchingHandsArea = getParameter(handles,'Touching Hands Area');
if strcmp(type,'ears')
    if isempty(Cs{2})
        firstFrame = 1;
    else
        firstFrame = 0;
    end
    if ~firstFrame
        [xl yl] = getxyFromR(M,fn-1,'Left Ear');
        [xr yr] = getxyFromR(M,fn-1,'Right Ear');
        if ~isempty(xl) & isempty(xr)
            M.sLeft = Cs{2}(1); M.sRight = [];
        end
        if isempty(xl) & ~isempty(xr)
            M.sLeft = []; M.sRight = Cs{2}(1);
        end
        if ~isempty(xl) & ~isempty(xr)
            if abs(Cs{2}(1).Centroid(1) - xl) < 5  % Cs{2}(2).Centroid(1)
                M.sLeft = Cs{2}(1); M.sRight = Cs{2}(2);
            else
                M.sLeft = Cs{2}(2); M.sRight = Cs{2}(1);
            end
        end
    end
    Ie1 = Ie&~Cs{1}.cIn;
    Ih = imfill(Ie1,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
    s_r1 = findRegions(Ih);
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
    
    Cm = Cs{1};
    if Cm.Orientation < 0
        x = Cm.Major_axis_xs(1);
        y = Cm.Major_axis_ys(1);
    else
        x = Cm.Major_axis_xs(2);
        y = Cm.Major_axis_ys(2);
    end
    centroids = getRegionValues(s_r1,'Centroid');
    inds = centroids(:,2) > (Cm.Centroid(2) - abs((y-Cm.Centroid(2))/4)) | centroids(:,2) < (y-abs((y-Cm.Centroid(2))/4));
    s_r1(inds) = [];
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
    
%     centroids = getRegionValues(s_r1,'Centroid');
%     cis = kmeans_optimal(centroids);
%     ucis = unique(cis);
%     ind = 1;
%     toDiscard = [];
%     for ii = 1:length(ucis)
%         inds = find(cis == ucis(ii));
%         if length(inds) > 1
%             [~,sC] = combineRegions(s_r1,inds,size(Ih));
%         else
%             sC = s_r1(inds);
%         end
%         so(ind) = sC;
%         ind = ind + 1;
%     end
%     s_r1 = so;
%     plotStringAndRegions(100,[],[],M,{s_r1},[]);
%     pause(0.15);
    if length(s_r1) > 1
        s_r1 = reduceRegionsBySpatialClusteringEars(M,s_r1);
    end
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
    if ~firstFrame
        try
            [dl,ol,bdl] = findDistsAndOverlaps(M,thisFrame,M.sLeft,s_r1);
            [dr,or,bdr] = findDistsAndOverlaps(M,thisFrame,M.sRight,s_r1);
            if sum(or>0.1) == 1
                indR = find(or>0.1);
                C(1) = s_r1(indR);
            end
            if sum(ol>0.1) == 1
                indL = find(ol>0.1);
                C(2) = s_r1(indL);
            end
            if sum(or>0.1) == 1
                C(1).ear = 'Right Ear';
            end
            if sum(ol>0.1) == 1
                C(2).ear = 'Left Ear';
            end
            return;
%             s_r1 = selectRegionsSC (M,s_r1,'Ears');
        catch
            disp('Error during spatial clustering of ear regions in find_centroids function ... continuing without it');
        end
    end
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

    xindsR = (txs < x & abs(txs-x)>20);
    xindsL = (txs > x & abs(txs-x)>20);
    
    if sum(xindsR) == 1 & sum(xindsL) == 1
        C(1) = s(xindsR);
        C(2) = s(xindsL);
    else
        indsR = inds(xindsR);
        indsL = inds(xindsL);
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
    end
%     sDists = distances(inds);
%     ii = find(sDists == min(sDists));
    if ~exist('C','var')
        C = [];
    end
    C(1).ear = 'Right Ear';
    C(2).ear = 'Left Ear';
%     C = findBoundary(C,size(Ie));
    return;
end
if strcmp(type,'mouse')
%     Img = rgb2gray(thisFrame);
%     Imm = ~(Img<mean(Img(:)));
    Ih = imfill(Im,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
    s_r1 = findRegions(Ih);
    if length(s_r1) > 1
        s_r1 = reduceRegionsBySpatialClustering(M,s_r1,1);
    end
%     pIm = imfill(Im,'holes');
% %     pIm = bwconvhull(pIm,'objects');
% %     pIm = bwareaopen(pIm,100);
% %     pIm = bwconvhull(Im);
% %     pIm = expandOrCompressMask(pIm,0.99);
%     pIm = removeAreasBelowThreshold(pIm,M.scale,300);
%     pIm = bwconvhull(double(pIm),'objects');
%     pIm = removeAreasBelowThreshold(pIm,M.scale,350);
%     pIm = bwconvhull(pIm);
%     pIm = bwconvhull(double(pIm));
%     Iblur = imgaussfilt(thisFrame,5);
%     pIm = imfill(pIm);
%     CC_pIm = bwconncomp(pIm,8);
%     C = regionprops(CC_pIm,'centroid','MajorAxisLength','MinorAxisLength','Orientation','area','PixelIdxList','PixelList');
    C = s_r1;
    if length(C) > 1
%         areas = getRegionValues(C,'Area');
%         if areas(1) > areas(2)
%             rat = areas(1)/areas(2);
%         else
%             rat = areas(2)/areas(1);
%         end
%         
%         if rat > 10
%             ind = find(areas == max(areas));
%             C = C(ind);
%         else
            C = combineRegions(C,1:length(C),size(M.thisFrame(:,:,1)));
%         end
%         n = 0;
    end
    plotStringAndRegions(100,[],[],M,{C},[]);
    title(M.fn);
    pause(0.15);
%     for ii = 1:length(C)
%         areas(ii) = C(ii).Area;
%     end
%     C = C(areas == max(areas));
%     C = findBoundary(C,size(thisFrame(:,:,1)));
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
    C = findBoundary(C,size(thisFrame));
    C.In = zeros(size(thisFrame(:,:,1)));
    C.In(C.PixelIdxList) = 1;
    
    [allxs,allys] = meshgrid(1:size(Im,2),1:size(Im,1));
    C.eIn = inpolygon(allxs,allys,C.Ellipse_xs,C.Ellipse_ys);
    C.cIn = C.In | C.eIn;
    return;
end    

if strcmp(type,'nose')
    if isempty(Cs{2})
        firstFrame = 1;
    else
        firstFrame = 0;
        M.sNose = Cs{2}(1);
    end
    Ih = imfill(In,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
    s_r1 = findRegions(Ih);
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
    if length(s_r1) > 1
        s_r1 = reduceRegionsBySpatialClusteringNose(M,s_r1);
    end
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    pause(0.15);
    if ~firstFrame
        [d_l,ol_l,bd_l] = findDistsAndOverlaps(M,M.thisFrame,M.sNose,s_r1);
        if sum(ol_l>0.1) == 1
            C(1) = s_r1(ol_l > 0.1);
        end
        if sum(ol_l>0.1) > 1
            ind = ol_l > 0.1 & bd_l == min(bd_l);
            if length(ind) == 1
                C(1) = s_r1(ind);
            else
                ind = ind & ol_l == max(ol_l);
                C(1) = s_r1(ind);
            end
        end
        if sum(ol_l>0.1) == 0
            ind = bd_l == min(bd_l);
            C(1) = s_r1(ind);
        end
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
    return;
end
