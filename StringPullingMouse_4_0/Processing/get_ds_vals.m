function out = get_ds_vals(f)
f = double(f);
out.mean = mean(f,3);
out.median = median(f,3);
out.mode = mode(f,3);
out.standard_deviation = std(f,[],3);
out.skewness = skewness(f,[],3);
out.kurtosis = kurtosis(f,[],3);