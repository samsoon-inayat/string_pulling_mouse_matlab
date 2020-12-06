function find_body(handles,fn)

set(handles.pushbutton_stop_processing,'userdata',fn);
[globalR,~,~] = get_R_P_RDLC(handles);
frames = get_frames(handles);
thisFrame = frames{fn};
M = populateM(handles,thisFrame,fn);
thisFrame = M.thisFrame;

% % % % % thisFramem1 = frames{fn-1};
% % % % % Mm1 = populateM(handles,thisFramem1,fn-1);
% % % % % thisFramem1 = Mm1.thisFrame;
% % % % % shift = POCShift(rgb2gray(thisFrame),rgb2gray(thisFramem1));
% % % % 
% % % % 
% % % % % Is = get_masks(handles,fn,5);
% % % % % Cp = getRegions(handles,fn-1,'body',1);
% % % % % % fmaskc = expandOrCompressMask(fmask,0.75);
% % % % % fmaske = expandOrCompressMask(Cp.mask,1.5);
% % % % % bw = activecontour(rgb2gray(thisFrame),fmaske);
% % % % % figure(20);clf;imagesc(bw);axis equal
% % % % string_thickness = floor(getParameter(handles,'String Thickness in Pixels'));
% % % % % % M.Imp = expandOrCompressMask(Cp.cIn,1.1);
% % % % % M.Imp = fmaske;
% % % % % Im = Im & Imp;
% % % % % ML = populateM(handles,frames{fn-1},fn-1);
% % % % % lastFrame = ML.thisFrame;
% % % % % mc = getColors(handles,'Fur',4:6,0);
% % % % % cvs = getColorValues(ML.thisFrame,fmask);
% % % % % nClusters = 3;
% % % % % [cluster_idx, cluster_center] = kmeans(double(cvs),nClusters,'Replicates',6);
% % % % % for ii = 1:nClusters
% % % % %     vals(ii) = sum(cluster_idx == ii);
% % % % % end
% % % % % ind = find(vals == max(vals));
% % % % % Im = getThisMask(thisFrame,cvs(cluster_idx == ind,:),M.sizeMasks(1),M.sizeMasks(2),0);
% % % % n = 0;
% % % % % Im = get_masks(handles,fn,1);
% % % % Im = thisFrame(:,:,1);
% % % % cF = getColors(handles,'Fur',4:6,0);
% % % % cS = getColors(handles,'String',4:6,0);
% % % % % cB = getColors(handles,'Background',4:6,0);
% % % % htmpThickness = string_thickness;
% % % % st = 1:htmpThickness:size(Im,1);
% % % % et = htmpThickness:htmpThickness:size(Im,1);
% % % % dL = length(st)-length(et);
% % % % if dL < 0
% % % %     et = et(1:length(st));
% % % % end
% % % % if dL > 0
% % % %     st = st(1:length(et));
% % % % end
% % % % % length(st)
% % % % 
% % % % sth = 1:htmpThickness:size(Im,2);
% % % % eth = htmpThickness:htmpThickness:size(Im,2);
% % % % dLh = length(sth)-length(eth);
% % % % if dLh < 0
% % % %     eth = et(1:length(sth));
% % % % end
% % % % if dLh > 0
% % % %     sth = sth(1:length(eth));
% % % % end
% % % % 
% % % % for ii = 1:length(st)
% % % %     rows = st(ii):et(ii);
% % % %     cols = 1:size(Im,2);
% % % %     subFrame = thisFrame(rows,cols,:);
% % % % %     num_fur = [];
% % % % %     num_string = [];
% % % % %     num_background = [];
% % % %     for jj = 1:length(sth)
% % % %         sub_subFrame = subFrame(:,sth(jj):eth(jj),:);
% % % %         temp = getThisMask(sub_subFrame,cF,size(sub_subFrame(:,:,1),1),size(sub_subFrame(:,:,1),2),300);
% % % %         num_fur(ii,jj) = sum(temp(:));
% % % % %         temp = getThisMask(sub_subFrame,cS,size(sub_subFrame(:,:,1),1),size(sub_subFrame(:,:,1),2),300);
% % % % %         num_string(ii,jj) = sum(temp(:));
% % % % %         temp = getThisMask(sub_subFrame,cB,size(sub_subFrame(:,:,1),1),size(sub_subFrame(:,:,1),2),300);
% % % % %         num_background(ii,jj) = sum(temp(:));
% % % %     end
% % % % %     figure(10);clf;
% % % % %     plot(num_fur,'b');hold on;
% % % % %     plot(num_string,'r');
% % % % %     plot(num_background,'k');
% % % % %     title(ii);
% % % % %     pause(0.1);
% % % % %     anf(ii,:) = num_fur;
% % % % %     ans(ii,:) = num_string;
% % % % %     anb(ii,:) = num_background;
% % % % %     n = 0;
% % % % end
% % % % 
% % % % threshold_number = 0.25*string_thickness * string_thickness;
% % % % xsf = num_fur > threshold_number;
% % % % % xss = num_string > threshold_number;
% % % % % for ii = 1:length(st)
% % % % %     xsf(ii,:) = num_fur(ii,:) > threshold_number;
% % % % %     xss(ii,:) = num_string(ii,:) > threshold_number;
% % % % %     figure(10);clf;plot(num_fur(ii,:),num_string(ii,:));
% % % % %     title(ii)
% % % % %     pause(0.3);
% % % % % end
% % % % 
% % % % % sxs = xsf + 2*xss;
% % % % 
% % % % % C = conv2(sxs,[1 2 1]);
% % % % % [rr,cc] = find(C>=6);
% % % % [rr,cc] = find(xsf);
% % % % % [~,mrri] = min(rr);
% % % % % string_body_intersection = [st(rr(mrri)) sth(cc(mrri))];
% % % % % M.topPoint = string_body_intersection(1);
% % % % temp = zeros(size(Im));
% % % % for ii = 1:length(rr)
% % % %     temp(st(rr(ii)):et(rr(ii)),sth(cc(ii)):eth(cc(ii))) = 1;
% % % % end
% % % % Ih = imfill(temp,'holes');
% % % % Ih = bwareaopen(Ih,100,8);
% % % % Ih = bwconvhull(Ih,'objects');
% % % % % Im = double(Im).*temp;
% % % % Im = temp;
string_thickness = floor(getParameter(handles,'String Thickness in Pixels'));
% Im = find_mask_grid_way(handles,thisFrame,getColors(handles,'Fur',4:6,0),string_thickness,0.75);
Im = get_mask(handles,fn,1);
Ih = imfill(Im,'holes');
Ih = bwareaopen(Ih,str2double(get(handles.edit_uipanel_body_smallest_area,'String')),8);
% In = get_mask(handles,fn,'nose');
% Im = Im | In;
C = findC(Ih,M,thisFrame,str2double(get(handles.edit_uipanel_body_smallest_area,'String')));
% Cp = getRegions(handles,fn-1,'body',1);
% Im = C.In & Im;
% C = findC(Im,M,thisFrame);
saveValsBody(handles,M,fn,C,0);


function C = findC(Im,M,thisFrame,smA)

Ih = bwconvhull(Im,'objects');
% Ih = Ih & M.Imp;
s_r1 = findRegions(Ih,smA);
plotStringAndRegions(100,thisFrame,[],M,{s_r1},[]);
title(M.fn);
pause(0.15);
n = 0;
% [xb,yb] = find(M.Ib);
% itd = [];
% for ii = 1:length(s_r1)
%     dx = xb - s_r1(ii).Centroid(1);
%     dy = yb - s_r1(ii).Centroid(2);
%     dis = sqrt(dx.^2 + dy.^2);
%     inds = find(dis<1);
%     indsA = intersect([xb yb],s_r1(ii).PixelList,'rows');
%     if length(inds)>1 & length(indsA) > 1000
%         itd = [itd ii];
%     end
% end
% s_r1(itd) = [];
% centroids = getRegionValues(s_r1,'Centroid');
% inds = centroids(:,2) < M.topPoint;
% s_r1(inds) = [];
if length(s_r1) > 1
    s_r1 = reduceRegionsBySpatialClusteringBody(M,s_r1);
end
C = s_r1;
if length(C) > 1
%     C = combineRegions(C,1:length(C),size(M.thisFrame(:,:,1)));
    areas = getRegionValues(C,'Area');
    [~,ai] = max(areas);
    C = C(ai);
%     [db,lb] = findDistsAndOverlaps(M,M.thisFrame,Cp,C);
%     numOverlaps = sum(lb>0);
%     if numOverlaps == 1
%         ind = lb>0;
%         C = C(ind);
%     end
%     if numOverlaps == 2
%         ind = lb>0;
%         C = C(ind);
%         C = combineRegions(C,1:length(C),size(M.thisFrame(:,:,1)));
%     end
%     if numOverlaps > 2
%         C = combineRegions(C,1:length(C),size(M.thisFrame(:,:,1)));
%     end
end
if ~isstruct(C)
    C = [];
    return;
end

plotStringAndRegions(100,thisFrame,[],M,{C},[]);
title(M.fn);
pause(0.15);
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