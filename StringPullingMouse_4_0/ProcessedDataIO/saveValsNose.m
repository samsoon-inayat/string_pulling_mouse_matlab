function saveValsNose(handles,M,fn,C,manual)
[globalR,globalP,~] = get_R_P_RDLC(handles);
handles.md = get_meta_data(handles);
if isempty(C)
    return;
end
indexC = strfind(M.tags,'Nose');
tag = find(not(cellfun('isempty', indexC)));

% if C.Circularity > 0.5
%     indM = C.Major_axis_ys_foci == min(C.Major_axis_ys_foci);
%     xc = C.Major_axis_xs_foci(indM)+M.zw(1);
%     yc = C.Major_axis_ys_foci(indM)+M.zw(2);
% else
    indM = C.Major_axis_ys == min(C.Major_axis_ys);
    if sum(indM) > 1
        xc = C.Major_axis_xs(indM)+M.zw(1);
        yc = C.Major_axis_ys(indM)+M.zw(2);
        xc = mean(xc);
        yc = mean(yc);
    else
        xc = C.Major_axis_xs(indM)+M.zw(1);
        yc = C.Major_axis_ys(indM)+M.zw(2);
    end
% end
% xc = C.Centroid(1)+M.zw(1); yc = C.Centroid(2)+M.zw(2);
globalR = [globalR;[fn tag(1) xc yc manual]];
pixels = [(C.xb + M.zw(1)-1) (C.yb + M.zw(2)-1)]; pixelsI = sub2ind(handles.md.frame_size,pixels(:,2),pixels(:,1));
globalP = [globalP;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag(1) pixelsI]];
save_object_mask(handles,fn,4,make_mask_from_region_pixels(C));
% save_cmasks(handles,C,fn,4);
set_R_P_RDLC(handles,globalR,globalP,'',1);
if get(handles.checkbox_updateDisplay,'Value') && manual == 0
    axes(handles.axes_main);cla
    imagesc(M.thisFrame);axis equal;axis off;
    hold on;
    plot(C.Ellipse_xs,C.Ellipse_ys,'g');
    plot(C.xb,C.yb,'r');
    title(fn);
    displayFrames(handles,M.dfn,fn);
    pause(0.1);
end

