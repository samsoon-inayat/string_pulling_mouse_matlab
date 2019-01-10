function CH = manuallyTagHands(handles,fn,R_flag)
M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = handles.md.resultsMF.zoomWindow;
M.scale = handles.md.resultsMF.scale;
M.frameSize = handles.d.frameSize;
zw = handles.md.resultsMF.zoomWindow;
masks = get_masks_KNN(handles,fn);

sLeft = getRegion(M,fn-1,'Left Hand');
sRight = getRegion(M,fn-1,'Right Hand');


global frames;
thisFrame = frames{fn};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
Cs = [];
Cs{1} = find_centroids(M,fn,'mouse',masks,thisFrame,Cs);
Cs{2} = find_centroids(M,fn,'ears',masks,thisFrame,Cs);
Cs{2} = findBoundary(Cs{2},size(thisFrame));
allCs = Cs;

if isempty(sRight)
    pf = 0;
    earsC = Cs{2};
    xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
    xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);
else
    pf = 1;
    xrp = sRight.Centroid(1); yrp = sRight.Centroid(2);
    xlp = sLeft.Centroid(1); ylp = sLeft.Centroid(2);
end


warning off;

s = findHandsMethod2(handles,M,fn,'',masks,thisFrame,Cs);
% tdx = zw(1)+20;
% tdy = zw(2)+20;
while 1
    figure(10);clf;
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    hold on;
    for ii = 1:length(s)
        zm = zeros(size(thisFrame(:,:,1)));
        zm(s(ii).PixelIdxList) = 1;
        bnd = bwboundaries(zm);
        ys = bnd{1}(:,1);
        xs = bnd{1}(:,2);
        plot(xs,ys,'.');
    end
    ha = gca;

    ht = text(10,30,sprintf('Select Left Hand'));
    [X,Y,BUTTON] = ginput(1);
    X = floor(X); Y = floor(Y);
    xlt = X; ylt = Y;
    
    for ii = 1:length(s)
        Lia = ismember(s(ii).PixelList,[X Y],'rows');
        if sum(Lia) > 0
            break;
        end
    end
    sL = s(ii);
    lii = ii;
    delete(ht);
    ht = text(10,30,sprintf('Select Right Hand'));
    [X,Y,BUTTON] = ginput(1);
    X = floor(X); Y = floor(Y);
    xrt = X; yrt = Y;
    
    for ii = 1:length(s)
        Lia = ismember(s(ii).PixelList,[X Y],'rows');
        if sum(Lia) > 0
            break;
        end
    end
    rii = ii;
    sR = s(ii);
    if lii == rii
        sL = find_centroids_coincident(sL,[xrp yrp],[xlp ylp]);
        Cs = find_centroids_from_two(M,allCs,sL,xrp,yrp,xlp,ylp);
    else
        sL.Hand = 'Left Hand';
        ss(1) = sL;
        sR.Hand = 'Right Hand';
        ss(2) = sR;
        Cs = ss;%find_centroids_from_two(M,allCs,ss,xrp,yrp,xlp,ylp);
    end
    
    has(1) = Cs(1).Area;
    has(2) = Cs(2).Area;
%     if sum(has > 1.5*getParameter(handles,'Touching Hands Area'))
%         text(100,100,'Please Wait');
%         nrows = size(thisFrame,1);
%         ncols = size(thisFrame,2);
%         colorVals = getParameter(handles,'Hands Color');
%         mCV = mean(colorVals(:,1:3));
%         sCV = std(colorVals(:,1:3));
%         for ii = 1:3
%             CVs(:,ii) = (linspace(mCV(ii)-sCV(ii),mCV(ii)+sCV(ii),10))';
%         end
%         hsvFrame = rgb2hsv(thisFrame);
%         hsvFrame = rgb2hsv(hsvFrame);
%         Ih = getThisMask(hsvFrame,CVs,nrows,ncols);
%         Ih = imfill(Ih);
%         Ih = bwareaopen(Ih,100);
%         s = regionprops(Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
%         'Orientation','Extrema');
%         continue;
%         n = 0;
%     end
%     

    figure(10);clf;imagesc(thisFrame);axis equal;
    title(sprintf('Frame %d',fn));
    hold on;
    for ii = 1:length(Cs)
        zm = zeros(size(thisFrame(:,:,1)));
        zm(Cs(ii).PixelIdxList) = 1;
        bnd = bwboundaries(zm);
        ys = bnd{1}(:,1);
        xs = bnd{1}(:,2);
        if strcmp(Cs(ii).Hand,'Right Hand')
            plot(xs,ys,'.','color','c');
            text(min(xs),min(ys),'R');
        else
            plot(xs,ys,'.','color','m');
            text(max(xs),max(ys),'L');
        end
    end
    opts.Interpreter = 'tex';
    opts.Default = 'No';
    % Use the TeX interpreter to format the question
    quest = 'Confirm the selected region is correct?';
    answer = questdlg(quest,'Please select',...
                      'Yes','No','Refine Mask',opts);
    if strcmp(answer,'Yes')
        break;
    end
    if strcmp(answer,'Flip')
        if strcmp(Cs(1).Hand,'Right Hand')
            Cs(1).Hand = 'Left Hand';
            Cs(2).Hand = 'Right Hand';
        else
            Cs(1).Hand = 'Right Hand';
            Cs(2).Hand = 'Left Hand';
        end 
        break;
    end
    if strcmp(answer,'Refine Mask')
        text(100,100,'Please Wait');
        nrows = size(thisFrame,1);
        ncols = size(thisFrame,2);
        colorVals = getParameter(handles,'Hands Color');
%         mCV = mean(colorVals(:,1:3));
%         sCV = std(colorVals(:,1:3));
%         for ii = 1:3
%             CVs(:,ii) = (linspace(mCV(ii)-sCV(ii),mCV(ii)+sCV(ii),10))';
%         end
        CVs = colorVals(:,1:3);
        hsvFrame = rgb2hsv(thisFrame);
        hsvFrame = rgb2hsv(hsvFrame);
        Ih = getThisMask(hsvFrame,CVs,nrows,ncols);
        Ih = imfill(Ih);
        Ih = bwareaopen(Ih,100);
        s = regionprops(Ih,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
        'Orientation','Extrema');
        Cs = [];
    end
end

figure(10);
close(gcf);
Cs(1).manual = 1;
Cs(2).manual = 1;

if exist('R_flag','var')
    CH = Cs;
    return;
else
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

% C = allCs{1};
% if ~isempty(C)
%     indexC = strfind(tags,'Subject');
%     tag = find(not(cellfun('isempty', indexC)));
%     saveMR(handles,fn,tag(1),C.Centroid(1)+zw(1),C.Centroid(2)+zw(2),0);
%     indexC = strfind(tags,'Subject Props');
%     tag = find(not(cellfun('isempty', indexC)));
%     saveMR(handles,fn,tag,C.MajorAxisLength,C.MinorAxisLength,C.Orientation);
% end
% if length(allCs{2}) > 1
%     C = allCs{2}(2);%find_centroids(M,fn,'Left Ear');
%     if ~isempty(C.Area)
%         x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%         indexC = strfind(tags,'Left Ear');
%         tag = find(not(cellfun('isempty', indexC)));
%         saveMR(handles,fn,tag,x,y,0);
%     end
%     C = allCs{2}(1); % right ear
%     if ~isempty(C.Area)
%         x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%         indexC = strfind(tags,'Right Ear');
%         tag = find(not(cellfun('isempty', indexC)));
%         saveMR(handles,fn,tag,x,y,0);
%     end
% end



ofn = fn;
fn = get(handles.slider1,'Value');
displayFrames(handles,fn,ofn);


