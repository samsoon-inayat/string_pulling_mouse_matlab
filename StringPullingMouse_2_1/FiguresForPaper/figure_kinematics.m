function figure_kinematics(handles)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;

fn = 1;
if isempty(fn)
    return;
end
startEnd = [1 477];
sfn = startEnd(1);
numFrames = startEnd(2)-startEnd(1)+1;

global frames;
times = handles.d.times;
R = handles.md.resultsMF.R;
tags = handles.md.resultsMF.tags;
fns = sfn:numFrames;
indexC = strfind(tags,'Right Hand');
tagR = find(not(cellfun('isempty', indexC)));
indexC = strfind(tags,'Left Hand');
tagL = find(not(cellfun('isempty', indexC)));
for ii = 1:length(fns)
    ind = ismember(R(:,[1 2]),[fns(ii) tagR],'rows');
    xrs(ii) = R(ind,3);
    yrs(ii) = R(ind,4);
    ind = ismember(R(:,[1 2]),[fns(ii) tagL],'rows');
    xls(ii) = R(ind,3);
    yls(ii) = R(ind,4);
    
    iii = ismember(R(:,[1 2]),[fns(ii) 8],'rows');
    jj = ismember(R(:,[1 2]),[fns(ii) 7],'rows');
    aC(ii) = getSubjectFit(R(jj,[3 4]),R(iii,3),R(iii,4),R(iii,5));
end
thisTimes = times(fns);
% ff = makeFigureWindow__one_axes_only(20,[1 4 6 4],[0.38 0.2 0.6 0.69]);
% axes(ff.ha);
% plot(xrs,yrs);
frame = frames{fns(1)};
% figure(21);clf;
% imagesc(frame);
% axis equal;
% axis off;
zw = getParameter(handles,'Zoom Window');
% hold on;
% plot(xrs,yrs,'c');
% plot(xls,yls,'m');
% xlim([zw(1)-50 zw(3)+50]);
% ylim([zw(2)-50 zw(4)]);

% hWaitBar = waitbar(0,sprintf('Processing Frame -'));
% fnss = [1 100 200 300 400];
% for iii = 1:length(fnss)
%     ii = fnss(iii);
%     thisFrame = frames{ii};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     tic
%     thisGradient = imgradient(rgb2gray(thisFrame));
%     gradients(:,:,ii) = thisGradient;
%     t = toc;
%     waitbar(ii/length(frames),hWaitBar,sprintf('Processing Frame %d/%d ... Time Remaining = %.2f hrs',ii,length(frames),((length(frames)-ii)*t)/3600));
% end
% close(hWaitBar);
% 
% 
% thisFrame = frames{1};
% oThisFrame = thisFrame;
% zBigFrame = zeros(size(thisFrame(:,:,1)));
zw1 = getParameter(handles,'Zoom Window');
zw = zw1 + [150 50 -300 0];

% indexC = strfind(tags,'Subject Props');
% tagSP = find(not(cellfun('isempty', indexC)));
% 
% indSP = M.R(:,2)==tagSP;
% 
% 
% img = frames{1};
% for iii = 1:length(fnss)
%     ii = fnss(iii);
%     thisGradient = gradients(:,:,ii);
%     gMask = find_mask_threshold(thisGradient,4);
%     
%     tM = zBigFrame;
%     tM(zw1(2):zw1(4),zw1(1):zw1(3)) = gMask;
%     img = imoverlay(img,tM);
% end
n = 0;
%%
ff = makeFigureRowsCols(101,[22 5.5 1.1 2],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[-0.07 0.01],'widthHeightAdjustment',...
    [0 -50]);
gg = 1;
set(gcf,'color','w');
% subplot 221
img = frames{1};
imagesc(img);
axis equal;
axis off;
hold on;
% plot(xrs(1),yrs(1),'*','color','b','MarkerSize',20);
% plot(xls(1),yls(1),'*','color','r');
fnss = 1:477;
for iii = 2:length(fnss)
    ii = fnss(iii);
    plot([xrs(ii-1) xrs(ii)],[yrs(ii-1) yrs(ii)],'color','b');
    plot([xls(ii-1) xls(ii)],[yls(ii-1) yls(ii)],'color','r');
end
fnss = [1 100 200 300 400 450];
for iii = 1:length(fnss)
    ii = fnss(iii);
    C = aC(ii);
%     plot(C.Major_axis_xs,C.Major_axis_ys,'g');
%     plot(C.Minor_axis_xs,C.Minor_axis_ys,'g');
    plot(C.Ellipse_xs,C.Ellipse_ys,'g');
end
% plot(xrs(end),yrs(end),'o','color','b');
% plot(xls(end),yls(end),'o','color','r');
xlim([zw(1) zw(3)]);
ylim([zw(2) zw(4)]);
pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);
%%
ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
ts = times(fns)-times(fns(1));
oxr = xrs(1);
oyr = yrs(1);
distR = getParameter(handles,'Scale')*sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
oxl = xls(1);
oyl = yls(1);
distL = getParameter(handles,'Scale')*sqrt((xls-oxl).^2 + (yls-oyl).^2);
plot(ts,distR,'b');hold on;
plot(ts,distL,'r');
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
xlabel('Time (sec)');
ylabel('Distance (mm)');
box off
legendText = {'Right','Left'};
thisCols = {'b','r'};
x1 = 0.5; x2 = x1+0.5; y1 = (25:-3:0); y1 = y1(1:2); y2 = y1;
legendFontSize = 7;
for ii = 1:length(legendText)
    plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
    text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
end
pdfFileName = sprintf('%s_2.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);
%%
speedR = [0 diff(distR)./diff(ts)];
speedL = [0 diff(distL)./diff(ts)];
ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
plot(ts,abs(speedR),'-b');hold on;
plot(ts,abs(speedL),'-r');
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Time (sec)');
ylabel('Speed (mm/s)');
ylim([0 700]);
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
box off;
pdfFileName = sprintf('%s_3.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);
%%
ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
plot(distR,abs(speedR),'*c','linewidth',1);hold on;
plot(distL,abs(speedL),'*m','linewidth',1);
set(gca,'FontSize',12,'FontWeight','bold');
xlabel('Distance (mm)');
ylabel('Speed (mm/s)');
pdfFileName = sprintf('%s_4.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

%%
ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
ts = times(fns)-times(fns(1));
oxr = xrs(1);
oyr = yrs(1);
% distR = getParameter(handles,'Scale');*sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
maxY = handles.md.frameSize(1);
distR = yrs; distR = maxY - distR;
distR = distR * getParameter(handles,'Scale');
oxl = xls(1);
oyl = yls(1);
% distL = getParameter(handles,'Scale');*sqrt((xls-oxl).^2 + (yls-oyl).^2);
distL = yls; distL = maxY - distL;
distL = distL * getParameter(handles,'Scale');
mmm = min([distR distL]);
distR = distR - mmm;
distL = distL - mmm;
plot(ts,distR,'b');hold on;
plot(ts,distL,'r');
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
xlabel('Time (sec)');
hyl = ylabel('Vert. Distance (mm)');
changePosition(hyl,[0 -5 0]);
box off
ylim([min([distR distL]) max([distR distL])]);
% legendText = {'Right','Left'};
% thisCols = {'b','r'};
% x1 = 0.5; x2 = x1+0.5; y1 = (25:-3:0); y1 = y1(1:2); y2 = y1;
% legendFontSize = 7;
% for ii = 1:length(legendText)
%     plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
%     text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
% end
pdfFileName = sprintf('%s_5.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


%%
ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
ts = times(fns)-times(fns(1));
oxr = xrs(1);
oyr = yrs(1);
% distR = getParameter(handles,'Scale');*sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
zw = getParameter(handles,'Zoom Window');
maxY = handles.md.frameSize(2)-zw(1,1);
distR = xrs; distR = maxY - distR;
distR = distR * getParameter(handles,'Scale');
oxl = xls(1);
oyl = yls(1);
% distL = getParameter(handles,'Scale');*sqrt((xls-oxl).^2 + (yls-oyl).^2);
distL = xls; distL = maxY - distL;
distL = distL * getParameter(handles,'Scale');
mmm = min([distR distL]);
distR = distR - mmm;
distL = distL - mmm;
plot(ts,distR,'b');hold on;
plot(ts,distL,'r');
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
xlabel('Time (sec)');
hyl = ylabel('Horiz. Distance (mm)');
changePosition(hyl,[0 -3 0]);
box off
ylim([min([distR distL]) max([distR distL])]);
legendText = {'Right','Left'};
thisCols = {'b','r'};
x1 = 0.5; x2 = x1+0.5; y1 = (18:-2:0); y1 = y1(1:2); y2 = y1;
legendFontSize = 7;
for ii = 1:length(legendText)
    plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
    text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
end
pdfFileName = sprintf('%s_6.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

%%
ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.137 0.3],'widthHeightAdjustment',...
    [-155 -400]);
gg = 1;
set(gcf,'color','w');
ts = times(fns)-times(fns(1));
oxr = xrs(1);
oyr = yrs(1);
% distR = getParameter(handles,'Scale');*sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
maxY = handles.md.frameSize(1);
distR = yrs; distR = maxY - distR;
distR = distR * getParameter(handles,'Scale');
oxl = xls(1);
oyl = yls(1);
% distL = getParameter(handles,'Scale');*sqrt((xls-oxl).^2 + (yls-oyl).^2);
distL = yls; distL = maxY - distL;
distL = distL * getParameter(handles,'Scale');
speedR = [0 diff(distR)./diff(ts)];
speedL = [0 diff(distL)./diff(ts)];
distR = speedR;
distL = speedL;
plot(ts,distR,'b');hold on;
plot(ts,distL,'r');
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
xlabel('Time (sec)');
hyl = ylabel('Vert. Speed (mm/sec)');
changePosition(hyl,[0.2 -150 0]);
box off
ylim([min([distR distL]) max([distR distL])]);
% legendText = {'Right','Left'};
% thisCols = {'b','r'};
% x1 = 0.5; x2 = x1+0.5; y1 = (25:-3:0); y1 = y1(1:2); y2 = y1;
% legendFontSize = 7;
% for ii = 1:length(legendText)
%     plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
%     text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
% end
pdfFileName = sprintf('%s_7.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

%%
ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.137 0.3],'widthHeightAdjustment',...
    [-155 -400]);
gg = 1;
set(gcf,'color','w');
ts = times(fns)-times(fns(1));
oxr = xrs(1);
oyr = yrs(1);
% distR = getParameter(handles,'Scale');*sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
zw = getParameter(handles,'Zoom Window');
maxY = handles.md.frameSize(2)-zw(1,1);
distR = xrs; distR = maxY - distR;
distR = distR * getParameter(handles,'Scale');
oxl = xls(1);
oyl = yls(1);
% distL = getParameter(handles,'Scale');*sqrt((xls-oxl).^2 + (yls-oyl).^2);
distL = xls; distL = maxY - distL;
distL = distL * getParameter(handles,'Scale');
speedR = [0 diff(distR)./diff(ts)];
speedL = [0 diff(distL)./diff(ts)];
distR = speedR;
distL = speedL;
plot(ts,distR,'b');hold on;
plot(ts,distL,'r');
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
xlabel('Time (sec)');
hyl = ylabel('Horiz. Speed (mm/sec)');
changePosition(hyl,[0.2 -150 0]);
box off
ylim([min([distR distL]) max([distR distL])]);
% legendText = {'Right','Left'};
% thisCols = {'b','r'};
% x1 = 0.5; x2 = x1+0.5; y1 = (25:-3:0); y1 = y1(1:2); y2 = y1;
% legendFontSize = 7;
% for ii = 1:length(legendText)
%     plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
%     text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
% end
pdfFileName = sprintf('%s_8.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


n = 0;

