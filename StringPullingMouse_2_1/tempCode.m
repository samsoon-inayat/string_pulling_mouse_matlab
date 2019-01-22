thisFrameB = frames{fn};
figure(100);clf
imagesc(thisFrameB);
axis equal
xlim([zoomWindow(1) zoomWindow(3)]);
ylim([zoomWindow(2) zoomWindow(4)]);

mask = max(igTF,[],3);% - mean(igTF,3);
% mask1 = max(mask,[],3);
% mask1 = find_mask_threshold(mask,1);
figure(100);clf;
imagesc(mask);axis equal;