function oC = getRegions(handles,fn,object,varargin)

object = lower(object);

if ~checkIfDataPresent(handles,fn,object)
    oC = [];
    return;
end

zw = getParameter(handles,'Auto Zoom Window');%handles.md.resultsMF.zoomWindow;
if isnumeric(object)
    mask = get_cmasks(handles,fn,object);
else
    masksMap = getParameter(handles,'Object Masks Order');
    ind = find(strcmp(masksMap,object));
    mask = get_object_mask(handles,fn,ind);
end
if sum(mask(:)) == 0
    oC = [];
    disp(sprintf('Non-existent or inconsistent data set for frame %d and %s',fn,object));
    return;
end
oC = findRegions(mask);
if ind == 1 & length(oC) > 1
    for ii = 1:length(oC)
        areas(ii) = oC(ii).Area;
    end
    indA = areas == max(areas);
    oC = oC(indA);
end
oC.mask = mask;