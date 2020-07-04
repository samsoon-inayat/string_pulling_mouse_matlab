function s = selectRegionsSC (M,s,sel)

sL = length(s);

if sL == 1
    return;
end

sLeft = s;
if ~isempty(M.sLeft)
    sLeft(sL+1) = M.sLeft;
    for ii = 1:length(sLeft)
        centroidsL(ii,:) = sLeft(ii).Centroid;
        centroidsLY(ii,:) = sLeft(ii).Centroid(2);
        AreasL(ii,:) = sLeft(ii).Area;
    end

    cisL = kmeans_optimal(centroidsL);
    indsL = find(cisL == cisL(end));

    cisLY = kmeans_optimal(centroidsLY);
    indsLY = find(cisLY == cisLY(end));

    cisLA = kmeans_optimal(AreasL);
    indsLA = find(cisLA == cisLA(end));
else
    indsL = []; indsLY = []; indsLA = [];
end

sRight = s;
if ~isempty(M.sRight)
    sRight(sL+1) = M.sRight;
    for ii = 1:length(sRight)
        centroidsR(ii,:) = sRight(ii).Centroid;
        centroidsRY(ii,:) = sRight(ii).Centroid(2);
        AreasR(ii,:) = sRight(ii).Area;
    end
    cisR = kmeans_optimal(centroidsR);
    indsR = find(cisR == cisR(end));

    cisRY = kmeans_optimal(centroidsRY);
    indsRY = find(cisRY == cisRY(end));

    cisRA = kmeans_optimal(AreasR);
    indsRA = find(cisRA == cisRA(end));
else
    indsR = []; indsRY = []; indsRA = [];
end


inds = unique([indsL;indsR]);
inds = setdiff(inds,sL+1);

indsY = unique([indsLY;indsRY]);
indsY = setdiff(indsY,sL+1);

indsA = unique([indsLA;indsRA]);
indsA = setdiff(indsA,sL+1);

inds = unique([indsY;inds;indsA]);

if length(inds) == 1 & strcmp(sel,'hands')
    if s(inds).Area < (M.TouchingHandsArea/1.1)
        return;
    end
end
if length(inds) > 1
    s = s(inds);
end
