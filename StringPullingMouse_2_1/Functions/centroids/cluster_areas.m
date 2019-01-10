function [clus,ii] = cluster_areas (areas,n)
clus = kmeans(areas',n);
ucn = unique(clus);
for ii = 1:length(ucn)
    nucn(ii) = sum(clus == ucn(ii));
end
ind = find(nucn == 2);
if length(ind) > 1 || isempty(ind)
    [clus,ii] = cluster_areas(areas,n+1);
else
    ii = find(clus == ucn(ind));
end
