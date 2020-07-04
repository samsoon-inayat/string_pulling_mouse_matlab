function fd = getFractalDimension(pcs,nrows,ncols)


for ii = 1:size(pcs,2)
    thisFrame = reshape(pcs(:,ii),nrows,ncols);
    fd(ii) = BoxCountfracDim((thisFrame)-min(thisFrame(:)));
end