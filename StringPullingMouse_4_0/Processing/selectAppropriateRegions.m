function s = selectAppropriateRegions(M,Cs,s)
if isempty(s)
    return;
end
s_in = s;
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
areas = [];
for ii = 1:length(s)
    centroidYs(ii) = s(ii).Centroid(2);
    if centroidYs(ii) > yT % threshold for discarding centroids that are greater than 1/4 the length of major axis from body centroid
        if ors(ii) == 0 & ols(ii) == 0
            toDiscard = [toDiscard ii];
        end
    end
%     areas(ii) = s(ii).Area;%*scale;
%     if areas(ii) > (M.TouchingHandsArea/0.95)
%         if (ors(ii) == 0 & ols(ii) == 0) | centroidYs(ii) < yTa
%             toDiscard = [toDiscard ii];
%         end
%     end
end
s(toDiscard) = [];

try
    RE = Cs{2}; % region representing right ear
    LE = Cs{3}; % region representing left ear
    toDiscard = [];
    [d_e_s,o_e_s] = findDistsAndOverlaps(M,M.thisFrame,LE,s);
    toDiscard = find(o_e_s);
    [d_e_s,o_e_s] = findDistsAndOverlaps(M,M.thisFrame,RE,s);
    toDiscard = [toDiscard find(o_e_s)];
    s(toDiscard) = [];
catch
end

try
    Cn = Cs{4};
    [d_e_s,o_e_s] = findDistsAndOverlaps(M,M.thisFrame,Cn,s);
    inds = find(o_e_s>0.5);
    s(inds) = [];
%     if length(inds) > 0
%         areas = [];
%         for ii = 1:length(inds)
%             areas(ii) = s(inds(ii)).Area;
%         end
%         toDiscard = inds(areas * M.scale < 10);
%         s(toDiscard) = [];
%     end
catch
end


if isempty(s)
    s = s_in;
end

