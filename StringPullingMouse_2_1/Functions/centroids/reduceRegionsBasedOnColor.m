function regions = reduceRegionsBasedOnColor(thisFrame,regions,cs)
cs = (cs(:,4:6)); % columns 4:6 for rgb
inds = [];
for ii = 1:regions.Count
    thisPixelList = regions.PixelList{ii};
    pixelVals = [];
    temp = thisFrame(:,:,1);
    pixelVals(:,1) = temp(sub2ind(size(thisFrame(:,:,1)),thisPixelList(:,2),thisPixelList(:,1)));
    temp = thisFrame(:,:,2);
    pixelVals(:,2) = temp(sub2ind(size(thisFrame(:,:,1)),thisPixelList(:,2),thisPixelList(:,1)));
    temp = thisFrame(:,:,1);
    pixelVals(:,3) = temp(sub2ind(size(thisFrame(:,:,1)),thisPixelList(:,2),thisPixelList(:,1)));
    [Idx,D] = knnsearch(pixelVals,cs,'K',10);
    Idx = unique(Idx(:));
    lens(ii,:) = [length(Idx) size(pixelVals,1)];
    if length(Idx) < 0.75 * size(pixelVals,1)
        inds = [inds ii];
    end
end
regions(inds) = [];

%     [h,p] = ttest2(pixelVals(:,2),cs(:,2));
%     allCs = [pixelVals;cs];
%     [cluster_idx, cluster_center] = kmeans(allCs,2,'distance','sqEuclidean','Replicates',2);
%     d(ii) = sqrt(sum((diff(cluster_center)).^2));
%     if h
%         inds = [inds ii];
%     end
%     for jj = 1:2
%         [h(jj),p] = ttest2(pixelVals(:,jj),cs(:,jj));
%     end
%     if sum(h) == 2
%         inds = [inds ii];
%     end
%     figure(100);clf;subplot 121;hist(pixelVals(:,1));subplot 122;hist(cs(:,1));