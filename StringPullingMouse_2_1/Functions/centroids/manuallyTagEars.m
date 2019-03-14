function CH = manuallyTagEars(handles,fn,R_flag)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
masksMap = getParameter(handles,'Masks Order');
zw = M.zw;


global frames;
thisFrame = frames{fn};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
while 1
    hf = figure(10);clf;
%     set(hf,'WindowStyle','modal');
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    ha = gca;
    ht = text(10,30,sprintf('Draw window around Left Ear'),'color','m');
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
    Ih = getThisMask(subFrame,CVs,nrows,ncols);
    Ih = imfill(Ih,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
    Ih = bwconvhull(Ih);
    Ihm = zeros(size(thisFrame(:,:,1)));
    Ihm(top:bottom,left:right) = Ih;
    CC_Ih = bwconncomp(Ihm,8);
    s = regionprops(CC_Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema');
    Cs = s;
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
    if ~isempty(Cs)
        CsL = Cs;
    else
        CsL = [];
    end
    Cs = [];
    delete(ht);
    ht = text(10,30,sprintf('Draw window around right Ear'),'color','c');
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
    Ih = getThisMask(subFrame,CVs,nrows,ncols);
    Ih = imfill(Ih,'holes');
    Ih = bwareaopen(Ih,100,8);
    Ih = bwconvhull(Ih,'objects');
    Ih = bwconvhull(Ih);
    Ihm = zeros(size(thisFrame(:,:,1)));
    Ihm(top:bottom,left:right) = Ih;
    CC_Ih = bwconncomp(Ihm,8);
    s = regionprops(CC_Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
    'Orientation','Extrema');
    Cs = s;
    if ~isempty(Cs)
        CsR = Cs;
    else
        CsR = [];
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
    else
        
    end
end
if isempty(CsL) & isempty(CsR)
    CH = [];
    return;
end
if ~isempty(CsL)
    CH(1) = CsL;
end
if ~isempty(CsR)
    CH(2) = CsR;
end
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
C = Cs(1);

indexC = strfind(M.tags,'Left Ear');
tagL = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Right Ear');
tagR = find(not(cellfun('isempty', indexC)));

LiaL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
LiaR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
Lia = LiaL | LiaR;
M.R(Lia,:) = [];
handles.md.resultsMF.R = M.R;


if ~isempty(C.Area)
    x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
    indexC = strfind(tags,'Left Ear');
    tag = find(not(cellfun('isempty', indexC)));
    saveMR(handles,fn,tag,x,y,C.Area);
    pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
    pixelsI = sub2ind([size(frames{1},1) size(frames{1},2)],pixels(:,2),pixels(:,1));
    saveMP(handles,fn,tag,pixelsI);
end
C = Cs(2);
if ~isempty(C.Area)
    x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
    indexC = strfind(tags,'Right Ear');
    tag = find(not(cellfun('isempty', indexC)));
    saveMR(handles,fn,tag,x,y,C.Area);
    pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
    pixelsI = sub2ind([size(frames{1},1) size(frames{1},2)],pixels(:,2),pixels(:,1));
    saveMP(handles,fn,tag,pixelsI);
end
saveRegionsMask(handles,Cs,fn,masksMap{2});
global cmasks;
handles.md.cmasksMF.cmasks = cmasks;
ofn = fn;
fn = get(handles.slider1,'Value');
displayFrames(handles,fn,ofn);
