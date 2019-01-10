function figure_images_montage(handles)

pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]

if ~exist('handles','var')
    fh = findobj( 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics' );
    handles = guidata(fh);
end
global frames;
% global v;

startFrame = 125;
endFrame = 134;
frameNums = startFrame:endFrame;

ff = makeFigureRowsCols(101,[22 5.5 6.9 4.25],'RowsCols',[3 length(frameNums)+1],...
    'spaceRowsCols',[0.03 0.0051],'rightUpShifts',[0.02 0.03],'widthHeightAdjustment',...
    [25 -40]);
gg = 1;
set(gcf,'color','w');

zw = handles.md.resultsMF.zoomWindow;
zw = zw + [150 150 -300 0];


for ii = 1:length(frameNums)
    axes(ff.h_axes(2,ii));
    if ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = frames{frameNums(ii)};
    imagesc(thisFrame);axis equal; axis off;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
    xt = zw(1) + 20; yt = zw(2) + 40;
    text(xt,yt,num2str(frameNums(ii)),'FontSize',9,'Color','k');
end

for ii = 1:length(frameNums)
    axes(ff.h_axes(1,ii));
    if ii == 1 | ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = frames{frameNums(ii)};
    thisFramem1 = frames{frameNums(ii-1)};
    dF = thisFrame-thisFramem1;
    dF = enhanceRGBContrast(dF);
    imagesc(dF);axis equal; axis off;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
    xt = zw(1) + 20; yt = zw(2) - 40;
    text(xt,yt,sprintf('%d - %d',frameNums(ii),frameNums(ii-1)),'FontSize',9,'Color','k');
end

for ii = 1:length(frameNums)
    axes(ff.h_axes(3,ii));
    if ii == 1 | ii > length(frameNums)-2
        delete(gca);
        continue;
    end
    thisFrame = frames{frameNums(ii)};
    thisFramem1 = frames{frameNums(ii-1)};
    dF = thisFramem1-thisFrame;
    dF = enhanceRGBContrast(dF);
    imagesc(dF);axis equal; axis off;
    box off;
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
    xt = zw(1) + 20; yt = zw(4) + 40;
    text(xt,yt,sprintf('%d - %d',frameNums(ii-1),frameNums(ii)),'FontSize',9,'Color','k');
end

save2pdf(pdfFileName,gcf,600);
