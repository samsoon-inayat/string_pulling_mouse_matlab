function sarea = setTouchingHandsThreshold(handles,fn,R_flag)
% M.R = handles.md.resultsMF.R;
% M.P = handles.md.resultsMF.P;
handles.md = get_meta_data(handles);
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.md.frame_size;
zw = M.zw;
% masks = get_masks_KNN(handles,fn);




frames = get_frames(handles);
radius = 1.5;
thisFrame = frames{fn};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
colorVals = getParameter(handles,'Hands Color');
while 1
    hf = figure(10);clf;
%     set(hf,'WindowStyle','modal');
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    ha = gca;
    ht = text(10,30,sprintf('Draw window around Hands'),'color','w');
    hrect = imrect(gca);
    pos = round(hrect.getPosition);
    subFrame = thisFrame(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3)),:);
    nrows = size(subFrame,1);
    ncols = size(subFrame,2);
    CVs = colorVals(:,4:6);
%     Ih = compute_mask(handles,subFrame,'hands',CVs);
    Ih = compute_masks_range_search_select(handles,subFrame,'hands',CVs);
%     Ih = getThisMask(subFrame,CVs,nrows,ncols,radius);
    Ih = imfill(Ih,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
%     Ih = bwconvhull(Ih);
    Ihm = zeros(size(thisFrame(:,:,1)));
    Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = Ih;
    CC_Ih = bwconncomp(Ihm,8);
    s = regionprops(CC_Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema');
%     if length(s) == 1
        Cs = s;
%     else
%         continue;
%     end
    figure(10);clf;imagesc(thisFrame);axis equal;
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
Areas = getRegionValues(Cs,'Area');
sarea = sum(Areas)
figure(10);
close(gcf);