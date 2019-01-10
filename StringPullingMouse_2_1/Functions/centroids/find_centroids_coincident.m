function C = find_centroids_coincident(s,cr,cl)
tC = s;
thetad = tC.Orientation;
if thetad < 0
    thetad = thetad + 180;
end
theta = pi*tC.Orientation/180;
xd = (tC.MajorAxisLength/4)*cosd(-tC.Orientation);
yd = (tC.MajorAxisLength/4)*sind(-tC.Orientation);
Major_axis_xs = [(tC.Centroid(1)-xd) (tC.Centroid(1)+xd)];
Major_axis_ys = [(tC.Centroid(2)-yd) (tC.Centroid(2)+yd)];

allPixels = tC.PixelList;
allPixelsIdx = tC.PixelIdxList;
% here I am dividing the two halves of common ROI into left and right hands

xdm = (tC.MinorAxisLength/2)*cosd(-tC.Orientation+90);
ydm = (tC.MinorAxisLength/2)*sind(-tC.Orientation+90);
Minor_axis_xs = [(tC.Centroid(1)-xdm) (tC.Centroid(1)+xdm)];
Minor_axis_ys = [(tC.Centroid(2)-ydm) (tC.Centroid(2)+ydm)];

for ii = 1:size(allPixels,1)
    thisPoint = allPixels(ii,:);
    d = (thisPoint(1)-Minor_axis_xs(1))*diff(Minor_axis_ys)-(thisPoint(2)-Minor_axis_ys(1))*diff(Minor_axis_xs);
    if d < 0
        side(ii) = 0;
    else
        side(ii) = 1;
    end
end

zPL = allPixels(side==0,:);
oPL = allPixels(side==1,:);
zPLi = allPixelsIdx(side==0,:);
oPLi = allPixelsIdx(side==1,:);

C(1) = s;
C(2) = s;
C(2).PixelList = zPL;
C(1).PixelList = oPL;
C(2).PixelIdxList = zPLi;
C(1).PixelIdxList = oPLi;

if thetad > 80 & exist('cr','var')
    if cl(2) > cr(2)
        ind = find(Major_axis_ys == max(Major_axis_ys));
        C(1).Centroid(1) = Major_axis_xs(ind);
        C(1).Centroid(2) = Major_axis_ys(ind);
%         C(1).Hand = 'Left Hand';
        ind = find(Major_axis_ys == min(Major_axis_ys));
        C(2).Centroid(1) = Major_axis_xs(ind);
        C(2).Centroid(2) = Major_axis_ys(ind);
%         C(2).Hand = 'Right Hand';
    else
        ind = find(Major_axis_ys == max(Major_axis_ys));
        C(1).Centroid(1) = Major_axis_xs(ind);
        C(1).Centroid(2) = Major_axis_ys(ind);
%         C(1).Hand = 'Right Hand';
        ind = find(Major_axis_ys == min(Major_axis_ys));
        C(2).Centroid(1) = Major_axis_xs(ind);
        C(2).Centroid(2) = Major_axis_ys(ind);
%         C(2).Hand = 'Left Hand';
    end
    
    minC1x = min(C(1).PixelList(:,1)); maxC1x = max(C(1).PixelList(:,1));
    minC1y = min(C(1).PixelList(:,2)); maxC1y = max(C(1).PixelList(:,2));
    
    xc = C(1).Centroid(1); yc = C(1).Centroid(2);
    if xc > minC1x & xc < maxC1x & yc > minC1y & yc < maxC1y
    else
        temp = C(1).Centroid;
        C(1).Centroid = C(2).Centroid;
        C(2).Centroid = temp;
    end
    return;
end
ind = find(Major_axis_xs == max(Major_axis_xs));
C(1).Centroid(1) = Major_axis_xs(ind);
C(1).Centroid(2) = Major_axis_ys(ind);
% C(1).Hand = 'Left Hand';
ind = find(Major_axis_xs == min(Major_axis_xs));
C(2).Centroid(1) = Major_axis_xs(ind);
C(2).Centroid(2) = Major_axis_ys(ind);
% C(2).Hand = 'Right Hand';

minC1x = min(C(1).PixelList(:,1)); maxC1x = max(C(1).PixelList(:,1));
minC1y = min(C(1).PixelList(:,2)); maxC1y = max(C(1).PixelList(:,2));

xc = C(1).Centroid(1); yc = C(1).Centroid(2);
if xc > minC1x & xc < maxC1x & yc > minC1y & yc < maxC1y
else
    temp = C(1).Centroid;
    C(1).Centroid = C(2).Centroid;
    C(2).Centroid = temp;
end



