function C = findBoundary(C,frameSize)
maskz = zeros(frameSize(1),frameSize(2));
for ii = 1:length(C)
    mask = maskz;
    mask(C(ii).PixelIdxList) = 1;
    temp = bwboundaries(mask);
    try
        C(ii).xb = temp{1}(:,2);
        C(ii).yb = temp{1}(:,1);
    catch
    end
end