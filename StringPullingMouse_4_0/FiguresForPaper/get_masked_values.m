function out = get_masked_values(varsb,varsw,varName,ds_b,ds_w,incr,inverted)

for ii = 1:length(ds_b)
    ii
    cmdTxt = sprintf('uv = varsb{ii}.%s;',varName);
    eval(cmdTxt)
%     figure(100000);clf;imagesc(ds_b{ii}.mean_mask);axis equal;colormap jet;colorbar;pause(0.5);
    if exist('inverted','var')
        out.b{ii} = uv(ds_b{ii}.mean_mask == 0);
    else
        out.b{ii} = uv(ds_b{ii}.mean_mask == 1);
    end
    uv = out.b{ii};
    out.minb(ii) = min(uv(:));    out.maxb(ii) = max(uv(:)); out.meanb(ii) = mean(uv(:)); out.medianb(ii) = median(uv(:));
    N_b(ii) = length(uv);
    cmdTxt = sprintf('uv = varsw{ii}.%s;',varName);
    eval(cmdTxt)
%     figure(100000);clf;imagesc(ds_w{ii}.mean_mask);axis equal;colormap jet;colorbar;pause(0.5);
    if exist('inverted','var')
        out.w{ii} = uv(ds_w{ii}.mean_mask == 0);
    else
        out.w{ii} = uv(ds_w{ii}.mean_mask == 1);
    end
    uv = out.w{ii};
    out.minw(ii) = min(uv(:));    out.maxw(ii) = max(uv(:)); out.meanw(ii) = mean(uv(:)); out.medianw(ii) = median(uv(:));
    N_w(ii) = length(uv);
end

minb = out.minb; maxb = out.maxb;
minw = out.minw; maxw = out.maxw;

N = max([N_b N_w]);
k = ceil(log2(N)) + 1;
%%
barsb = []; barsw = [];
cdfb = []; cdfw = [];
minB = min([minb minw]);maxB = max([maxb maxw]);
bins = (minB-incr):incr:(maxB+incr);
for ii = 1:length(ds_b)
    bd = out.b{ii}(:);
    [bar1,xs,bandwidth] = ksdensity(bd,bins);
%     [bandwidthb(ii),bar1,xs,cdf]=kde(bd,length(bins),minB-incr,maxB+incr);
%     [bar1 xs] = hist(bd,bins); 
    bar1 = 100*bar1/sum(bar1); cdf = cumsum(bar1);
    barsb = [barsb bar1'];
    cdfb = [cdfb cdf'];
%     plot(bins,bar1,'k');
    bd = out.w{ii}(:);
    [bar1,xs,bandwidth] = ksdensity(bd,bins);
%     [bandwidthw(ii),bar1,xs,cdf]=kde(bd,length(bins),minB-incr,maxB+incr);
%     [bar1 xs] = hist(bd,bins); 
    bar1 = 100*bar1/sum(bar1); cdf = cumsum(bar1);
    barsw = [barsw bar1'];
    cdfw = [cdfw cdf'];
%     plot(bins,bar1,'b');
end
out.xs = xs;
out.barsb = barsb;
out.barsw = barsw;
out.mean_barsb = mean(barsb,2);
out.mean_barsw = mean(barsw,2);
out.sem_barsb = std(barsb,[],2)./sqrt(5);
out.sem_barsw = std(barsw,[],2)./sqrt(5);
out.cdfb = cdfb;
out.cdfw = cdfw;
out.mean_cdfb = mean(cdfb,2);
out.mean_cdfw = mean(cdfw,2);
out.sem_cdfb = std(cdfb,[],2)./sqrt(5);
out.sem_cdfw = std(cdfw,[],2)./sqrt(5);