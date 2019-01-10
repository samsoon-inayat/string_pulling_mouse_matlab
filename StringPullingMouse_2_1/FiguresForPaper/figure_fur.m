function figure_fur(handles)

pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]

if ~exist('handles','var')
    fh = findobj( 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics' );
    handles = guidata(fh);
end

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = handles.md.resultsMF.zoomWindow;
M.scale = handles.md.resultsMF.scale;
M.frameSize = handles.d.frameSize;
Cs = [];
fn = 126;
global frames;
thisFrame = frames{fn};
tMasks = get_masks_KNN(handles,fn);
Cs = [];
Cs = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
% Cse = find_centroids(M,fn,'ears',tMasks,thisFrame,{Cs});

zw1 = handles.md.resultsMF.zoomWindow;
zw = zw1 + [150 150 -300 0];

ff = makeFigureRowsCols(101,[22 5.5 6.9 2],'RowsCols',[1 6],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.02 0.03],'widthHeightAdjustment',...
    [-25 -40]);
gg = 1;
set(gcf,'color','w');

axes(ff.h_axes(1,1));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = tMasks.Im;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);

axes(ff.h_axes(1,2));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = bwconvhull(tMasks.Im);
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


tags = handles.md.tags;
indexC = strfind(tags,'Subject Props');
tag = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Left Ear');
tagLE = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Right Ear');
tagRE = find(not(cellfun('isempty', indexC)));

axes(ff.h_axes(1,3));
imagesc(thisFrame);axis equal;axis off;
box off;
Rmh = plotTags(handles,ff.h_axes(1,3),fn,tag);
% RLE = plotTags(handles,ff.h_axes(1,3),fn,tagLE);
% RRE = plotTags(handles,ff.h_axes(1,3),fn,tagRE);
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);

% EE = [RLE(1,3:4);RRE(1,3:4)];
% ELmh = [Rmh(1,3:4);RLE(1,3:4)];
% ERmh = [Rmh(1,3:4);RRE(1,3:4)];
% plot(EE(:,1)',EE(:,2)','r');
% plot(ELmh(:,1)',ELmh(:,2)','r');
% plot(ERmh(:,1)',ERmh(:,2)','r');

% global gradients;
% thisGradient = reshape(gradients(:,fn),zw1(4)-zw1(2)+1,zw1(3)-zw1(1)+1);
% tM = zeros(size(thisFrame(:,:,1)));
% tM(zw1(2):zw1(4),zw1(1):zw1(3)) = thisGradient;
% xlim([zw(1) zw(3)]);
% ylim([zw(2) zw(4)]);

% axes(ff.h_axes(1,4));
% imagesc(tM);axis equal;axis off;
% box off;
% % plotTags(handles,ff.h_axes(1,2),fn,tag);
% xlim([zw(1) zw(3)]);
% ylim([zw(2) zw(4)]);


axes(ff.h_axes(1,4));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = tMasks.Ie;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


Cm = Cs;
Im = tMasks.Im;
Ie = tMasks.Ie;
if Cm.Orientation < 0
    x = Cm.Major_axis_xs(1);
    y = Cm.Major_axis_ys(1);
else
    x = Cm.Major_axis_xs(2);
    y = Cm.Major_axis_ys(2);
end
%     Ih = bwmorph(Ih,'clean');
%     tIh = bwmorph(Ie,'open');
[allxs,allys] = meshgrid(1:size(Im,2),1:size(Im,1));
In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);
inds = find(allys > Cm.Centroid(2));
% In = expandOrCompressMask(In,1.1);
chs = Ie&~In;
chs(inds) = 0;
%     chs = tIh.*(~tIm);
chs = bwmorph(chs,'open');
axes(ff.h_axes(1,5));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = chs;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


axes(ff.h_axes(1,6));
imagesc(thisFrame);axis equal;axis off;
box off;
Rmh = plotTags(handles,ff.h_axes(1,6),fn,tag);
RLE = plotTags(handles,ff.h_axes(1,6),fn,tagLE);
RRE = plotTags(handles,ff.h_axes(1,6),fn,tagRE);
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);

EE = [RLE(1,3:4);RRE(1,3:4)];
ELmh = [Rmh(1,3:4);RLE(1,3:4)];
ERmh = [Rmh(1,3:4);RRE(1,3:4)];
plot(EE(:,1)',EE(:,2)','r');
plot(ELmh(:,1)',ELmh(:,2)','r');
plot(ERmh(:,1)',ERmh(:,2)','r');


save2pdf(pdfFileName,gcf,600);