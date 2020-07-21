function ds = set_mean_mask(ds)

% ds.mean_mask_from_diff = ds.mean_mask;
% ds.mean_mask_from_ica = maskc;
% ds.mean_mask_ones = ones(size(maskc));

mask = ds.mean_mask_from_diff;
rp = regionprops(mask);
hby4 = floor(rp.BoundingBox(4)/2);
bb = floor(rp.BoundingBox);
cc = floor(rp.Centroid);
bb(bb<=0) = 1;
maskz = zeros(size(mask));
% maskz(bb(2):cc(2),bb(1):(bb(1)+bb(3)-1)) = 1;
maskz((cc(2)):(bb(2)+bb(4)-1),bb(1):(bb(1)+bb(3)-1)) = 1;

ds.mean_mask = maskz & mask;
% ds.mean_mask = mask;


figure(100);clf;
subplot 141;imagesc(ds.mean_mask);axis equal;
subplot 142;imagesc(ds.mean_mask_from_diff);axis equal;
% subplot 143;imagesc(ds.mean_mask_from_ica);axis equal;
% subplot 144;imagesc(ds.mean_mask_ones);axis equal;
pause(0.01);

