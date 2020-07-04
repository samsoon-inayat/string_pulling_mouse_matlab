function mouseDance
global frames
figure(100);clf;

fns = [607 608 609 608 609 608 609 608 609 607];

for jj = 1:10
for ii = 1:length(fns)
    fn = fns(ii);
    imagesc(frames{fn});
    pause(0.1);
end
end
