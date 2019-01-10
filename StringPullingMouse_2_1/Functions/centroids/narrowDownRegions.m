function s = narrowDownRegions(s1,s2)

[d,o] = findDistsAndOverlaps([],[],s1,s2);

ind = 1;
for ii = 1:size(o,2)
    oC = o(:,ii);
    if sum(oC>0.1) == 1
        s(ind) = s1(oC>0.1);
        ind = ind + 1;
    end
end

if ~exist('s','var')
    s = s1;
end