function saveValsBody(handles,M,fn,C,manual,varargin)
[globalR,~,~] = get_R_P_RDLC(handles);
% global globalP;
if isempty(C)
    return;
end
indexC = strfind(M.tags,'Subject');
tag = find(not(cellfun('isempty', indexC)));
globalR = [globalR;[fn tag(1) C.Centroid(1)+M.zw(1) C.Centroid(2)+M.zw(2) manual]];
globalR = [globalR;[fn tag(2) C.MajorAxisLength C.MinorAxisLength C.Orientation]];
if nargin == 5
    mask = make_mask_from_region_pixels(C);
    save_object_mask(handles,fn,1,mask);
else
    mask = varargin{1};
    save_object_mask(handles,fn,1,mask);
end
set_R_P_RDLC(handles,globalR,'','',0);
if get(handles.checkbox_updateDisplay,'Value') && manual == 0
%     axes(handles.axes_main);cla
    imagesc(handles.axes_main,M.thisFrame);
    axis equal;axis off;
    hold on;
    plot(C.Ellipse_xs,C.Ellipse_ys,'g');
    plot(C.xb,C.yb,'r');
    title(fn);
    xlim([1 size(M.thisFrame,2)]);
    ylim([1 size(M.thisFrame,1)]);
    displayFrames(handles,M.dfn,fn);
    pause(0.1);
end

