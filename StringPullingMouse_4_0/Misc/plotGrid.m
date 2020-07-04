function hf = plotGrid(fn,img,binsh, binsv)

hf = figure(fn);clf
imagesc(img);axis equal;
% axis off;
hold on;
csws = binsv(1,:);
cews = binsv(2,:);
cshs = binsh(1,:);
cehs = binsh(2,:);
for cc = 1:length(csws)
    for rr = 1:length(cshs)
        plot([csws(cc) csws(cc)], [cshs(rr) cehs(rr)],'r');
        plot([cews(cc) cews(cc)], [cshs(rr) cehs(rr)],'r');
        plot([csws(cc) cews(cc)], [cshs(rr) cshs(rr)],'r');
        plot([csws(cc) cews(cc)], [cehs(rr) cehs(rr)],'r');
    end
end