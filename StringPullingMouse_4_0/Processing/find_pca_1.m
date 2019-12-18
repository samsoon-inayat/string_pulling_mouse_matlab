function pca1Image = find_pca_1(thisFrame)
rows = size(thisFrame,1);
columns = size(thisFrame,2);
img = double(reshape(thisFrame,rows*columns,3));
img = cat(2,img,double(reshape(thisFrame,rows*columns,3)));
[coeff,score,latent,tsquared,explained,mu] = pca(img);
transformedImagePixelList = img * coeff;
pca1Image = reshape(transformedImagePixelList(:,1), rows, columns);
