function cvs = getColorValues(frame,mask)
inds = find(mask);
for ii = 1:3
    temp = frame(:,:,ii);
    vals = temp(inds);
    cvs(:,ii) = vals';
end