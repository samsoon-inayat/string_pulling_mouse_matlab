function sms = find_spatial_measures(thisFrame)

sms{1} = find_FD(thisFrame);
sms{2} = entropy(mat2gray(thisFrame)); 
sms{3} = estimate_sharpness(mat2gray(thisFrame));

thisFrame01 = mat2gray(thisFrame); mtf = mean(thisFrame01(:)); stf = std(thisFrame01(:)); thresh = mtf + 0*stf;
sms{4} = sum(thisFrame01(:) > thresh)/numel(thisFrame);