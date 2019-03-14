function CH = manuallyTagHands(handles,fn,R_flag)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
zw = M.zw;


global frames;
thisFrame = frames{fn};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
colorVals = getParameter(handles,'Hands Color');
while 1
    hf = figure(10);clf;
%     set(hf,'WindowStyle','modal');
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    ha = gca;
    ht = text(10,30,sprintf('Draw window around Left Hand'),'color','m');
    hrect = imrect(gca);
    pos = round(hrect.getPosition);
    subFrame = thisFrame(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3)),:);
    nrows = size(subFrame,1);
    ncols = size(subFrame,2);
    CVs = colorVals(:,4:6);
    Ih = getThisMask(subFrame,CVs,nrows,ncols);
    Ih = imfill(Ih,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
    Ih = bwconvhull(Ih);
    Ihm = zeros(size(thisFrame(:,:,1)));
    Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = Ih;
    CC_Ih = bwconncomp(Ihm,8);
    s = regionprops(CC_Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema');
    if length(s) == 1
        Cs = s;
        Cs.Hand = 'Left Hand';
    else
        continue;
    end
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
    CH(1) = Cs;
    CsL = Cs;
    Cs = [];
    delete(ht);
    ht = text(10,30,sprintf('Draw window around right Hand'),'color','c');
    hrect = imrect(gca);
    pos = round(hrect.getPosition);
    subFrame = thisFrame(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3)),:);
    nrows = size(subFrame,1);
    ncols = size(subFrame,2);
    CVs = colorVals(:,4:6);
    Ih = getThisMask(subFrame,CVs,nrows,ncols);
    Ih = imfill(Ih,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
    Ih = bwconvhull(Ih);
    Ihm = zeros(size(thisFrame(:,:,1)));
    Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = Ih;
    CC_Ih = bwconncomp(Ihm,8);
    s = regionprops(CC_Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema');
    if length(s) == 1
        Cs = s;
        Cs.Hand = 'Right Hand';
    else
        continue;
    end
    figure(10);clf;imagesc(thisFrame);axis equal;
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

% Cs = [];
% while 1
%     hf = figure(10);clf;
% %     set(hf,'WindowStyle','modal');
%     imagesc(thisFrame); axis equal;
%     title(sprintf('Frame %d',fn));
%     ha = gca;
%     ht = text(10,30,sprintf('Draw window around right Hand'),'color','w');
%     hrect = imrect(gca);
%     pos = round(hrect.getPosition);
%     subFrame = thisFrame(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3)),:);
%     nrows = size(subFrame,1);
%     ncols = size(subFrame,2);
%     CVs = colorVals(:,4:6);
%     Ih = getThisMask(subFrame,CVs,nrows,ncols);
%     Ih = imfill(Ih,'holes');
%     Ih = bwareaopen(Ih,100,8);
%     Ih = bwconvhull(Ih,'objects');
%     Ih = bwconvhull(Ih);
%     Ihm = zeros(size(thisFrame(:,:,1)));
%     Ihm(pos(2):(pos(2)+pos(4)),pos(1):(pos(1)+pos(3))) = Ih;
%     CC_Ih = bwconncomp(Ihm,8);
%     s = regionprops(CC_Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
%     'Orientation','Extrema');
%     if length(s) == 1
%         Cs = s;
%         Cs.Hand = 'Right Hand';
%     else
%         continue;
%     end
%     figure(10);clf;imagesc(thisFrame);axis equal;
%     title(sprintf('Frame %d',fn));
%     hold on;
%     for ii = 1:length(Cs)
%         zm = zeros(size(thisFrame(:,:,1)));
%         zm(Cs(ii).PixelIdxList) = 1;
%         bnd = bwboundaries(zm);
%         ys = bnd{1}(:,1);
%         xs = bnd{1}(:,2);
%         plot(xs,ys,'.','color','c');
%         text(min(xs),min(ys),'R');
%     end
%     opts.Interpreter = 'tex';
%     opts.Default = 'No';
%     % Use the TeX interpreter to format the question
%     quest = 'Confirm the selected region is correct?';
%     answer = questdlg(quest,'Please select',...
%                       'Yes','No',opts);
%     if strcmp(answer,'Yes')
%         break;
%     end
% end
CH(2) = Cs;
figure(10);
close(gcf);
CH(1).manual = 1;
CH(2).manual = 1;

if exist('R_flag','var')
    return;
else
    Cs = CH;
    CH = [];
end


tags = handles.md.tags;
Cs = findBoundary(Cs,size(thisFrame));
% Cs = allCs{3};%find_centroids(M,fn,'Right Hand_A');
if strcmp(Cs(1).Hand,'Left Hand')
    C = Cs(1);
else
    C = Cs(2);
end
if ~isempty(C)
    x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
    indexC = strfind(tags,'Left Hand');
    tag = find(not(cellfun('isempty', indexC)));
    saveMR(handles,fn,tag,x,y,1);
    pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
    pixelsI = sub2ind([size(frames{1},1) size(frames{1},2)],pixels(:,2),pixels(:,1));
    saveMP(handles,fn,tag,pixelsI);
end
% C = find_centroids(M,fn,'Right Hand_A');
if strcmp(Cs(1).Hand,'Right Hand')
    C = Cs(1);
else
    C = Cs(2);
end
if ~isempty(C)
    x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
    indexC = strfind(tags,'Right Hand');
    tag = find(not(cellfun('isempty', indexC)));
    saveMR(handles,fn,tag,x,y,1);
    pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
    pixelsI = sub2ind([size(frames{1},1) size(frames{1},2)],pixels(:,2),pixels(:,1));
    saveMP(handles,fn,tag,pixelsI);
end
% 
% % C = allCs{1};
% % if ~isempty(C)
% %     indexC = strfind(tags,'Subject');
% %     tag = find(not(cellfun('isempty', indexC)));
% %     saveMR(handles,fn,tag(1),C.Centroid(1)+zw(1),C.Centroid(2)+zw(2),0);
% %     indexC = strfind(tags,'Subject Props');
% %     tag = find(not(cellfun('isempty', indexC)));
% %     saveMR(handles,fn,tag,C.MajorAxisLength,C.MinorAxisLength,C.Orientation);
% % end
% % if length(allCs{2}) > 1
% %     C = allCs{2}(2);%find_centroids(M,fn,'Left Ear');
% %     if ~isempty(C.Area)
% %         x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
% %         indexC = strfind(tags,'Left Ear');
% %         tag = find(not(cellfun('isempty', indexC)));
% %         saveMR(handles,fn,tag,x,y,0);
% %     end
% %     C = allCs{2}(1); % right ear
% %     if ~isempty(C.Area)
% %         x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
% %         indexC = strfind(tags,'Right Ear');
% %         tag = find(not(cellfun('isempty', indexC)));
% %         saveMR(handles,fn,tag,x,y,0);
% %     end
% % end
% 
% 
% 
ofn = fn;
fn = get(handles.slider1,'Value');
displayFrames(handles,fn,ofn);
% 
% 
