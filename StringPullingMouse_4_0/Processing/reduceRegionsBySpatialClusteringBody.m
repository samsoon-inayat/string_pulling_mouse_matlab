function s_r1 = reduceRegionsBySpatialClusteringBody(M,s_r1,varargin)

while 1
    if strcmp(get(M.pushbutton_stop_processing,'visible'),'off')
        axes(M.axes_main);cla;
        s_r1 = [];
        break;
    end
    psL = length(s_r1);
    if psL == 1
        break;
    end
    s_r1 = thisspatialClustering(s_r1,size(M.thisFrame(:,:,1)),psL-1,M,1);
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    title(M.fn);
    pause(0.15);
%     if psL == length(s_r1) | length(s_r1) == 2
%         break;
%     end
end

function s = thisspatialClustering(s,frameSize,numClusters,M,varargin)

combs = nchoosek(1:length(s),2);
for ii = 1:length(s)
    centroids(ii,:) = s(ii).Centroid;
end

options = statset('UseParallel',0);
[cluster_idx, cluster_center] = kmeans(centroids,numClusters,'Options',options,'distance','sqEuclidean','Replicates',6);

uci = unique(cluster_idx); % find unique cluster numbers

% find the length of each cluster
for ii = 1:length(uci)
    lencis(ii) = sum(cluster_idx == uci(ii));
end

% find the cluster with max number of elements which should be 2
uind = find(lencis == max(lencis));
ucioi = uci(uind);

% find indices of regions that belong to the same cluster
inds = find(cluster_idx == ucioi);

% combine the regions using convex hull operation
[s1,sC] = combineRegions(s,sort(inds'),frameSize);

s = s1;

    