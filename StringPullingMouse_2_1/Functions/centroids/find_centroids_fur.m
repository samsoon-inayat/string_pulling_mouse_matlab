function C = find_centroids_fur(Im)
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


