function FD = find_FD(thisFrame,bw)
thisFrame = mat2gray(thisFrame);
meanF = mean(thisFrame(:)); stdF = std(thisFrame(:));
threshold = meanF + 0*stdF;
if exist('bw','var')
    mask = imbinarize(thisFrame,threshold,'ForegroundPolarity','dark');
else
    mask = imbinarize(thisFrame,threshold);
end
FD = BoxCountfracDim(mask);
% figure(1000);clf;
% subplot 121;
% imagesc(thisFrame);axis equal;colorbar;
% subplot 122;
% imagesc(mask);axis equal;colorbar;
% n = 0;