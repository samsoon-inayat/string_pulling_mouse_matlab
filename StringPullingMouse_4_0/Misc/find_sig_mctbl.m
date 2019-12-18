function mt1 = find_sig_mctbl(mt,varargin)
if nargin == 2
    pvalcol = varargin{1};
else
    pvalcol = 5;
end
mt = mt(mt{:,pvalcol}<0.05,:);
pvals = mt{:,pvalcol};
upvals = unique(pvals);
for ii = 1:length(upvals)
    ind = find(upvals(ii) == pvals);
    mt1(ii,:) = mt(ind(1),:);
end
if ~exist('mt1','var')
    mt1 = mt;
end