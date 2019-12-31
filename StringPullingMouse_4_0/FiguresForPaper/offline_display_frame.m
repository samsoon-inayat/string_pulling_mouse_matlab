theseFrames = frames_w{1};

for ii = 1:length(theseFrames)
    thisFrame = theseFrames{ii};
    figure(1000);clf;
    imagesc(thisFrame);
    axis equal;
    pause(0.05);
end