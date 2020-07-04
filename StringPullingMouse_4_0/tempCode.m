figure(1000);clf;
subplot 311
plot(frameNums(1:(end-1)),abs(shift(:,1)));

subplot 312
plot(frameNums(1:(end-1)),abs(shift(:,2)));

subplot 313
plot(frameNums(1:(end-1)),sqrt(sum(shift.^2,2)));















% thisFramem1 = frames{fn-1};
% Mm1 = populateM(handles,thisFramem1,fn-1);
% thisFramem1 = Mm1.thisFrame;
% 
% if ii == 1
%         rows = size(thisFrame,1);
%         columns = size(thisFrame,2);
%         img = double(reshape(thisFrame,rows*columns,3));
%     else
%         img = cat(2,img,double(reshape(thisFrame,rows*columns,3)));
%     end
% n = 0;
% 
% [coeff,score,latent,tsquared,explained,mu] = pca(img);
% transformedImagePixelList = img * coeff;
% 
% 
% for ii = 1:3:size(coeff,1)
%     % transformedImagePixelList is also an N by 3 matrix of values.
%     % Column 1 is the values of principal component #1, column 2 is the PC2, and column 3 is PC3.
%     % Extract each column and reshape back into a rectangular image the same size as the original image.
%     pca1Image = reshape(transformedImagePixelList(:,ii), rows, columns);
%     pca2Image = reshape(transformedImagePixelList(:,ii+1), rows, columns);
%     pca3Image = reshape(transformedImagePixelList(:,ii+2), rows, columns);
%     rgbImg = cat(3,pca1Image,pca2Image,pca3Image);
%     figure(500);clf;
%     imagesc(thisFrame);axis equal;
%     
%     figure(501);clf;
%     subplot 131;imagesc(pca1Image);axis equal;
%     subplot 132;imagesc(pca2Image);axis equal;
%     subplot 133;imagesc(pca3Image);axis equal;
%     pause(0.1);
%     n = 0;
% end
% % 




%% the code that I was writing to test things regarding shifts with phase-only correlation motion estimation
% shift = 10*fliplr(shift)

% xlims = [min(Cp.Ellipse_xs)-shift(1) max(Cp.Ellipse_xs)+shift(1)];
% ylims = [min(Cp.Ellipse_ys)-shift(2) max(Cp.Ellipse_ys)+shift(2)];
% 
% if xlims(1) < 1
%     xlims(1) = 1;
% end
% if xlims(2) > size(thisFrame(:,:,1),2)
%     xlims(2) = size(thisFrame(:,:,1),2)
% end
% if ylims(1) < 1
%     ylims(1) = 1;
% end
% if ylims(2) > size(thisFrame(:,:,1),1)
%     ylims(2) = size(thisFrame(:,:,1),1)
% end
% xlims = floor(xlims);
% ylims = floor(ylims);
% figure(20);clf;
% imagesc(thisFrame);axis equal
% rectangle('Position',[xlims(1) ylims(1) diff(xlims) diff(ylims)]);
% 
% subFrame = thisFrame(ylims(1):ylims(2),xlims(1):xlims(2),:);
% subFramem1 = thisFramem1(ylims(1):ylims(2),xlims(1):xlims(2),:);
% shift1 = POCShift(rgb2gray(subFrame),rgb2gray(subFramem1));
