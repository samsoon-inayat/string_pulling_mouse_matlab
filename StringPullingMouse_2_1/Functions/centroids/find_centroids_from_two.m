function C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp)

for ii = 1:length(s)
    areas(ii) = s(ii).Area;
end
scale = M.scale;
% minArea = areas(areas == min(areas));
% if minArea < (200*scale)
%     toDiscard = find(areas == min(areas));
%     s(toDiscard) = []; areas(toDiscard) = [];
%     C = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
%     return;
% end
rV1 = (s(1).Centroid(1)-xrp) + (s(1).Centroid(2)-yrp)*1i;
rV2 = (s(2).Centroid(1)-xrp) + (s(2).Centroid(2)-yrp)*1i;
lV1 = (s(1).Centroid(1)-xlp) + (s(1).Centroid(2)-ylp)*1i;
lV2 = (s(2).Centroid(1)-xlp) + (s(2).Centroid(2)-ylp)*1i;
magsR = [abs(rV1) abs(rV2)];
magsL = [abs(lV1) abs(lV2)];
indMinMagsR = find(magsR == min(magsR));
indMinMagsL = find(magsL == min(magsL));

if indMinMagsR == 1 && indMinMagsL == 2
    s(1).Hand = 'Right Hand'; s(2).Hand = 'Left Hand';
end
if indMinMagsR == 2 && indMinMagsL == 1
    s(2).Hand = 'Right Hand'; s(1).Hand = 'Left Hand';
end

if (indMinMagsR == 2 && indMinMagsL == 2) || (indMinMagsR == 1 && indMinMagsL == 1)
    thresh = 100*scale;
    if (areas(1) > thresh && areas(2) < thresh) 
        s = s(1);
        s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
        C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
    end
    if (areas(1) < thresh && areas(2) > thresh) 
        s = s(2);
        s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
        C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        return;
    end
    if areas(1) > thresh && areas(2) > thresh
        Crs1 = Cs{2}(2).Centroid;
%         CrS2 = Cs{2}(2).Centroid;
        d1 = abs(s(1).Centroid - Crs1);
        d2 = abs(s(2).Centroid - Crs1);
        if d2(1) < d1(1)
            s(1).Hand = 'Right Hand'; s(2).Hand = 'Left Hand';
        else
            s(2).Hand = 'Right Hand'; s(1).Hand = 'Left Hand';
        end
    end
end
C = s;
