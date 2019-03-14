function saveRegionsMask(handles,C,fn,object)
global cmasks;
zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;
masksMap = getParameter(handles,'Masks Order');
ind = find(strcmp(masksMap,object));

mask = zeros(handles.md.frameSize);
mask = mask(zw(2):zw(4),zw(1):zw(3));
for ii=1:length(C)
    thesePixels = C(ii).PixelIdxList;
    mask(thesePixels) = 1;
end

pMask = cmasks(:,fn); % get the previous mask value. If not calculated before, it would be zeros
bpMask = de2bi(pMask,7); % convert to binary for separating individual masks ... i.e. uncompress
bpMask(:,ind) = reshape(mask,numel(mask),1);
dpMask = (bi2de(bpMask));
cmasks(:,fn) = uint8(dpMask);
% handles.md.cmasksMF.cmasks(:,fn) = cmasks(:,fn);