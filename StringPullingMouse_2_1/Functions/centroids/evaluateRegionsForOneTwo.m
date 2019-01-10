function [ret C] = evaluateRegionsForOneTwo(M,Cs,masks,s)
thisFrame = masks.thisFrame;
fn = M.fn;
[xlp ylp] = getxyFromR(M,fn-1,'Left Hand');
[xrp yrp] = getxyFromR(M,fn-1,'Right Hand');
xlp = xlp - M.zw(1); xrp = xrp - M.zw(1);
ylp = ylp - M.zw(2); yrp = yrp - M.zw(2);

ret = length(s);
C = [];

% for ii = 1:length(s)
%     areas(ii) = s(ii).Area;
% end
% 
% inds = areas > 2500;
% 
% if sum(inds) == 1
%     s = s(inds);
% end

if length(s) == 1
    C = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
    ret = -1; 
end

if length(s) == 2
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    C = find_centroids_from_two(M,Cs,s,areas,xrp,yrp,xlp,ylp);
    ret = -1; 
end


n = 0;