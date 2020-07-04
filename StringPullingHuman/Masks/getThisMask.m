function Is = getThisMask(hsvFrame,theseColors,nrows,ncols,radius)
% hsvFrame = imsharpen(hsvFrame);
lFrame = double(reshape(hsvFrame,nrows*ncols,3));
% [Idx,D] = knnsearch(lFrame,theseColors,'K',NNs);
[cIdx,D] = rangesearch(lFrame,theseColors,radius);
% [Idx,D] = knnsearch(lFrame,uTC,'K',100);
tZ = zeros(size(lFrame,1),1);
for ii = 1:length(cIdx)
    for jj = 1:length(cIdx{ii})
        tZ(cIdx{ii}(jj)) = 1;
    end
end
Is = reshape(tZ,nrows,ncols);


%%old
% function Is = getThisMask(hsvFrame,theseColors,nrows,ncols,NNs)
% if ~exist('NNs','var')
%     NNs = 500;
% end
% lFrame = double(reshape(hsvFrame,nrows*ncols,3));
% [Idx,D] = knnsearch(lFrame,theseColors,'K',NNs);
% % [Idx,D] = knnsearch(lFrame,uTC,'K',100);
% tZ = zeros(size(lFrame,1),1);
% Idx = unique(Idx(:));
% tZ(Idx) = 1;
% Is = reshape(tZ,nrows,ncols);
% 
% 