figure(10);clf;
imagesc(thisFramem1);axis equal;
rect = floor(getrect(gca));
rows = rect(2):(rect(2)+rect(4));
rows(rows>handles.md.frameSize(1)) = [];
rows(rows<1) = [];
cols = rect(1):(rect(1)+rect(3));
cols(cols>handles.md.frameSize(2)) = [];
cols(cols<1) = [];
rect = [min(cols) min(rows) max(cols)-min(cols) max(rows)-min(rows)];
% points = detectSURFFeatures(rgb2gray(thisFrame));
% points = detectSURFFeatures(rgb2gray(thisFrame),'ROI',rect);
% % [regions,cc] = detectMSERFeatures(rgb2gray(thisFramem1),'ROI',rect,'ThresholdDelta',7);
% 
% [features,validPoints] = extractFeatures(rgb2gray(thisFrame),points);
% figure(10);clf;
% imagesc(thisFrame);axis equal;
% hold on;
% plot(validPoints);

I1 = rgb2gray(thisFrame);
I2 = rgb2gray(thisFramem1);
% points1 = detectSURFFeatures(I1,'ROI',rect);
% points2 = detectSURFFeatures(I2,'ROI',rect);
points1 = detectMSERFeatures(I1,'ROI',rect,'ThresholdDelta',0.1);
points2 = detectMSERFeatures(I2,'ROI',rect,'ThresholdDelta',0.1);
[f1,vpts1] = extractFeatures(I1,points1);
[f2,vpts2] = extractFeatures(I2,points2);
indexPairs = matchFeatures(f1,f2) ;
matchedPoints1 = vpts1(indexPairs(:,1));
matchedPoints2 = vpts2(indexPairs(:,2));
figure(10);clf;
showMatchedFeatures(I1,I2,matchedPoints1,matchedPoints2);
legend('matched points 1','matched points 2');





L=logical(fmaske);
box=regionprops(L,'Area', 'BoundingBox'); 

box.BoundingBox

thisFramem1 = frames{fn-1};
Mm1 = populateM(handles,thisFramem1,fn-1);

RGB = thisFrame;
fmask = Cp.mask;
fmaskc = expandOrCompressMask(fmask,0.75);
fmaske = expandOrCompressMask(fmask,1.25);
fmaske = ~fmaske;

thisFramehsv = rgb2hsv(thisFrame);
bw = activecontour(rgb2gray(thisFrame),fmaske);
figure(10);clf;
im = imoverlay(thisFrame,bw);
imagesc(im);
axis equal;

I = imread('airplane.jpg');

foregroundInd = find(fmaskc);
backgroundInd = find(fmaske);
L = superpixels(RGB,500);
BW = lazysnapping(RGB,L,foregroundInd,backgroundInd);
maskedImage = RGB;
figure; 
imshow(maskedImage)

figure(10);clf;
im = rgb2gray(thisFrame);
bw = find_mask_threshold(double(im),0);
imagesc(bw);colormap gray
axis equal;



Y = fft2(rgb2gray(thisFrame));
figure(10);clf;
imagesc(abs(fftshift(Y)));
axis equal