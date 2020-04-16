function saveValsHands(handles,M,fn,hC,manual)

[globalR,globalP,~] = get_R_P_RDLC(handles);
handles.md = get_meta_data(handles);
indexC = strfind(M.tags,'Left Hand');
tag(1) = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Right Hand');
tag(2) = find(not(cellfun('isempty', indexC)));
CL = []; CR = [];
Cs = hC;%find_centroids(M,fn,'Right Hand_A');
if strcmp(Cs(1).Hand,'Left Hand')
    C = Cs(1);
else
    C = Cs(2);
end
if ~isempty(C)
    CL = C;
    x = C.Centroid(1)+M.zw(1);y = C.Centroid(2)+M.zw(2);
%             RL = [RL;[fn tag(1) x y manual]];
    RL = [fn tag(1) x y manual];
    globalR = [globalR;RL];
%             saveMR(handles,fn,tag(1),x,y,manual);
    pixels = [(C.xb + M.zw(1)) (C.yb + M.zw(2))];
    pixelsI = sub2ind(handles.md.frame_size,pixels(:,2),pixels(:,1));
    PL = [ones(size(pixelsI))*fn ones(size(pixelsI))*tag(1) pixelsI];
    globalP = [globalP;PL];
    save_object_mask(handles,fn,6,make_mask_from_region_pixels(C));
%             saveMP(handles,fn,tag(1),pixelsI);
end
% C = find_centroids(M,fn,'Right Hand_A');
if strcmp(Cs(1).Hand,'Right Hand')
    C = Cs(1);
else
    C = Cs(2);
end
if ~isempty(C)
    CR = C;
    x = C.Centroid(1)+M.zw(1);y = C.Centroid(2)+M.zw(2);
%             RR = [RR;[fn tag(2) x y manual]];
    RR = [fn tag(2) x y manual];
    globalR = [globalR;RR];
%             saveMR(handles,fn,tag(2),x,y,manual);
    pixels = [(C.xb + M.zw(1)) (C.yb + M.zw(2))];
    pixelsI = sub2ind(handles.md.frame_size,pixels(:,2),pixels(:,1));
    PR = [ones(size(pixelsI))*fn ones(size(pixelsI))*tag(2) pixelsI];
    globalP = [globalP;PR];
    save_object_mask(handles,fn,5,make_mask_from_region_pixels(C));
end
set_R_P_RDLC(handles,globalR,globalP,'',1);
if get(handles.checkbox_updateDisplay,'Value') && manual == 0
    axes(handles.axes_main);cla;
    imagesc(M.thisFrame);axis equal;axis off;
    hold on;
    if ~isempty(CL)
        plot(CL.xb,CL.yb,'r');
    end
    if ~isempty(CR)
        plot(CR.xb,CR.yb,'b');
    end
    title(fn);
    pause(0.15);
    displayFrames(handles,M.dfn,fn);
end
