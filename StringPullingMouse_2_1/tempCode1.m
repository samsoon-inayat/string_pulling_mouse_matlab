figure(1000);clf;
I = (rgb2gray(thisFrame));
points = detectMSERFeatures(I);
imshow(thisFrame); hold on;
plot(points);