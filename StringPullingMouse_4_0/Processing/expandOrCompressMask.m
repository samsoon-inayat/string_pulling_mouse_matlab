function mask = expandOrCompressMask (mask,ec)

temp = bwboundaries(mask);
boundary = fliplr(temp{1});
[ geom, iner, cpmo ] = polygeom( boundary(:,1), boundary(:,2) );
x_cent = geom(2); y_cent = geom(3);
cent = x_cent + 1i * y_cent;
for ii = 1:size(boundary,1)
    thisP = boundary(ii,1) + 1i * boundary(ii,2);
    diffV = thisP - cent;
    l_diffV = abs(diffV);
    nl_diffV = ec * l_diffV;
    ang = angle(diffV);
    nThisP = (nl_diffV * cos(ang) + 1i *nl_diffV*sin(ang)) + cent;
    nBoundary(ii,1) = real(nThisP); nBoundary(ii,2) = imag(nThisP);
end

mask = poly2mask(nBoundary(:,1),nBoundary(:,2),size(mask,1),size(mask,2));
