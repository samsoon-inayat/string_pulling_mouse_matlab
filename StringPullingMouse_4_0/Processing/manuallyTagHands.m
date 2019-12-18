function manuallyTagHands(handles,fn)

frames = get_frames(handles);

thisFrame = frames{fn};
M = populateM(handles,thisFrame,fn);
zw = M.zw;

indexC = strfind(M.tags,'Left Hand');
tag = find(not(cellfun('isempty', indexC)));
save_global_R(handles,fn,tag,[],[],[]);
save_global_P(handles,fn,tag,[]);
indexC = strfind(M.tags,'Right Hand');
tag = find(not(cellfun('isempty', indexC)));
save_global_R(handles,fn,tag,[],[],[]);
save_global_P(handles,fn,tag,[]);

thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
colorVals = getParameter(handles,'Hands Color');
radius = 3;
hf = figure_window(handles,100,{'SameAsDisplayWindow'});
try
while 1
    figure(hf);clf;
%     set(hf,'WindowStyle','modal');
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    ha = gca;
    ht = text(10,30,sprintf('Draw window around Left Hand'),'color','m');
     if get(handles.checkbox_draw_region,'Value')
        hrect = impoly(gca);
        pvs = round(hrect.getPosition);
        BW = poly2mask(pvs(:,1),pvs(:,2),M.sizeMasks(1),M.sizeMasks(2));
        s = findRegions(BW);
     elseif get(handles.checkbox_draw_region_rectangle,'Value')
        hrect = imrect(gca);
        pos = round(hrect.getPosition);
        Ihm = zeros(size(thisFrame(:,:,1)));
        Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = 1;
        s = findRegions(Ihm);
    else
        hrect = imrect(gca);
        pos = round(hrect.getPosition);
        subFrame = thisFrame(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3)),:);
        nrows = size(subFrame,1);
        ncols = size(subFrame,2);
        CVs = colorVals(:,4:6);
        Ih = getThisMask(subFrame,CVs,nrows,ncols,radius);
        Ih = imfill(Ih,'holes');
%         Ih = bwareaopen(Ih,100,8);
        Ih = bwconvhull(Ih,'objects');
        Ih = bwconvhull(Ih);
        Ihm = zeros(size(thisFrame(:,:,1)));
        Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = Ih;
        s = findRegions(Ihm);
     end
    if length(s) == 1
        Cs = s;
        Cs.Hand = 'Left Hand';
    else
        continue;
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
    CH(1) = Cs;
    CsL = Cs;
    Cs = [];
    delete(ht);
    ht = text(10,30,sprintf('Draw window around right Hand'),'color','c');
     if get(handles.checkbox_draw_region,'Value')
        hrect = impoly(gca);
        pvs = round(hrect.getPosition);
        BW = poly2mask(pvs(:,1),pvs(:,2),M.sizeMasks(1),M.sizeMasks(2));
        s = findRegions(BW);
     elseif get(handles.checkbox_draw_region_rectangle,'Value')
        hrect = imrect(gca);
        pos = round(hrect.getPosition);
        Ihm = zeros(size(thisFrame(:,:,1)));
        Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = 1;
        s = findRegions(Ihm);
    else
        hrect = imrect(gca);
        pos = round(hrect.getPosition);
        subFrame = thisFrame(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3)),:);
        nrows = size(subFrame,1);
        ncols = size(subFrame,2);
        CVs = colorVals(:,4:6);
        Ih = getThisMask(subFrame,CVs,nrows,ncols,radius);
        Ih = imfill(Ih,'holes');
%         Ih = bwareaopen(Ih,100,8);
        Ih = bwconvhull(Ih,'objects');
        Ih = bwconvhull(Ih);
        Ihm = zeros(size(thisFrame(:,:,1)));
        Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = Ih;
        s = findRegions(Ihm);
     end
    if length(s) == 1
        Cs = s;
        Cs.Hand = 'Right Hand';
    else
        continue;
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
    end
end
catch
    displayMessage(handles,'Could not find hands');
    return;
end
CH(2) = Cs;
saveValsHands(handles,M,fn,CH,1);
% axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
ofn = fn;
fn = get(handles.slider1,'Value');
displayFrames(handles,fn,ofn);
if get(handles.checkbox_saveOnTheGo,'Value')
    save_R_P_RDLC(handles);
else
    set(handles.pushbutton_saveData,'Enable','On');
end
close(hf);