function oC = findRegions(temp,varargin)

if nargin == 1
    temp = imfill(temp,'holes');
%     temp = bwareaopen(temp,100);
    temp = bwconvhull(temp,'objects');
end

if nargin == 2
    temp = imfill(temp,'holes');
    temp = bwareaopen(temp,varargin{1});
    temp = bwconvhull(temp,'objects');
end

mask = temp;

CC_mask_r1 = bwconncomp(mask);
aC = regionprops(CC_mask_r1,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema','Perimeter');

for ii = 1:length(aC)
    C = aC(ii);
    thetad = C.Orientation;
    theta = pi*C.Orientation/180;
    xd = (C.MajorAxisLength/2)*cosd(-C.Orientation);
    yd = (C.MajorAxisLength/2)*sind(-C.Orientation);
    C.Major_axis_xs = [(C.Centroid(1)-xd) (C.Centroid(1)+xd)];
    C.Major_axis_ys = [(C.Centroid(2)-yd) (C.Centroid(2)+yd)];
    xdf = (C.MajorAxisLength/4)*cosd(-C.Orientation);
    ydf = (C.MajorAxisLength/4)*sind(-C.Orientation);
    C.Major_axis_xs_foci = [(C.Centroid(1)-xdf) (C.Centroid(1)+xdf)];
    C.Major_axis_ys_foci = [(C.Centroid(2)-ydf) (C.Centroid(2)+ydf)];

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
    C = findBoundary(C,size(mask));
%     if strcmp(object,masksMap{1})
        C.In = zeros(size(mask));
        C.In(C.PixelIdxList) = 1;
        [allxs,allys] = meshgrid(1:size(mask,2),1:size(mask,1));
        C.eIn = inpolygon(allxs,allys,C.Ellipse_xs,C.Ellipse_ys);
        C.cIn = C.In | C.eIn;
%     end
    C.Circularity = (4*C.Area*pi)/(C.Perimeter^2);
    oC(ii) = C;
end

if ~exist('oC','var')
    oC = [];
end