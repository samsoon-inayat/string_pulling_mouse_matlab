function figure_hands(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end

fn = 127;

Cs{1} = getRegions(handles,fn,'body');
Cs{2} = getRegions(handles,fn,'right ear');
Cs{3} = getRegions(handles,fn,'left ear');
Cs{4} = getRegions(handles,fn,'nose');
frames = get_frames(handles);
thisFrame = frames{fn};
M = populateM(handles,thisFrame,fn);
M.numberOfPixelsFromAbove = (size(Cs{1}.In,1)-Cs{1}.Centroid(2))/2.5;
Ih = get_masks({M.thisFrame},3);
thisFrame = M.thisFrame;


I = (rgb2gray(thisFrame));
MSER_th = getParameter(handles,'MSER Threshold');
[regions_f,rrs] = detectMSERFeatures(I,'ThresholdDelta',MSER_th);
mask_r = makeMaskFromRegions(handles,thisFrame,rrs);


ff = makeFigureRowsCols(101,[7 5.5 6.9 2],'RowsCols',[1 6],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.02 0.03],'widthHeightAdjustment',...
    [-25 -40]);
gg = 1;
set(gcf,'color','w');
delete(ff.h_axes(1,5));
axes(ff.h_axes(1,1));
imagesc(thisFrame);
axis equal;
axis off;
hold on;
plot(regions_f);

axes(ff.h_axes(1,2));
thisFrameM = imoverlay(thisFrame,mask_r,'c');
imagesc(thisFrameM);
axis equal;
axis off;
hold on;

cbMSER = get(handles.checkbox_userMSERMethod,'Value');
cbHands = get(handles.checkbox_useHandsColorMask,'Value');
set(handles.checkbox_userMSERMethod,'Value',1);
set(handles.checkbox_useHandsColorMask,'Value',0);
set(handles.pushbutton_stop_processing,'visible','on');
C = find_hands(handles,fn,1);
set(handles.checkbox_userMSERMethod,'Value',cbMSER);
set(handles.checkbox_useHandsColorMask,'Value',cbHands);
set(handles.pushbutton_stop_processing,'visible','off');

sLeft = getRegions(handles,fn-1,'Left Hand');
sRight = getRegions(handles,fn-1,'Right Hand');
axes(ff.h_axes(1,3));
mask_r = makeMaskFromRegions(handles,thisFrame,C);
thisFrameM = imoverlay(thisFrame,mask_r,'c');
imagesc(thisFrameM);
axis equal;
axis off;
hold on;
plot(sLeft.xb,sLeft.yb,'r');
plot(sRight.xb,sRight.yb,'r');

axes(ff.h_axes(1,4));
mask_r = makeMaskFromRegions(handles,thisFrame,C(1));
thisFrameM = imoverlay(thisFrameM,mask_r,'r');
mask_r = makeMaskFromRegions(handles,thisFrame,C(2));
thisFrameM = imoverlay(thisFrameM,mask_r,'b');
imagesc(thisFrameM);
axis equal;
axis off;
hold on;

pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);
