function out = get_masked_values_h(varsb,varName,ds_b,incr,threshold)

for ii = 1:length(ds_b)
    ii
    cmdTxt = sprintf('uv = varsb{ii}.%s;',varName);
    eval(cmdTxt)
%     figure(100000);clf;imagesc(ds_b{ii}.mean_mask);axis equal;colormap jet;colorbar;pause(0.5);
    if ~exist('threshold','var')
        out.b{ii} = uv(ds_b{ii}.mean_mask == 1);
    else
        out.b{ii} = uv(ds_b{ii}.mean_mask == 1 & uv > threshold(1) & uv < threshold(2));
    end
    uv = out.b{ii};
    out.minb(ii) = min(uv(:));    out.maxb(ii) = max(uv(:)); out.meanb(ii) = mean(uv(:)); out.medianb(ii) = median(uv(:));
    N_b(ii) = length(uv);
end
minb = out.minb; maxb = out.maxb;

N = max([N_b]);
k = ceil(log2(N)) + 1;
%%
barsb = []; barsw = [];
cdfb = []; cdfw = [];
minB = min([minb]);maxB = max([maxb]);
bins = (minB-incr):incr:(maxB+incr);
for ii = 1:length(ds_b)
    bd = out.b{ii}(:);
    [bar1,xs,bandwidth] = ksdensity(bd,bins);
%     [bandwidthb(ii),bar1,xs,cdf]=kde(bd,length(bins),minB-incr,maxB+incr);
%     [bar1 xs] = hist(bd,bins); 
    bar1 = 100*bar1/sum(bar1); cdf = cumsum(bar1);
    barsb = [barsb bar1'];
    cdfb = [cdfb cdf'];
end
out.xs = xs;
out.barsb = barsb;
out.mean_barsb = mean(barsb,2);
out.sem_barsb = std(barsb,[],2)./sqrt(length(ds_b));
out.cdfb = cdfb;
out.mean_cdfb = mean(cdfb,2);
out.sem_cdfb = std(cdfb,[],2)./sqrt(length(ds_b));
