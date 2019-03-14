function CH = manuallyTagNose(handles,fn,R_flag)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
zw = M.zw;

masksMap = getParameter(handles,'Masks Order');

global frames;
thisFrame = frames{fn};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
try
while 1
    hf = figure(10);clf;
%     set(hf,'WindowStyle','modal');
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    ha = gca;
    ht = text(10,30,sprintf('Draw window around Nose'),'color','m');
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
    colorVals = getParameter(handles,'Nose Color');
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
    if length(s) == 1
        Cs = s;
%         Cs.Hand = 'Left Hand';
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
    opts.Interpreter = 'tex';opts.Default = 'No';
    quest = 'Confirm the selected region is correct?';
    answer = questdlg(quest,'Please select',...
                      'Yes','No',opts);
    if strcmp(answer,'Yes')
        break;
    end
end
catch
    displayMessage(handles,'Could not find nose');
    return;
end
figure(10);
close(gcf);
Cs.manual = 1;

if exist('R_flag','var')
    return;
end


tags = handles.md.tags;
Cs = findBoundary(Cs,size(thisFrame));
C = Cs(1);
Rb = [];
P = [];
if ~isempty(C)
    indexC = strfind(tags,'Nose');
    tag = find(not(cellfun('isempty', indexC)));
    Rb = [Rb;[fn tag(1) C.Centroid(1)+zw(1) C.Centroid(2)+zw(2) 1]];
    Lia = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
    if any(Lia)
        Lia = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
        M.R(Lia,:) = [];
    end
    Lia = ismember(M.P(:,[1 2]),[fn tag(1)],'rows');
    if any(Lia)
        M.P(Lia,:) = [];
    end
    M.R = [M.R;Rb];
    pixels = [(C.xb + zw(1)-1) (C.yb + zw(2)-1)];
    pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
    P = [P;[ones(size(pixelsI))*fn ones(size(pixelsI))*tag(1) pixelsI]];
    M.P = [M.P;P];
    handles.md.resultsMF.R = M.R;
    handles.md.resultsMF.P = M.P;
    saveRegionsMask(handles,C,fn,masksMap{5});
end
global cmasks;
handles.md.cmasksMF.cmasks = cmasks;
ofn = fn;
fn = get(handles.slider1,'Value');
displayFrames(handles,fn,ofn);
