function figure_body_params(handles)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;


sfn = 1;
efn = 477;
out = get_all_params(handles,sfn,efn);
areaRatio_R2L = out.head_yaw;
angleV = out.head_roll;
bodyAngle = out.body_angle;
bodyLength = out.body_length;

global frameTimes;
ts = frameTimes(sfn:efn);
ff = makeFigureRowsCols(101,[22 5.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
plot(ts,areaRatio_R2L);hold on;
plot(ts,ones(size(areaRatio_R2L)));
xlabel('Time (secs)');
hyl = ylabel('Head Yaw (ARE/ALE)');
changePosition(hyl,[-0.1 -0.15 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


ff = makeFigureRowsCols(102,[22 1.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
plot(ts,angleV);hold on;
plot(ts,zeros(size(areaRatio_R2L)));
xlabel('Time (secs)');
hyl = ylabel('Head Roll (Angle-Deg)');
changePosition(hyl,[0.1 -5 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_2.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

ff = makeFigureRowsCols(103,[22 7.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
plot(ts,bodyLength*M.scale);hold on;
% plot(ts,zeros(size(areaRatio_R2L)));
xlabel('Time (secs)');
hyl = ylabel('Body Length (mm)');
changePosition(hyl,[0.05 -7 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_3.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


ff = makeFigureRowsCols(104,[22 3.5 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w');
plot(ts,bodyAngle);hold on;
% plot(ts,zeros(size(areaRatio_R2L)));
xlabel('Time (secs)');
hyl = ylabel('Body Angle(deg)');
changePosition(hyl,[0.1 -10 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_4.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);