function ds = get_mean_mask(ds,ent,pcs,ics)


thisFrame = max(ics.ics.Z',[],2);
thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
figure(200);clf;
imagesc(thisFrame);colorbar
axis equal

frame = thisFrame;
nstd = 0;
threshold = mean(frame(:)) + nstd * std(frame(:));

mask = zeros(size(frame)); 
mask(frame > threshold) = 1;

maskM = mask;

thisFrame = min(ics.ics.Z',[],2);
thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
figure(200);clf;
imagesc(thisFrame);colorbar
axis equal

frame = thisFrame;
nstd = 0;
threshold = mean(frame(:)) + nstd * std(frame(:));

mask = zeros(size(frame)); 
mask(frame < threshold) = 1;

mask = maskM | mask;

figure(200);clf;
imagesc(mask);
axis equal
pause(0.3);
ds.mean_mask = mask;


