function s = selectAppropriateRegions(M,Cs,masks,s)
In = masks.In;

Ce = Cs{2};
RE = Ce(1); % region representing right ear
LE = Ce(2); % region representing left ear
diffeyR = max(RE.yb) - min(RE.yb); % find maximum minus minimum y of boundary representing right region
diffeyL = max(LE.yb) - min(LE.yb); % find maximum minus minimum y of boundary representing left region
lengthE = max([diffeyR diffeyL]); % which region is larger
zw = M.zw;
cR = RE.Centroid - [zw(1) zw(2)]; % centroid of right ear
cL = LE.Centroid - [zw(1) zw(2)]; % centroid of left ear
temp = cL - cR; % temp is vector joing ear centroids
eslope = temp(2)/temp(1); % slope of vector
exs = linspace(cR(1),cL(1),50); % x points linspace
eys = eslope*(exs-cR(1)) + cR(2); % y points of line parallel to and above line joining centroids of right and left ears
eysd = eys + lengthE/4; % y points of line parallel to and below line joining centroids of right and left ears
% eysu = eys - lengthE/2;
toDiscard = [];
for ii = 1:length(s)
    thisS = s(ii);
    yC = thisS.Centroid(2);
    xC = thisS.Centroid(1);
    yC_line = eslope*(thisS.Centroid(1)-cR(1)) + cR(2)+ lengthE/4;
    if yC < yC_line
        toDiscard = [toDiscard ii];
    end
end
% s(toDiscard) = [];

% toDiscard = [];
% for ii = 1:length(s)
%     thisS = s(ii);
%     yC = thisS.Centroid(2)-zw(2);
%     temp = yC<eysu;
%     if sum(temp) == length(temp)
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];

% thisFrame = masks.thisFrame;
% chs = masks.chs;
 % discard the regions whose extremas are beyond the boundaries of mouse
% hull or body fur
temp = bwboundaries(In);
InBoundary = temp{1};
toDiscard = [];
for ii = 1:length(s)
    thisS = s(ii);
    thisExtrema = thisS.Extrema;
    [in,on] = inpolygon(thisExtrema(:,1),thisExtrema(:,2),InBoundary(:,2),InBoundary(:,1));
    if sum(on) > 0
        toDiscard = [toDiscard ii];
    end
end
s(toDiscard) = [];

boundaryPoints = [InBoundary(:,2) InBoundary(:,1)];
toDiscard = [];
for ii = 1:length(s)
    thisS = s(ii);
    thisCentroid = thisS.Centroid;
    distsbp = sqrt(sum(((boundaryPoints-thisCentroid).^2),2));
    if min(distsbp) < 20 % threshold for the distance of a centroid from boundary pixels
        toDiscard = [toDiscard ii];
    end
end
s(toDiscard) = [];



% discard those whose Extent is greater than 0.9 i.e. they are too much
% filled within the bounding box
% toDiscard = [];
% for ii = 1:length(s)
%     thisS = s(ii);
%     thisVal = thisS.Extent;
%     if thisVal > 0.9
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];

% % discard those whos distance between Centroid and WeightedCentroid and is small
% toDiscard = [];
% for ii = 1:length(s)
%     thisS = s(ii);
%     thisVal = sqrt(sum((thisS.Centroid - thisS.WeightedCentroid).^2));
%     if thisVal < 0.1
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];
% 
scale = M.scale;
toDiscard = [];
for ii = 1:length(s)
    areas(ii) = s(ii).Area*scale;
    if areas(ii) < 20 % threshold for the minimum area in mm2
        toDiscard = [toDiscard ii];
    end
end
s(toDiscard) = [];

% 
% scale = M.scale;
% toDiscard = [];
% for ii = 1:length(s)
%     areas(ii) = s(ii).Area*scale;
%     if areas(ii) > 400
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];

C = Cs{1};
% dy = max(C.Ellipse_ys) - min(C.Ellipse_ys);
numberOfPixelsFromBelow = 7.5/scale; % mm to number of pixels
% yT = max(C.Ellipse_ys) - dy/4;
yT = max(C.Ellipse_ys) - numberOfPixelsFromBelow;
toDiscard = [];
for ii = 1:length(s)
    centroidYs(ii) = s(ii).Centroid(2);
    if centroidYs(ii) > yT % threshold for discarding centroids that are greater than 1/4 the length of major axis from body centroid
        toDiscard = [toDiscard ii];
    end
end
s(toDiscard) = [];


n = 0;


% 
% discard rois with areas not within two thresholds
% aTm = 300 * scale;
% aTM = 6000 * scale;
% inds = find(areas>aTm & areas<aTM);
% toDiscard = setxor(1:length(s),inds);
% if length(toDiscard) < length(s)
%     s(toDiscard) = [];
% end
% 

