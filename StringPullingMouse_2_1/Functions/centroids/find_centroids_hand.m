function C = find_centroids_hand(handles,M,fn,type,masks,thisFrame,Cs)
Im = masks.Im; Ih = masks.Ih; Is = masks.Is; Ie = masks.Ie;
M.fn = fn;
if strcmp(type,'hands')
    C = findHandsMethod2_1(handles,M,fn,type,masks,thisFrame,Cs);
    C(1).manual = 0;
    C(2).manual = 0;
    return;
end
% if strcmp(type,'handsNoInitialValue')
%     earsC = Cs{2};
%     xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
%     xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);
%     Cm = Cs{1};
%     tF = zeros(size(Im));
%     [allxs,allys] = meshgrid(1:size(tF,2),1:size(tF,1));
%     In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);
%     startingVal = 0.9;
%     while 1
%         In = expandOrCompressMask(In,startingVal);
%         chs = Ih&In;
%         masks.In = In; masks.chs = chs; masks.thisFrame = thisFrame;
%         iThisFrame = double(rgb2gray(thisFrame));
%         iThisFrame = iThisFrame/max(iThisFrame(:));
%         chs = bwconvhull(chs,'objects');
%         s = regionprops(chs,iThisFrame,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
%             'Orientation','WeightedCentroid','Perimeter','EulerNumber','Eccentricity','Extent','Extrema');
%         s = selectAppropriateRegions(M,Cs,masks,s);
%         if length(s) == 1
%             C = find_centroids_coincident(s);
%         end
%         if length(s) > 2
%             startingVal = startingVal - 0.02;
%         else
%             break;
%         end
%         if startingVal < 0.5
%             break;
%         end
%     end
%     if length(s) == 1
%         C = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
%         return;
%     end
%     for ii = 1:length(s)
%         areas(ii) = s(ii).Area;
%         centroidYs(ii) = s(ii).Centroid(2);
%     end
%     if sum(areas > 1500)>0
%         toDiscard = find(areas == min(areas));
%         s(toDiscard) = [];areas(toDiscard) = []; centroidYs(toDiscard) = [];
%     end
%     if length(s) == 1
%         C = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
%         return;
%     end
%     if length(s) == 2
%         C = find_centroids_from_two(M,Cs,s,areas,xrp,yrp,xlp,ylp);
%         return;
%     end
%     C = [];
%     return;
% end
% % 
% % if strcmp(type,'handsOld')
% %     scale = M.scale;
% %     [xlp ylp] = getxyFromR(M,fn-1,'Left Hand');
% %     [xrp yrp] = getxyFromR(M,fn-1,'Right Hand');
% %     xlp = xlp - M.zw(1); xrp = xrp - M.zw(1);
% %     ylp = ylp - M.zw(2); yrp = yrp - M.zw(2);
% %     if isempty(xlp) || isempty(xrp)
% %         C = [];
% %         return;
% %     end
% %     Cm = Cs{1};
% %     tF = zeros(size(Im));
% %     [allxs,allys] = meshgrid(1:size(tF,2),1:size(tF,1));
% %     In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);
% %     In = expandOrCompressMask(In,0.75);
% %     chs = Ih&In;
% %     masks.In = In; masks.chs = chs; masks.thisFrame = thisFrame;
% %     iThisFrame = double(rgb2gray(thisFrame));
% %     iThisFrame = iThisFrame/max(iThisFrame(:));
% %     chs = bwconvhull(chs,'objects');
% %     s = regionprops(chs,iThisFrame,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
% %         'Orientation','WeightedCentroid','Perimeter','EulerNumber','Eccentricity','Extent','Extrema');
% %     s = selectAppropriateRegions(M,Cs,masks,s);
% %     for ii = 1:length(s)
% %         areas(ii) = s(ii).Area;
% %         centroidYs(ii) = s(ii).Centroid(2);
% %     end
% %     if length(s) == 2
% %         C = find_centroids_from_two(M,Cs,s,areas,xrp,yrp,xlp,ylp);
% %         return;
% %     end
% %     if length(s) == 3
% %         toDiscard = find(areas == min(areas));
% %         s(toDiscard) = [];areas(toDiscard) = []; centroidYs(toDiscard) = [];
% %         C = find_centroids_from_two(M,Cs,s,areas,xrp,yrp,xlp,ylp);
% %         return;
% %     end
% %    
% % %     toDiscard = find(centroidYs>800);
% % %     s(toDiscard) = [];areas(toDiscard) = []; centroidYs(toDiscard) = [];
% % %     
% %     if isempty(s)
% %         disp('s is empty check function find_centroids');
% %         error('Nothing detected for hands ... check masks and refine them');
% %     end
% %     if length(s) == 1
% %         C = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
% %         return;
% %     end
% %     if length(areas)==3
% %         toDiscard = find(areas == min(areas));
% %         s(toDiscard) = [];
% %         areas(toDiscard) = [];
% %     end
% % %     if length(areas)>3
% % %         [clus,toDiscard] = cluster_areas(areas,2);
% % %         s(toDiscard) = [];
% % %         areas(toDiscard) = [];
% % %     end
% %     if length(s) == 1
% %         C = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
% %         return;
% %     end
% %     if length(s) > 2
% %         error('check function find_centroids');
% %     end
% %     C = find_centroids_from_two(M,Cs,s,areas,xrp,yrp,xlp,ylp);
% %     return;
% % end
