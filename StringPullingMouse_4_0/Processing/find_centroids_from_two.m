function s = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp)
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
    return;
end
if indMinMagsR == 2 && indMinMagsL == 1
    s(2).Hand = 'Right Hand'; s(1).Hand = 'Left Hand';
    return;
end

if (indMinMagsR == 2 && indMinMagsL == 2) || (indMinMagsR == 1 && indMinMagsL == 1)
    [drs,ors,bdrs,dars,dxrs,dyrs] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
    [dls,ols,bdls,dals,dxls,dyls] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
    [~,indR] = min(drs); [~,indL] = min(dls);
    [~,indRb] = min(bdrs); [~,indLb] = min(bdls);
    
    if indR == indL & indRb == indLb
        try
        if sum(ors>0.1) >= 1 && sum(ols>0.1) == 0
            ind = find(ors>0.1);
            s(3-ind).Hand = 'Left Hand'; s(ind).Hand = 'Right Hand';
            s = sanityCheck (M,s);
            return;
        end
        if sum(ols>0.1) >= 1 && sum(ors>0.1) == 0
            ind = find(ols>0.1);
            s(ind).Hand = 'Left Hand'; s(3-ind).Hand = 'Right Hand';
            s = sanityCheck (M,s);
            return;
        end
        catch
        end
        
        Cm = Cs{1};
        [dsm,osm,bdsm,dasm,dxsm,dysm] = findDistsAndOverlaps(M,M.thisFrame,Cm,s);
    
        if dxsm(1) < 0 & dxsm(2) > 0
            s(1).Hand = 'Left Hand'; s(2).Hand = 'Right Hand';
            s = sanityCheck (M,s);
            return;
        end
        if dxsm(1) > 0 & dxsm(2) > 0
            [~,ind] = min(dsm);
            s(ind).Hand = 'Left Hand'; s(3-ind).Hand = 'Right Hand';
            s = sanityCheck (M,s);
            return;
        end
        if dxsm(1) > 0 & dxsm(2) < 0
            s(2).Hand = 'Left Hand'; s(1).Hand = 'Right Hand';
            s = sanityCheck (M,s);
            return;
        end
        if dxsm(1) < 0 & dxsm(2) < 0
            [~,ind] = min(dsm);
            s(3-ind).Hand = 'Left Hand'; s(ind).Hand = 'Right Hand';
            s = sanityCheck (M,s);
            return;
        end
    end
    if indR ~= indL & indRb == indLb
        s(indR).Hand = 'Right Hand'; s(indL).Hand = 'Left Hand';
    end
    if indR == indL & indRb ~= indLb
        s(indRb).Hand = 'Right Hand'; s(indLb).Hand = 'Left Hand';
    end
    if indR ~= indL & indRb ~= indLb
        n = 0;
    end
end
    
function s = sanityCheck (M,s)
pxL = M.sLeft.Centroid(1);
pyL = M.sLeft.Centroid(2);

pxR = M.sRight.Centroid(1);
pyR = M.sRight.Centroid(2);

if strcmp(s(1).Hand,'Left Hand')
    xL = s(1).Centroid(1); yL = s(1).Centroid(2);
    xR = s(2).Centroid(1); yR = s(2).Centroid(2);
else
    xL = s(2).Centroid(1); yL = s(2).Centroid(2);
    xR = s(1).Centroid(1); yR = s(1).Centroid(2);
end

if pxL < xL
    xsL = linspace(pxL,xL,100);
    ysL = (((yL-pyL)/(xL-pxL))*(xsL-pxL))+pyL;
else
    xsL = linspace(xL,pxL,100);
    ysL = (((pyL-yL)/(pxL-xL))*(xsL-xL))+yL;
end

if pxR < xR
    xsR = linspace(pxR,xR,100);
    ysR = (((yR-pyR)/(xR-pxR))*(xsR-pxR))+pyR;
else
    xsR = linspace(xR,pxR,100);
    ysR = (((pyR-yR)/(pxR-xR))*(xsR-xR))+yR;
end

P = InterX([xsR;ysR],[xsL;ysL]);

if ~isempty(P)
    if strcmp(s(1).Hand,'Left Hand')
        s(1).Hand = 'Right Hand';
        s(2).Hand = 'Left Hand';
    else
        s(1).Hand = 'Left Hand';
        s(2).Hand = 'Right Hand';
    end
end
    
%     if indR == indL
%         [~,indR] = min(bdrs); [~,indL] = min(bdls);
%         if indR == indL
%             if min(drs) < min(dls)
%                 [~,ind] = min(drs);
%                 s(ind).Hand = 'Right Hand';
%                 s(3-ind).Hand = 'Left Hand';
%             else
%                 [~,ind] = max(dls);
%                 s(ind).Hand = 'Left Hand';
%                 s(3-ind).Hand = 'Right Hand';
%             end
%         else
%             s(indR).Hand = 'Right Hand';
%             s(indL).Hand = 'Left Hand';
%         end
%     else
%         s(indR).Hand = 'Right Hand';
%         s(indL).Hand = 'Left Hand';
%     end
%     if sum(ols) > 0 & sum(ors) == 0
%         ind  = find(ols>0);
%         s(ind).Hand = 'Left Hand';
%         s(3-ind).Hand = 'Right Hand';
%     end
%     if sum(ors) > 0 & sum(ols) == 0
%         ind  = find(ors>0);
%         s(ind).Hand = 'Right Hand';
%         s(3-ind).Hand = 'Left Hand';
%     end
%     if sum(ors) > 0 & sum(ols) > 0
%         if max(ors) > max(ols)
%             [~,ind] = max(ors);
%             s(ind).Hand = 'Right Hand';
%             s(3-ind).Hand = 'Left Hand';
%         else
%             [~,ind] = max(ors);
%             s(ind).Hand = 'Left Hand';
%             s(3-ind).Hand = 'Right Hand';
%         end
%     end
%     if ~isfield(s(1),'Hand')
%         [~,indR] = min(drs); [~,indL] = min(dls);
%         if indR == indL
%             [~,indR] = min(bdrs); [~,indL] = min(bdls);
%             if indR == indL
%                 if min(drs) < min(dls)
%                     [~,ind] = min(drs);
%                     s(ind).Hand = 'Right Hand';
%                     s(3-ind).Hand = 'Left Hand';
%                 else
%                     [~,ind] = max(dls);
%                     s(ind).Hand = 'Left Hand';
%                     s(3-ind).Hand = 'Right Hand';
%                 end
%             else
%                 s(indR).Hand = 'Right Hand';
%                 s(indL).Hand = 'Left Hand';
%             end
%         else
%             s(indR).Hand = 'Right Hand';
%             s(indL).Hand = 'Left Hand';
%         end
%     end
%     thresh = 100*scale;
%     if (areas(1) > thresh && areas(2) < thresh) 
%         s = s(1);
%         s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
%         C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
%         return;
%     end
%     if (areas(1) < thresh && areas(2) > thresh) 
%         s = s(2);
%         s = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
%         C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
%         return;
%     end
%     if areas(1) > thresh && areas(2) > thresh
%         [drs,ors,bdrs,dars] = findDistsAndOverlaps(M,M.thisFrame,M.sRight,s);
%         [dls,ols,bdls,dals] = findDistsAndOverlaps(M,M.thisFrame,M.sLeft,s);
% %         [rr,cc] = find(ds == min(ds(ds(:)>0)));
%         s =[];
%         n = 0;
% %         Crs1 = Cs{2}(2).Centroid;
% % %         CrS2 = Cs{2}(2).Centroid;
% %         d1 = abs(s(1).Centroid - Crs1);
% %         d2 = abs(s(2).Centroid - Crs1);
% %         if d2(1) < d1(1)
% %             s(1).Hand = 'Right Hand'; s(2).Hand = 'Left Hand';
% %         else
% %             s(2).Hand = 'Right Hand'; s(1).Hand = 'Left Hand';
% %         end
%     end
% end
% C = s;
