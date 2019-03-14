function s = selectAppropriateRegions(M,Cs,masks,s)

Cm = Cs{1};
bCy = Cm.Centroid(2);
numberOfPixelsFromBelow = (size(Cm.In,1)-bCy)/2;
yT = size(Cm.In,1) - numberOfPixelsFromBelow;

topOfEllipse = min(Cm.yb);
numberOfPixelsFromAbove = abs(topOfEllipse-bCy)/2.5;
yTa = topOfEllipse + numberOfPixelsFromAbove;


[drs,ors,bdrs,dars,dxrs,dyrs] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
[dls,ols,bdls,dals,dxls,dyls] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);

toDiscard = [];
for ii = 1:length(s)
    centroidYs(ii) = s(ii).Centroid(2);
    if centroidYs(ii) > yT % threshold for discarding centroids that are greater than 1/4 the length of major axis from body centroid
        if ors(ii) == 0 & ols(ii) == 0
            toDiscard = [toDiscard ii];
        end
    end
    areas(ii) = s(ii).Area;%*scale;
    if areas(ii) > (M.TouchingHandsArea/0.95)
        if (ors(ii) == 0 & ols(ii) == 0) | centroidYs(ii) < yTa
            toDiscard = [toDiscard ii];
        end
    end
end
s(toDiscard) = [];

try
    Ce = Cs{2};
    RE = Ce(1); % region representing right ear
    LE = Ce(2); % region representing left ear
    toDiscard = [];
    [d_e_s,o_e_s] = findDistsAndOverlaps(M,M.thisFrame,LE,s);
    toDiscard = find(o_e_s);
    [d_e_s,o_e_s] = findDistsAndOverlaps(M,M.thisFrame,RE,s);
    toDiscard = [toDiscard find(o_e_s)];
    s(toDiscard) = [];
catch
end






% diffeyR = max(RE.yb) - min(RE.yb); % find maximum minus minimum y of boundary representing right region
% diffeyL = max(LE.yb) - min(LE.yb); % find maximum minus minimum y of boundary representing left region
% lengthE = max([diffeyR diffeyL]); % which region is larger
% zw = M.zw;
% cR = RE.Centroid - [zw(1) zw(2)]; % centroid of right ear
% cL = LE.Centroid - [zw(1) zw(2)]; % centroid of left ear
% RE.Centroid = cR;
% LE.Centroid = cL;
% temp = cL - cR; % temp is vector joing ear centroids
% eslope = temp(2)/temp(1); % slope of vector
% exs = linspace(cR(1),cL(1),50); % x points linspace
% eys = eslope*(exs-cR(1)) + cR(2); % y points of line parallel to and above line joining centroids of right and left ears
% eysd = eys + lengthE/4; % y points of line parallel to and below line joining centroids of right and left ears
% % eysu = eys - lengthE/2;

% discard regions if there centroid lies within ear regions
% catch
% end
% n = 0;
% temp = masks.Is;
% temp = imfill(temp,'holes');
% temp = bwareaopen(temp,100);
% toDiscard = [];
% for ii = 1:length(s)
%     areas(ii) = s(ii).Area*scale;
%     if areas(ii) < 20 % threshold for the minimum area in mm2
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];

% toDiscard = [];
% for ii = 1:length(s)
%     thisS = s(ii);
%     yC = thisS.Centroid(2);
%     xC = thisS.Centroid(1);
%     yC_line = eslope*(thisS.Centroid(1)-cR(1)) + cR(2)+ lengthE/4;
%     if yC < yC_line
%         toDiscard = [toDiscard ii];
%     end
% end
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
% Cm = Cs{1};
% Im = masks.Im;
% [allxs,allys] = meshgrid(1:size(Im,2),1:size(Im,1));
% In = Cm.In;%inpolygon(allxs,allys,Cm.xb,Cm.yb);
% In = In | inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);

% thisFrame = masks.thisFrame;
% chs = masks.chs;
 % discard the regions whose extremas are beyond the boundaries of mouse
% hull or body fur
% temp = bwboundaries(In);
% InBoundary = temp{1};
% toDiscard = [];
% for ii = 1:length(s)
%     thisS = s(ii);
%     thisExtrema = thisS.Extrema;
%     [in,on] = inpolygon(thisExtrema(:,1),thisExtrema(:,2),InBoundary(:,2),InBoundary(:,1));
%     if sum(on) > 0
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];

% boundaryPoints = [InBoundary(:,2) InBoundary(:,1)];
% toDiscard = [];
% for ii = 1:length(s)
%     thisS = s(ii);
%     thisCentroid = thisS.Centroid;
%     distsbp = sqrt(sum(((boundaryPoints-thisCentroid).^2),2));
%     if min(distsbp) < 20 % threshold for the distance of a centroid from boundary pixels
%         toDiscard = [toDiscard ii];
%     end
% end
% s(toDiscard) = [];

