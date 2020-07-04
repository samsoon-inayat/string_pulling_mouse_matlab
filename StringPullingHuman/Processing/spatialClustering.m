function s = spatialClustering(s,frameSize,numClusters,M,varargin)

combs = nchoosek(1:length(s),2);
% s = findBoundary(s,frameSize);
% for ii = 1:size(combs,1)
%     s1 = s(combs(ii,1)); s2 = s(combs(ii,2));
%     s2points = [s2.xb s2.yb];
%     for jj = 1:length(s1.xb)
%         p1 = [s1.xb(jj) s1.yb(jj)];
%         dists(jj) = min(sqrt(sum((s2points - p1).^2,2)));
%     end
%     cdists(ii) = min(dists);
% end
% ind = find(cdists == min(cdists));
% 

for ii = 1:length(s)
    centroids(ii,:) = s(ii).Centroid;
end

% num_clusters = 2;
options = statset('UseParallel',0);
[cluster_idx, cluster_center] = kmeans(centroids,numClusters,'Options',options,'distance','sqEuclidean','Replicates',6);

uci = unique(cluster_idx); % find unique cluster numbers

% if length(uci) == length(s)
%     return;
% end

% find the length of each cluster
for ii = 1:length(uci)
    lencis(ii) = sum(cluster_idx == uci(ii));
end

% find the cluster with max number of elements which should be 2
uind = find(lencis == max(lencis));
ucioi = uci(uind);

% find indices of regions that belong to the same cluster
inds = find(cluster_idx == ucioi);

% indc = ismember(combs,inds','rows');
% dist_inds = cdists(indc)*M.scale;

% combine the regions using convex hull operation
[s1,sC] = combineRegions(s,sort(inds'),frameSize);

if nargin == 5
    s = s1;
    return;
end
   
% return reduced number of regions if the following criteria is met
if sC.Area < (M.TouchingHandsArea/0.95) & (sC.MajorAxisLength * M.scale) < 7
    plotStringAndRegions(100,[],[],M,{s1,s},[]);
    s = s1;
end
    