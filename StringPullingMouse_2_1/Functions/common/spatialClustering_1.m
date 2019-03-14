function s = spatialClustering_1(s,frameSize,numClusters,M,varargin)


s = findBoundary(s,frameSize);
combs = nchoosek(1:length(s),2);
for ii = 1:size(combs,1)
    s1 = s(combs(ii,1)); s2 = s(combs(ii,2));
    s2points = [s2.xb s2.yb];
    for jj = 1:length(s1.xb)
        p1 = [s1.xb(jj) s1.yb(jj)];
        dists(jj) = min(sqrt(sum((s2points - p1).^2,2)));
    end
    cdists(ii) = min(dists);
end
ind = find(cdists == min(cdists));


for ii = 1:length(s)
    centroids(ii,:) = s(ii).Centroid;
end

num_clusters = 2;
options = statset('UseParallel',0);
% [cluster_idx, cluster_center] = kmeans(centroids,numClusters,'Options',options,'distance','sqEuclidean','Replicates',6);
[cluster_idx, cluster_center] = kmeans_opt(centroids);

uci = unique(cluster_idx);

if length(uci) == length(s)
    return;
end
so = []; sii = 1;
for ii = 1:length(uci)
    len = sum(cluster_idx == uci(ii));
    if len == 2
        inds = find(cluster_idx == uci(ii));
        [s1,sC] = combineRegions(s,sort(inds'),frameSize);
        if sC.Area < (M.TouchingHandsArea/0.95) & (sC.MajorAxisLength * M.scale) < 7
            so(sii) = sC;
            sii = sii + 1;
        end
    end
    if len == 3
        inds = find(cluster_idx == uci(ii));
        [s1,sC] = combineRegions(s,sort(inds'),frameSize);
        if sC.Area < (M.TouchingHandsArea/0.95) & (sC.MajorAxisLength * M.scale) < 7
            so(sii) = sC;
            sii = sii + 1;
        end
    end
end

return;
uind = find(lencis == max(lencis));
ucioi = uci(uind);

inds = find(cluster_idx == ucioi);
% if length(s) < 5
%     if isequal(sort(combs(ind,:)),sort(inds'))
%         s1 = combineRegions(s,combs(ind,:),frameSize);
%         for ii = 1:length(s1)
%             areas(ii) = s1(ii).Area;
%             ML(ii) = s1(ii).MajorAxisLength;
%         end
%         ag = find(areas > M.TouchingHandsArea);
%         mg = find(ML > 5);
%         if length(ag) == 0 & length(mg) == 0
%             s = s1;
%         end
%     end
% else
    indc = ismember(combs,inds','rows');
    dist_inds = cdists(indc)*M.scale;
%     if dist_inds < 1                                
        [s1,sC] = combineRegions(s,sort(inds'),frameSize);
%         s = s1;
%         return;
%     else
%         return;
%     end
%     
    if nargin == 5
        s = s1;
        return;
    end
%   
    if sC.Area < (M.TouchingHandsArea/0.95) & (sC.MajorAxisLength * M.scale) < 7
        plotStringAndRegions(100,[],[],M,{s1,s},[]);
        s = s1;
%         displayMessage(M,sprintf('Combined regions %d and %d',inds(1),inds(2)));
        
    end
% end
%     