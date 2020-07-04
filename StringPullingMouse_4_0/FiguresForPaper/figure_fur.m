function figure_fur(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end


M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
Cs = [];
fn = 386;
global frames;
thisFrame = frames{fn};

tMasks.Im = get_masks(handles,fn,1);
tMasks.Ie = get_masks(handles,fn,2);
tMasks.Ih = get_masks(handles,fn,3);
tMasks.In = get_masks(handles,fn,4);
tMasks.Is = get_masks(handles,fn,5);

Cs = getRegions(handles,fn,'body',1);

zw1 = getParameter(handles,'Auto Zoom Window');
zw = zw1;% + [150 150 -300 0];

ff = makeFigureRowsCols(101,[22 5.5 6.9 2],'RowsCols',[1 7],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.02 0.03],'widthHeightAdjustment',...
    [-25 -40]);
gg = 1;
set(gcf,'color','w');

tags = handles.md.tags;
indexC = strfind(tags,'Subject Props');
tagB = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Left Ear');
tagLE = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Right Ear');
tagRE = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Nose');
tagN = find(not(cellfun('isempty', indexC)));


axes(ff.h_axes(1,1));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = tMasks.Im;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);

cIm = get_cmasks(handles,fn,1);
axes(ff.h_axes(1,2));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = cIm;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);
Rmh = plotTags(handles,ff.h_axes(1,2),fn,tagB);


% axes(ff.h_axes(1,3));
% imagesc(thisFrame);axis equal;axis off;
% box off;
% Rmh = plotTags(handles,ff.h_axes(1,3),fn,tag);
% % RLE = plotTags(handles,ff.h_axes(1,3),fn,tagLE);
% % RRE = plotTags(handles,ff.h_axes(1,3),fn,tagRE);
% xlim([zw(1) zw(3)]);
% ylim([zw(2) zw(4)]);

axes(ff.h_axes(1,3));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = tMasks.Ie;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


cIe = get_cmasks(handles,fn,2);
cIe = cIe | get_cmasks(handles,fn,3);
axes(ff.h_axes(1,4));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = cIe;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


% axes(ff.h_axes(1,5));
% imagesc(thisFrame);axis equal;axis off;
% box off;
% Rmh = plotTags(handles,ff.h_axes(1,6),fn,tagB);
% RLE = plotTags(handles,ff.h_axes(1,6),fn,tagLE);
% RRE = plotTags(handles,ff.h_axes(1,6),fn,tagRE);
% xlim([zw(1) zw(3)]);
% ylim([zw(2) zw(4)]);
% 
% EE = [RLE(1,3:4);RRE(1,3:4)];
% ELmh = [Rmh(1,3:4);RLE(1,3:4)];
% ERmh = [Rmh(1,3:4);RRE(1,3:4)];
% plot(EE(:,1)',EE(:,2)','r');
% plot(ELmh(:,1)',ELmh(:,2)','r');
% plot(ERmh(:,1)',ERmh(:,2)','r');

% 
% pdfFileName = sprintf('%s_1.pdf',mfilename);
% pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
% save2pdf(pdfFileName,gcf,600);




% ff = makeFigureRowsCols(101,[22 5.5 6.9 2],'RowsCols',[1 6],...
%     'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.02 0.03],'widthHeightAdjustment',...
%     [-25 -40]);
% gg = 1;
% set(gcf,'color','w');


axes(ff.h_axes(1,5));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = tMasks.In;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);

cIn = get_cmasks(handles,fn,4);
axes(ff.h_axes(1,6));
tM = zeros(size(thisFrame(:,:,1)));
tM(zw1(2):zw1(4),zw1(1):zw1(3)) = cIn;
img = imoverlay(thisFrame,tM,'c');
imagesc(img);axis equal;axis off;
box off
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);


axes(ff.h_axes(1,7));
imagesc(thisFrame);axis equal;axis off;
box off;
Rmh = plotTags(handles,ff.h_axes(1,7),fn,tagB);
Rmh = plotTags(handles,ff.h_axes(1,7),fn,tagN);
RLE = plotTags(handles,ff.h_axes(1,7),fn,tagLE);
RRE = plotTags(handles,ff.h_axes(1,7),fn,tagRE);
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);

EE = [RLE(1,3:4);RRE(1,3:4)];
plot(EE(:,1)',EE(:,2)','r');

EE = [RLE(1,3:4);Rmh(1,3:4)];
plot(EE(:,1)',EE(:,2)','w');

EE = [RRE(1,3:4);Rmh(1,3:4)];
plot(EE(:,1)',EE(:,2)','w');

centroidLE = RLE(1,3:4);
centroidRE = RRE(1,3:4);
xns = Rmh(1,3);
yns = Rmh(1,4);


m = ((centroidLE(2) - centroidRE(2))./(centroidLE(1) - centroidRE(1)));
b1 = centroidRE(2) - m.*centroidRE(1);
b2 = m.*yns' + xns';
for ii = 1:size(m,1)
    A = [1 -m(ii);
        m(ii) 1];
    b = [b1(ii);b2(ii)];
    yxi = linsolve(A,b);
    yi = yxi(1);
    xi = yxi(2);
    if yi < yns(ii)
        dist_nose_B(ii) = -(sqrt(sum(([xi yi] - [xns(ii) yns(ii)]).^2,2)));
    else
        dist_nose_B(ii) = (sqrt(sum(([xi yi] - [xns(ii) yns(ii)]).^2,2)));
    end
end

EE = [[xi yi];Rmh(1,3:4)];
plot(EE(:,1)',EE(:,2)','r');

pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);