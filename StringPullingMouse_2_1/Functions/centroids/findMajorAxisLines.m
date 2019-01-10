function rC = findMajorAxisLines(s,chs)


for ii = 1:length(s)
    thisS = s(ii);
    C(ii) = getSubjectFit(thisS.Centroid,thisS.MajorAxisLength,thisS.MinorAxisLength,thisS.Orientation);
end

axs = 1:size(chs,2);
ays = 1:size(chs,1);
for ii = 1:length(C)
    thisC = C(ii);
    x1 = thisC.Major_axis_xs(1); x2 = thisC.Major_axis_xs(2);
    y1 = thisC.Major_axis_ys(1); y2 = thisC.Major_axis_ys(2);
    m = (y2-y1)/(x2-x1);
    ys = m*axs - m*x1 + y1;
    thisC.Major_axis_linex = [axs;ys];
    xs = ((ays-y1) + m*x1)/m;
    thisC.Major_axis_liney = [xs;ays];
    rC(ii) = thisC;
end