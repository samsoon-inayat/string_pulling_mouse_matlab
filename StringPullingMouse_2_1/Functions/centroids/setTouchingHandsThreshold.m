function sarea = setTouchingHandsThreshold(handles,fn,R_flag)
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

    ht = text(10,30,sprintf('Select region with hands'),'color','w');
    [X,Y,BUTTON] = ginput(1);
    X = floor(X); Y = floor(Y);
    
    for ii = 1:length(s)
        Lia = ismember(s(ii).PixelList,[X Y],'rows');
        if sum(Lia) > 0
            break;
        end
    end
    sL = s(ii);
    lii = ii;
    delete(ht);
%     ht = text(10,30,sprintf('Select Right Hand'));
%     [X,Y,BUTTON] = ginput(1);
%     X = floor(X); Y = floor(Y);
%     
%     for ii = 1:length(s)
%         Lia = ismember(s(ii).PixelList,[X Y],'rows');
%         if sum(Lia) > 0
%             break;
%         end
%     end
%     rii = ii;
%     sR = s(ii);
%     if lii == rii
%         Cs = find_centroids_coincident(sL,[xrp yrp],[xlp ylp]);
%     else
%         ss(1) = sL;
%         ss(2) = sR;
%         Cs = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
%     end
%     

    figure(10);clf;imagesc(thisFrame);axis equal;
    hold on;
    Cs = sL;
    for ii = 1:length(Cs)
        zm = zeros(size(thisFrame(:,:,1)));
        zm(Cs(ii).PixelIdxList) = 1;
        bnd = bwboundaries(zm);
        ys = bnd{1}(:,1);
        xs = bnd{1}(:,2);
        plot(xs,ys,'.','color','c');
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
sarea = sL.Area;
figure(10);
close(gcf);