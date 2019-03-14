function figure_masks(handles)

pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]

if ~exist('handles','var')
    fh = findobj( 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics' );
    handles = guidata(fh);
end

global frames;
global bdFrames;
global fdFrames;
% global v;

startFrame = 125;
endFrame = 134;
frameNums = startFrame:endFrame;

ff = makeFigureRowsCols(101,[22 5.5 5 4.5],'RowsCols',[5 length(frameNums)+1],...
    'spaceRowsCols',[0.01 0.0031],'rightUpShifts',[0.03 0.03],'widthHeightAdjustment',...
    [25 -20]);
% ff = makeFigureRowsCols(101,[22 5.5 5 4.5],'RowsCols',[5 length(frameNums)+1],...
%     'spaceRowsCols',[0.01 0.01],'rightUpShifts',[0.05 0.03],'widthHeightAdjustment',...
%     [25 -20]);
gg = 1;
set(gcf,'color','w');

zw1 = getParameter(handles,'Zoom Window');
zw = zw1 + [150 150 -300 0];


for ii = 1:length(frameNums)
    aoMasks{ii} = get_masks_KNN(handles,frameNums(ii));
end

for ii = 1:length(frameNums)
    axes(ff.h_axes(2,ii));
    if ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = frames{frameNums(ii)};
    oMasks = aoMasks{ii};
    tM = zeros(size(thisFrame(:,:,1)));
    tM(zw1(2):zw1(4),zw1(1):zw1(3)) = oMasks.Ie;
    thisFrame = imoverlay(thisFrame,tM,'c');
    imagesc(thisFrame);axis equal; axis off;hold on;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end

for ii = 1:length(frameNums)
    axes(ff.h_axes(1,ii));
    if ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = frames{frameNums(ii)};
    oMasks = aoMasks{ii};
    tM = zeros(size(thisFrame(:,:,1)));
    tM(zw1(2):zw1(4),zw1(1):zw1(3)) = oMasks.Im;
    thisFrame = imoverlay(thisFrame,tM,'c');
    imagesc(thisFrame);axis equal; axis off;hold on;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
    xt = zw(1)+20; yt = zw(2)+40;
    text(xt,yt,num2str(frameNums(ii)),'FontSize',9,'Color','k');
end

for ii = 1:length(frameNums)
    axes(ff.h_axes(3,ii));
    if ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = frames{frameNums(ii)};
    oMasks = aoMasks{ii};
    tM = zeros(size(thisFrame(:,:,1)));
    tM(zw1(2):zw1(4),zw1(1):zw1(3)) = oMasks.Ih;
    thisFrame = imoverlay(thisFrame,tM,'c');
    imagesc(thisFrame);axis equal; axis off;hold on;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end


for ii = 1:length(frameNums)
    axes(ff.h_axes(4,ii));
    if ii == 1 | ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = bdFrames{frameNums(ii)};
    oMasks = aoMasks{ii};
    tM = zeros(size(thisFrame(:,:,1)));
    tM(zw1(2):zw1(4),zw1(1):zw1(3)) = oMasks.bd;
    thisFrame = imoverlay(thisFrame,tM,'c');
    imagesc(thisFrame);axis equal; axis off;hold on;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end


for ii = 1:length(frameNums)
    axes(ff.h_axes(5,ii));
    if ii == 1 | ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = fdFrames{frameNums(ii)};
    oMasks = aoMasks{ii};
    tM = zeros(size(thisFrame(:,:,1)));
    tM(zw1(2):zw1(4),zw1(1):zw1(3)) = oMasks.fd;
    thisFrame = imoverlay(thisFrame,tM,'c');
    imagesc(thisFrame);axis equal; axis off;hold on;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end

save2pdf(pdfFileName,gcf,600);
