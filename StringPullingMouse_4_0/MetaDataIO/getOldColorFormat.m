function oCols = getOldColorFormat(tem,lg)

if ~exist('nstd', 'var')
    nstd = -0.25;
end

if ~exist('lg', 'var')
    lg = 1;
end

if lg
    htem = tem(:,1:3); 
    mhtem = mean(htem); shtem = std(htem);
    inds1 = find(htem(:,1)>(mhtem(1)+nstd*shtem(3)));
    inds2 = find(htem(:,2)>(mhtem(2)+nstd*shtem(3)));
    inds3 = find(htem(:,3)>(mhtem(3)+nstd*shtem(3)));
    inds = intersect(inds1,inds2);
    inds = intersect(inds,inds3);
    oCols(1,:) = mean(htem(inds,1:3));
    oCols(2,:) = std(htem(inds,1:3));

    htem = tem(:,4:6);
    mhtem = mean(htem); shtem = std(htem);
    inds1 = find(htem(:,1)>(mhtem(1)+nstd*shtem(3)));
    inds2 = find(htem(:,2)>(mhtem(2)+nstd*shtem(3)));
    inds3 = find(htem(:,3)>(mhtem(3)+nstd*shtem(3)));
    inds = intersect(inds1,inds2);
    inds = intersect(inds,inds3);
    oCols(3,:) = mean(htem(inds,1:3));
    oCols(4,:) = std(htem(inds,1:3));
else
    htem = tem(:,1:3); 
    mhtem = mean(htem); shtem = std(htem);
    inds1 = find(htem(:,1)<(mhtem(1)+nstd*shtem(3)));
    inds2 = find(htem(:,2)<(mhtem(2)+nstd*shtem(3)));
    inds3 = find(htem(:,3)<(mhtem(3)+nstd*shtem(3)));
    inds = intersect(inds1,inds2);
    inds = intersect(inds,inds3);
    oCols(1,:) = mean(htem(inds,1:3));
    oCols(2,:) = std(htem(inds,1:3));

    htem = tem(:,4:6);
    mhtem = mean(htem); shtem = std(htem);
    inds1 = find(htem(:,1)<(mhtem(1)+nstd*shtem(3)));
    inds2 = find(htem(:,2)<(mhtem(2)+nstd*shtem(3)));
    inds3 = find(htem(:,3)<(mhtem(3)+nstd*shtem(3)));
    inds = intersect(inds1,inds2);
    inds = intersect(inds,inds3);
    oCols(3,:) = mean(htem(inds,1:3));
    oCols(4,:) = std(htem(inds,1:3));
end