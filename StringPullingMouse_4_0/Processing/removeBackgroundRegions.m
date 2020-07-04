function s_r1 = removeBackgroundRegions(M,s_r1)

itd = [];
for ii = 1:length(s_r1)
    ts = s_r1(ii);
    Im = ts.cIn;
    In = Im & M.Ib;
    ns = findRegions(In);
    [d,o] = findDistsAndOverlaps(M,M.thisFrame,ts,ns);
    if o > 0.75
        itd = [itd ii];
    end
end
s_r1(itd) = [];
