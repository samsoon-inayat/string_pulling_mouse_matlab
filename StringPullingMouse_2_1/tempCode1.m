ts = regionprops(temp,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema');

for ii = 1:length(ts)
    centroids(ii,:) = ts(ii).Centroid;
end


options = statset('UseParallel',0);
[cluster_idx, cluster_center] = kmeans(centroids,2,'Options',options,'distance','sqEuclidean','Replicates',6);