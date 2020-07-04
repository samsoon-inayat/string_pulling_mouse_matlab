function cis = kmeans_optimal(vals)

if isrow(vals)
    vals = vals';
    RV = 1;
else
    RV = 0;
end

len = size(vals,1);
clust = zeros(len,len);
options = statset('UseParallel',0);
for ii = 1:len
    clust(:,ii) = kmeans(vals,ii,'emptyaction','singleton','Options',options,'distance','sqEuclidean','Replicates',6);
end
va = evalclusters(vals,clust,'CalinskiHarabasz');
OK = va.OptimalK;

cis = kmeans(vals,OK,'emptyaction','singleton','Options',options,'distance','sqEuclidean','Replicates',6);

if RV
    cis = cis';
end