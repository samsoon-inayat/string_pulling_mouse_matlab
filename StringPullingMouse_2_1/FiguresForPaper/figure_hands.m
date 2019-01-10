function figure_hands(handles)
type = 'hands';
M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = handles.md.resultsMF.zoomWindow;
M.scale = handles.md.resultsMF.scale;
M.frameSize = handles.d.frameSize;

fn = 133;
masks = get_masks_KNN(handles,fn);
global frames;
thisFrame = frames{fn};
oThisFrame = thisFrame;
zBigFrame = zeros(size(thisFrame(:,:,1)));
zwt = handles.md.resultsMF.zoomWindow;
thisFrame = thisFrame(zwt(2):zwt(4),zwt(1):zwt(3),:);

Cs{1} = find_centroids(M,fn,'mouse',masks,thisFrame,[]);
Cs{2} = find_centroids(M,fn,'ears',masks,thisFrame,Cs);
Cs{2} = findBoundary(Cs{2},size(thisFrame));


sLeft = getRegion(M,fn-1,'Left Hand');
sRight = getRegion(M,fn-1,'Right Hand');
masks.thisFrame = thisFrame;
Cm = Cs{1};
tF = zeros(size(thisFrame(:,:,1)));
[allxs,allys] = meshgrid(1:size(tF,2),1:size(tF,1));
In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);masks.In = In;
startingVal = 0.9;
cIn = expandOrCompressMask(In,startingVal);
masks.cIn = cIn;
% zw = handles.md.resultsMF.zoomWindow;
F1 = double(rgb2gray(thisFrame));
% zw1 = handles.md.resultsMF.zoomWindow;
% global gradients;
% thisGradient = reshape(gradients(:,fn),zw1(4)-zw1(2)+1,zw1(3)-zw1(1)+1);
% maskGradient = find_mask_threshold(thisGradient,2);
% maskG = imfill(maskGradient);
% maskG = bwareaopen(maskG,100);
% sg = findRegions(M,Cs,masks,F1,maskG);
% sbDhs = findRegions(M,Cs,masks,bDg,bDhs_mask);

ff = makeFigureRowsCols(101,[22 5.5 6.9 2],'RowsCols',[1 6],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.02 0.03],'widthHeightAdjustment',...
    [-25 -40]);
gg = 1;
set(gcf,'color','w');

zw1 = handles.md.resultsMF.zoomWindow;
zw = zw1 + [150 50 -300 0];

axes(ff.h_axes(1,1));
tM = zBigFrame;
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = masks.Ih;
img = imoverlay(oThisFrame,tM,'c');
imagesc(img);axis equal;axis off;
xt = zw(1) + 20; yt = zw(2) + 40;
text(xt,yt,num2str(fn),'FontSize',9,'Color','k');
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


s = findRegions(M,Cs,masks,F1,masks.Ih);

axes(ff.h_axes(1,2));
imagesc(oThisFrame);axis equal;axis off;
box off;
hold on;
for ii = 1:length(s)
    thisS = s(ii);
    xs = thisS.PixelList(:,1)+zw1(1);
    ys = thisS.PixelList(:,2)+zw1(2);
    plot(xs,ys,'color','c');
%     xs = thisS.Centroid(1)+zw1(2);
%     ys = thisS.Centroid(2)+zw1(1);
%     plot(xs,ys,'.b');
%     text(xs,thisS.PixelList(end,2)+5+zw1(1),num2str(ii),'color',colors{jj});
end
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);



% if length(s) > 4
%     s = narrowDownRegions(s,sbDhs);
%     n = 0;
% end

% see if you can find which hand moved and how much it moved
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

bD_mask = masks.bd;
fD_mask = masks.fd;
% bDhs_mask = find_mask_1(handles,bD,'handString');
bDg = [];%double(rgb2gray(bD));
sbD = findRegions(M,Cs,masks,bDg,bD_mask);
sfD = findRegions(M,Cs,masks,bDg,fD_mask);

oThisFramem1 = frames{fn-1};
axes(ff.h_axes(1,3));
dF = enhanceRGBContrast(oThisFrame-oThisFramem1);
imagesc(dF);axis equal;axis off;box off;
hold on;
for ii = 1:length(sbD)
    thisS = sbD(ii);
    xs = thisS.PixelList(:,1)+zw1(1);
    ys = thisS.PixelList(:,2)+zw1(2);
    plot(xs,ys,'color','c');
%     xs = thisS.Centroid(1)+zw1(2);
%     ys = thisS.Centroid(2)+zw1(1);
%     plot(xs,ys,'.b');
%     text(xs,thisS.PixelList(end,2)+5+zw1(1),num2str(ii),'color',colors{jj});
end
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


axes(ff.h_axes(1,4));
dF = enhanceRGBContrast(oThisFramem1-oThisFrame);
imagesc(dF);axis equal;axis off;
box off;
hold on;
for ii = 1:length(sfD)
    thisS = sfD(ii);
    xs = thisS.PixelList(:,1)+zw1(1);
    ys = thisS.PixelList(:,2)+zw1(2);
    plot(xs,ys,'color','c');
%     xs = thisS.Centroid(1)+zw1(2);
%     ys = thisS.Centroid(2)+zw1(1);
%     plot(xs,ys,'.b');
%     text(xs,thisS.PixelList(end,2)+5+zw1(1),num2str(ii),'color',colors{jj});
end
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


[~,ssb] = findDistsAndOverlaps(M,thisFrame,s,sbD);
if sum(ssb>0.1) > 0
    for ii = 1:size(ssb,2)
        thisssb = ssb(:,ii);
        if sum(thisssb>0.1) > 1
            inds = find(thisssb>0.1);
            zM = zeros(size(thisFrame(:,:,1)));
            for jj = 1:length(inds)
                zM(s(inds(jj)).PixelIdxList) = 1;
            end
            zM = bwconvhull(zM);
            ts = regionprops(zM,'centroid','area','PixelIdxList','PixelList','MajorAxisLength','MinorAxisLength',...
            'Orientation','Extrema');
            s(inds) = [];
            s(length(s)+1) = ts;
        end
    end
end


co = findIfCoincident(handles,s,sbD);
if co>0
    C = find_centroids_coincident(s(co),[xrp yrp],[xlp ylp]);
    return;
end


mo = findIfMoved(sbD,sfD);
if strcmp(mo,'00')
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    indl = find(ol == max(ol));
    indr = find(or == max(or));
    if indl == indr
        ss(1) = s(indl);
        C = find_centroids_coincident(ss,[xrp yrp],[xlp ylp]);
        return;
    else
        ss(1) = s(indl);
        ss(2) = s(indr);
        C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
end


if strcmp(mo,'01')
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    [d,o] = findDistsAndOverlaps(M,thisFrame,s,sbD);
    if sum(o(:)>0) > 0
        [rr,cc] = find(o == max(o(:)));
        ss(1) = s(rr);
        s(rr) = [];
    end
    [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    if max(ol) > max(or)
        ind = find(ol == max(ol));
    else
        ind = find(or == max(or));
    end
    ss(2) = s(ind);
    C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
    return;
end

if strcmp(mo,'10') 
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    clear ss;
    [d,o] = findDistsAndOverlaps(M,thisFrame,s,sfD);
    if sum(o(:)>0) > 0
        [rr,cc] = find(o == max(o(:)));
        ss(1) = s(rr);
        s(rr) = [];
    end
    [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    if exist('ss','var')
        if max(ol) > max(or)
            ind = find(ol == max(ol));
        else
            ind = find(or == max(or));
        end
        ss(2) = s(ind);
        C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    else
        ind = find(ol == max(ol));
        ss(1) = s(ind);
        ind = find(or == max(or));
        ss(2) = s(ind);
        C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
end

leftF = 0; rightF = 0;
if strcmp(mo,'11')
    if length(s) == 1
        C = find_centroids_coincident(s,[xrp yrp],[xlp ylp]);
        return;
    end
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;
    end
    if length(s) == 2
        C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
        ss = C;
       axes(ff.h_axes(1,5));
        imagesc(oThisFrame);axis equal;axis off;
        box off;
        hold on;
        for ii = 1:length(ss)
            thisS = ss(ii);
            xs = thisS.PixelList(:,1)+zw1(1);
            ys = thisS.PixelList(:,2)+zw1(2);
            plot(xs,ys,'color','c');
        %     xs = thisS.Centroid(1)+zw1(2);
        %     ys = thisS.Centroid(2)+zw1(1);
        %     plot(xs,ys,'.b');
        %     text(xs,thisS.PixelList(end,2)+5+zw1(1),num2str(ii),'color',colors{jj});
        end
         thisS = sRight;
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        temp = zBigFrame;
        temp(sub2ind(size(zBigFrame),ys,xs)) = 1;
        tempB = bwboundaries(temp);
        plot(tempB{1}(:,2),tempB{1}(:,1),'b','linewidth',1.5);
        
        thisS = sLeft;
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        temp = zBigFrame;
        temp(sub2ind(size(zBigFrame),ys,xs)) = 1;
        tempB = bwboundaries(temp);
        plot(tempB{1}(:,2),tempB{1}(:,1),'r','linewidth',1.5);
        
        
        
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
        
        axes(ff.h_axes(1,6));
        imagesc(oThisFrame);axis equal;axis off;
        box off;
        hold on;

        thisS = ss(1);
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        plot(xs,ys,'color','b');
        xt = thisS.Centroid(1) - 20 + zw1(1); yt = thisS.Centroid(2) + 60 + zw1(2);
        text(xt,yt,'Right','FontSize',9,'Color','w');
        
        thisS = ss(2);
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        plot(xs,ys,'color','r');
        xt = thisS.Centroid(1) - 20 + zw1(1); yt = thisS.Centroid(2) + 60 + zw1(2);
        text(xt,yt,'Left','FontSize',9,'Color','w');

        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
        
        pdfFileName = sprintf('%s_1.pdf',mfilename);
        pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
        save2pdf(pdfFileName,gcf,600);
        
        
        return;
    end
    [ss,inds] = findBasedOnPreviousHandPositions(M,thisFrame,s,sLeft,sRight); % see if previous hand positions can be used to find current hand positions
    if length(ss) == 2
        C = ss;%find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        axes(ff.h_axes(1,5));
        imagesc(oThisFrame);axis equal;axis off;
        box off;
        hold on;
        for ii = 1:length(ss)
            thisS = ss(ii);
            xs = thisS.PixelList(:,1)+zw1(1);
            ys = thisS.PixelList(:,2)+zw1(2);
            plot(xs,ys,'color','c');
        %     xs = thisS.Centroid(1)+zw1(2);
        %     ys = thisS.Centroid(2)+zw1(1);
        %     plot(xs,ys,'.b');
        %     text(xs,thisS.PixelList(end,2)+5+zw1(1),num2str(ii),'color',colors{jj});
        end
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
        
        
        n = 0;
        return;
    end
    if length(ss) == 1
        if strcmp(ss(1).Hand,'Left Hand')
            leftF = 1;
        else
            rightF = 1;
        end
    end
    if ~rightF & leftF
        s(inds) = [];
        [d,o] = findDistsAndOverlaps(M,thisFrame,s,sRight);
        if sum(o>0.1) > 0
            [rr,cc] = find(o == max(o(:)));
        else
            [rr,cc] = find(d == min(d(:)));
        end
        s(rr).Hand = 'Right Hand';
        ss(2) = s(rr);
        C = ss;%find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        return;
    end
    if ~leftF & rightF
        s(inds) = [];
        [d,o] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
        if sum(o>0.1) > 0
            [rr,cc] = find(o == max(o(:)));
        else
            [rr,cc] = find(d == min(d(:)));
        end
        s(rr).Hand = 'Left Hand';
        ss(2) = s(rr);
        C = ss;%find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
        
        axes(ff.h_axes(1,5));
        imagesc(oThisFrame);axis equal;axis off;
        box off;
        hold on;
        for ii = 1:length(ss)
            thisS = ss(ii);
            xs = thisS.PixelList(:,1)+zw1(1);
            ys = thisS.PixelList(:,2)+zw1(2);
            plot(xs,ys,'color','c');
        %     xs = thisS.Centroid(1)+zw1(2);
        %     ys = thisS.Centroid(2)+zw1(1);
        %     plot(xs,ys,'.b');
        %     text(xs,thisS.PixelList(end,2)+5+zw1(1),num2str(ii),'color',colors{jj});
        end
         thisS = sRight;
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        temp = zBigFrame;
        temp(sub2ind(size(zBigFrame),ys,xs)) = 1;
        tempB = bwboundaries(temp);
        plot(tempB{1}(:,2),tempB{1}(:,1),'b','linewidth',1.5);
        
        thisS = sLeft;
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        temp = zBigFrame;
        temp(sub2ind(size(zBigFrame),ys,xs)) = 1;
        tempB = bwboundaries(temp);
        plot(tempB{1}(:,2),tempB{1}(:,1),'r','linewidth',1.5);
        
        
        
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
        
        axes(ff.h_axes(1,6));
        imagesc(oThisFrame);axis equal;axis off;
        box off;
        hold on;

        thisS = ss(1);
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        plot(xs,ys,'color','b');
        xt = thisS.Centroid(1) - 20 + zw1(1); yt = thisS.Centroid(2) + 60 + zw1(2);
        text(xt,yt,'Right','FontSize',9,'Color','w');
        
        thisS = ss(2);
        xs = thisS.PixelList(:,1)+zw1(1);
        ys = thisS.PixelList(:,2)+zw1(2);
        plot(xs,ys,'color','r');
        xt = thisS.Centroid(1) - 20 + zw1(1); yt = thisS.Centroid(2) + 60 + zw1(2);
        text(xt,yt,'Left','FontSize',9,'Color','w');

        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
        
        pdfFileName = sprintf('%s_1.pdf',mfilename);
        pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
        save2pdf(pdfFileName,gcf,600);
        
        return;
    end
    if ~leftF & ~rightF
        [db,ob] = findDistsAndOverlaps(M,thisFrame,s,sbD);
        if length(sbD) == 1
            [db,ob] = findDistsAndOverlaps(M,thisFrame,s,sbD);
            if sum(ob>0.1) > 0
                [rr,cc] = find(ob == max(ob(:)));

            end
            ssi = ssi + 1;
            ss(ssi) = s(rr);
            s(rr) = [];
            if ssi == 2
                C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
                return;
            end
    %         [df,of] = findDistsAndOverlaps(M,thisFrame,s,sfD);
    %         if sum(of(:)>0.1) > 0
    %             o = of;
    %             [rr,cc] = find(o == max(o(:)));
    %             ss(2) = s(rr);
    %             C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
    %             return;
    %         else
    %             [dl,ol] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
    %             [dr,or] = findDistsAndOverlaps(M,thisFrame,s,sRight);
    %             if max(ol) > max(or)
    %                 ind = find(ol == max(ol));
    %             else
    %                 ind = find(or == max(or));
    %             end
    %             ss(2) = s(ind);
    %             C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
    %             return;
    %         end
        end

        if length(sbD) == 2
            [d,o] = findDistsAndOverlaps(M,thisFrame,s,sbD);
            clear ss;
            if sum(o(:)>0.1) > 0
                sii = 0;
                for ii = 1:size(o,2)
                    to = o(:,ii);
                    if sum(to>0.1) > 0
                    ind = find(to == max(to));
                    sii = sii + 1;
                    ss(sii) = s(ind);
                    end
                end
            end
            C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
            return;
        end
        if length(sbD) > 2
            [d,o] = findDistsAndOverlaps(M,thisFrame,s,sbD);
            clear ss;
            if sum(o(:)>0.1) > 0
                sii = 0;
                for ii = 1:size(o,2)
                    to = o(:,ii);
                    if sum(to>0.1) > 0
                    ind = find(to == max(to));
                    sii = sii + 1;
                    ss(sii) = s(ind);
                    end
                end
            end
            C = find_centroids_from_two(M,Cs,ss,xrp,yrp,xlp,ylp);
            return;
        end
    end
    n = 0;
end

% C = [];
return;


function [ss,inds] = findBasedOnPreviousHandPositions(M,thisFrame,s,sLeft,sRight)
inds = [];
ssi = 0;
[~,sl] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
[~,sr] = findDistsAndOverlaps(M,thisFrame,s,sRight);
if sum(sl>0.1) > 0 & sum(sr>0.1) == 0
    if sum(sl>0.1) == 1
        ind = find(sl == max(sl));
        ssi = ssi + 1;
        ss(ssi) = s(ind);
        ss(ssi).Hand = 'Left Hand';
        inds = [inds ind];
    end
end
if sum(sr>0.1) > 0 & sum(sl>0.1) == 0 
    if sum(sr>0.1) == 1
        ind = find(sr == max(sr));
        ssi = ssi + 1;
        ss(ssi) = s(ind);
        ss(ssi).Hand = 'Right Hand';
        inds = [inds ind];
    end
end
if sum(sr>0.1) > 0 & sum(sl>0.1) > 0 
    ind = find(sl == max(sl));
    ssi = ssi + 1;
    ss(ssi) = s(ind);
    ss(ssi).Hand = 'Left Hand';
    inds = [inds ind];
    ind = find(sr == max(sr));
    ssi = ssi + 1;
    s(ind).Hand = 'Right Hand';
    ss(ssi) = s(ind);
    ss(ssi).Hand = 'Right Hand';
    inds = [inds ind];
end
if ~exist('ss','var')
    ss = [];
end
