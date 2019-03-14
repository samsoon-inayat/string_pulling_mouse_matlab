function mask = getRegionsMask(handles,fn,object)
global cmasks;
zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;
masksMap = getParameter(handles,'Masks Order');
ind = find(strcmp(masksMap,object));

tMask = cmasks(:,fn); % get the previous mask value. If not calculated before, it would be zeros
btMask = de2bi(tMask,7);
mask = reshape(btMask(:,ind),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
