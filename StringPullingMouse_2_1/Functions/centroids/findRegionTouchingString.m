function [ind,cert] = findRegionTouchingString(M,Cs,masks,s)
thisFrame = masks.thisFrame;
iThisFrame = masks.iThisFrame;
chs = masks.Is;
In = masks.In;
cIn = expandOrCompressMask(In,0.95);
[rrs ccs] = find(cIn==1);
temp = zeros(size(cIn));
mrrs = min(rrs);
temp(1:mrrs,:) = 1;
chs = chs & temp;
chs = bwconvhull(chs,'objects');


earsC = Cs{2};
xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);

ss = regionprops(chs,iThisFrame,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
        'Orientation','WeightedCentroid','Perimeter','EulerNumber','Eccentricity','Extent','Extrema');

for ii = 1:length(ss)
    areas(ii) = ss(ii).Area;
end

sss = ss(areas == max(areas));
ML = findMajorAxisLines(sss,chs);
lma2 = floor(sqrt(sum((diff(ML.Minor_axis_xs).^2+diff(ML.Minor_axis_ys).^2))))/2;
temp = zeros(size(chs));
xs = round(ML.Major_axis_liney(1,:));
ys = ML.Major_axis_liney(2,:);
for ii = 1:length(xs);
    temp(ys(ii),xs(ii)) = 1;
end


combs = nchoosek(1:length(ML),2);

for ii = 1:size(combs,1)
    ML1 = ML(combs(ii,1));
    ML2 = ML(combs(ii,2));
    P(ii,:) = InterX(ML1.Major_axis_line,ML2.Major_axis_line)';
end

for jj = 1:size(P,1)
    tP = P(jj,:);
    for ii = 1:length(s)
        tempI = zeros(size(chs));
        thisS = s(ii);
        tempI(thisS.PixelIdxList) = 1;
        tempI = bwconvhull(tempI,'objects');
        bo = bwboundaries(tempI);
        centroid = thisS.Centroid;
        dis(jj,ii) = sqrt(sum((tP-centroid).^2));
        [in,on] = inpolygon(tP(1),tP(2),bo{1}(:,2),bo{1}(:,1));
        inp(jj,ii) = in;
    end
end

ind1 = find(dis == min(dis));
ind2 = find(inp);

if ind1 == ind2
    ind = ind1;
    cert = 1;
else
    ind = ind1;
    cert = 0.5;
end

