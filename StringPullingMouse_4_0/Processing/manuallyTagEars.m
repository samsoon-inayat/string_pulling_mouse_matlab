function CH = manuallyTagEars(handles,fn,R_flag)

frames = get_frames(handles);

thisFrame = frames{fn};
M = populateM(handles,thisFrame,fn);
thisFrame = M.thisFrame;

zw = M.zw;
radius = 3;
try
while 1
    hf = figure(100);clf;
%     set(hf,'WindowStyle','modal');
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    ha = gca;
    ht = text(10,30,sprintf('Draw window around Left Ear'),'color','m');
    if get(handles.checkbox_draw_region,'Value')
        hrect = impoly(gca);
        pvs = round(hrect.getPosition);
        BW = poly2mask(pvs(:,1),pvs(:,2),M.sizeMasks(1),M.sizeMasks(2));
        Cs = findRegions(BW);
    else
        hrect = imrect(gca);
        pos = round(hrect.getPosition);
        left = pos(1);
        if left <= 0
            left = 1;
        end
        top = pos(2);
        if top <= 0
            top = 1;
        end
        right = pos(1)+pos(3);
        if right > size(thisFrame,2)
            right = size(thisFrame,2);
        end
        bottom = pos(2) + pos(4);
        if bottom > size(thisFrame,1)
            bottom = size(thisFrame,1);
        end
        subFrame = thisFrame(top:bottom,left:right,:);
        nrows = size(subFrame,1);
        ncols = size(subFrame,2);
        colorVals = getParameter(handles,'Ears Color');
        CVs = colorVals(:,4:6);
%         Ih = getThisMask(subFrame,CVs,nrows,ncols,radius);
        Ih = compute_mask(handles,subFrame,'ears',CVs);
        Ih = imfill(Ih,'holes');
        Ih = bwareaopen(Ih,str2double(get(handles.edit_smallest_area_to_neglect_ears,'String')),8);
        Ih = bwconvhull(Ih,'objects');
        Ih = bwconvhull(Ih);
        Ihm = zeros(size(thisFrame(:,:,1)));
        Ihm(top:bottom,left:right) = Ih;
        Cs = findRegions(Ihm,1);
    end
    figure(100);clf;imagesc(thisFrame);axis equal;
    title(sprintf('Frame %d',fn));
    hold on;
    for ii = 1:length(Cs)
        zm = zeros(size(thisFrame(:,:,1)));
        zm(Cs(ii).PixelIdxList) = 1;
        bnd = bwboundaries(zm);
        ys = bnd{1}(:,1);
        xs = bnd{1}(:,2);
        plot(xs,ys,'.','color','m');
        text(min(xs),min(ys),'L');
    end
    if ~isempty(Cs)
        CsL = Cs;
    else
        CsL = [];
    end
    Cs = [];
    delete(ht);
    ht = text(10,30,sprintf('Draw window around right Ear'),'color','c');
    if get(handles.checkbox_draw_region,'Value')
        hrect = impoly(gca);
        pvs = round(hrect.getPosition);
        BW = poly2mask(pvs(:,1),pvs(:,2),M.sizeMasks(1),M.sizeMasks(2));
        Cs = findRegions(BW);
    else
        hrect = imrect(gca);
        pos = round(hrect.getPosition);
        left = pos(1);
        if left <= 0
            left = 1;
        end
        top = pos(2);
        if top <= 0
            top = 1;
        end
        right = pos(1)+pos(3);
        if right > size(thisFrame,2)
            right = size(thisFrame,2);
        end
        bottom = pos(2) + pos(4);
        if bottom > size(thisFrame,1)
            bottom = size(thisFrame,1);
        end
        subFrame = thisFrame(top:bottom,left:right,:);
        nrows = size(subFrame,1);
        ncols = size(subFrame,2);
        colorVals = getParameter(handles,'Ears Color');
        CVs = colorVals(:,4:6);
%         Ih = getThisMask(subFrame,CVs,nrows,ncols,radius);
        Ih = compute_mask(handles,subFrame,'ears',CVs);
        Ih = imfill(Ih,'holes');
        Ih = bwareaopen(Ih,str2double(get(handles.edit_smallest_area_to_neglect_ears,'String')),8);
        Ih = bwconvhull(Ih,'objects');
        Ih = bwconvhull(Ih);
        Ihm = zeros(size(thisFrame(:,:,1)));
        Ihm(top:bottom,left:right) = Ih;
        Cs = findRegions(Ihm,1);
    end
    if ~isempty(Cs)
        CsR = Cs;
    else
        CsR = [];
    end
    figure(100);clf;imagesc(thisFrame);axis equal;
    title(sprintf('Frame %d',fn));
    hold on;
    for ii = 1:length(Cs)
        zm = zeros(size(thisFrame(:,:,1)));
        zm(Cs(ii).PixelIdxList) = 1;
        bnd = bwboundaries(zm);
        ys = bnd{1}(:,1);
        xs = bnd{1}(:,2);
        plot(xs,ys,'.','color','c');
        text(min(xs),min(ys),'R');
    end
    
    for ii = 1:length(CsL)
        zm = zeros(size(thisFrame(:,:,1)));
        zm(CsL(ii).PixelIdxList) = 1;
        bnd = bwboundaries(zm);
        ys = bnd{1}(:,1);
        xs = bnd{1}(:,2);
        plot(xs,ys,'.','color','m');
        text(min(xs),min(ys),'L');
    end
    opts.Interpreter = 'tex';
    opts.Default = 'No';
    % Use the TeX interpreter to format the question
    quest = 'Confirm the selected region is correct?';
    answer = questdlg(quest,'Please select',...
                      'Yes','No',opts);
    if strcmp(answer,'Yes')
        break;
    else
        
    end
end
catch
    return;
end
if isempty(CsL) & isempty(CsR)
    CH = [];
    return;
end
if ~isempty(CsL)
    CsL.ear = 'Left Ear';
    CH(1) = CsL;
end
if ~isempty(CsR)
    CsR.ear = 'Right Ear';
    CH(2) = CsR;
end

indexC = strfind(M.tags,'Left Ear');
tag = find(not(cellfun('isempty', indexC)));
save_global_R(handles,fn,tag,[],[],[]);
save_global_P(handles,fn,tag,[]);
indexC = strfind(M.tags,'Right Ear');
tag = find(not(cellfun('isempty', indexC)));
save_global_R(handles,fn,tag,[],[],[]);
save_global_P(handles,fn,tag,[]);
saveValsEars(handles,M,fn,CH,1);
if get(handles.checkbox_saveOnTheGo,'Value')
    save_R_P_RDLC(handles);
else
    set(handles.pushbutton_saveData,'Enable','On');
end
ofn = fn;
fn = get(handles.slider1,'Value');
displayFrames(handles,fn,ofn);
close(hf);