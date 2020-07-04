function frames = reconstruct_from_PCs(pc,npcs,d)

frames = (pc.score(:,1:npcs)*pc.coeff(:,1:npcs)') + pc.mu;

frames = reshape(frames,pc.nrows,pc.ncols,pc.nFrames);

if d
    for ii = 1:size(frames,3)
        figure(1000);clf
        imagesc(frames(:,:,ii));
        axis equal; axis off;
        pause(0.1);
    end
end
n = 0;
rng(42);
[Zica, W, T, mu] = fastICA(frames',10);%,type,flag)
Zica = Zica';

