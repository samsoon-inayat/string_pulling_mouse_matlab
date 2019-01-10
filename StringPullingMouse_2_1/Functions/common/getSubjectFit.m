function C = getSubjectFit(Centroid,MajorAxisLength,MinorAxisLength,Orientation)
thetad = Orientation;
theta = pi*Orientation/180;
xd = (MajorAxisLength/2)*cosd(-Orientation);
yd = (MajorAxisLength/2)*sind(-Orientation);
C.Major_axis_xs = [(Centroid(1)-xd) (Centroid(1)+xd)];
C.Major_axis_ys = [(Centroid(2)-yd) (Centroid(2)+yd)];
xd = (MinorAxisLength/2)*cosd(-Orientation+90);
yd = (MinorAxisLength/2)*sind(-Orientation+90);
C.Minor_axis_xs = [(Centroid(1)-xd) (Centroid(1)+xd)];
C.Minor_axis_ys = [(Centroid(2)-yd) (Centroid(2)+yd)];
xbar = Centroid(1);
ybar = Centroid(2);
a = MajorAxisLength/2;
b = MinorAxisLength/2;


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
C.Orientation = Orientation;
C.Centroid = Centroid;
C.MajorAxisLength = MajorAxisLength;
C.MinorAxisLength = MinorAxisLength;
