function saveValsEars(handles,M,fn,C,manual)
if isempty(C)
    return;
end
[globalR,globalP,~] = get_R_P_RDLC(handles);
handles.md = get_meta_data(handles);
CL = []; CR = [];
for ee = 1:length(C)
    tC = C(ee);
    if isempty(tC.Centroid)
        continue;
    end
    x = tC.Centroid(1)+M.zw(1);y = tC.Centroid(2)+M.zw(2);
    indexC = strfind(M.tags,tC.ear);
    tag = find(not(cellfun('isempty', indexC)));
    globalR = [globalR;[fn tag x y manual]];
    pixels = [(tC.xb + M.zw(1)) (tC.yb + M.zw(2))];
    inds_p = pixels(:,2) > handles.md.frame_size(1);
    pixels(inds_p,2) = handles.md.frame_size(1);
    inds_p = pixels(:,1) > handles.md.frame_size(2);
    pixels(inds_p,1) = handles.md.frame_size(2);
    pixelsI = sub2ind(handles.md.frame_size,pixels(:,2),pixels(:,1));
    globalP = [globalP;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag pixelsI]];
    if strcmp(tC.ear,'Left Ear')
        save_object_mask(handles,fn,3,make_mask_from_region_pixels(tC));
%         save_cmasks(handles,tC,fn,3);
        CL = tC;
    end
    if strcmp(tC.ear,'Right Ear')
        save_object_mask(handles,fn,2,make_mask_from_region_pixels(tC));
%         save_cmasks(handles,tC,fn,2);
        CR = tC;
    end
end
set_R_P_RDLC(handles,globalR,globalP,'',1);
if get(handles.checkbox_updateDisplay,'Value') && manual == 0
%     axes(handles.axes_main);cla;
    imagesc(handles.axes_main,M.thisFrame);axis equal;axis off;
    xlim([1 size(M.thisFrame,2)]);
    ylim([1 size(M.thisFrame,1)]);
    hold on;
    if ~isempty(CL)
        plot(CL.xb,CL.yb,'r');
    end
    if ~isempty(CR)
        plot(CR.xb,CR.yb,'b');
    end
    title(fn);
    displayFrames(handles,M.dfn,fn);
end