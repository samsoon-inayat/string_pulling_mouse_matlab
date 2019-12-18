function fest = find_dominant_frequency (t,x,Fs)

x = x - mean(x);         
[y,f_scale] = periodogram(x,[],512,Fs);
[~,k] = max(y); % find maximum
fest = f_scale(k); % dominant frequency estimate
