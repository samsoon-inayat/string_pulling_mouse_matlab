function figure_kinematics(handles)

if ~exist('handles','var')
    try
        fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
        handles = guidata(fh);
    catch
        handles = evalin('base','config_b{1}');
    end
end
handles.md = get_meta_data(handles);
% frames = get_frames(handles);
% thisFrame = frames{1};
% M = populateM(handles,thisFrame,1);
% thisFrame = M.thisFrame;
M.scale = getParameter(handles,'Scale');
M.FrameRate = getParameter(handles,'Frame Rate');
M.frame_size = [1920 1080];
sfn = 1;
efn = 477;
out = get_all_params(handles,sfn,efn,10);

times = out.times;
xrs = out.right_hand.centroid(:,1)';
yrs = out.right_hand.centroid(:,2)';
xls = out.left_hand.centroid(:,1)';
yls = out.left_hand.centroid(:,2)';
aC = out.body.fit;
% frame = frames{1};
zw = getParameter(handles,'Auto Zoom Window');
zw1 = getParameter(handles,'Zoom Window');
zw2 = zw1 + [150 50 -300 0];
fns = sfn:efn;
origin = [1,1];
n = 0;
%%
mouse_rise_fall_Parms(handles,M,out,yrs,yls)

%%
mouse_rise_fall_ParmsX(handles,M,out,xrs,xls)

% %%
% hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 9 1 1],'color','w');
% hold on;
% % subplot 221
% img = frames{1};
% imagesc(img);
% axis equal;
% axis off;
% hold on;
% % plot(xrs(1),yrs(1),'*','color','b','MarkerSize',20);
% % plot(xls(1),yls(1),'*','color','r');
% fnss = 1:477;
% for iii = 2:length(fnss)
%     ii = fnss(iii);
%     plot([xrs(ii-1) xrs(ii)],[yrs(ii-1) yrs(ii)],'color','b');
%     plot([xls(ii-1) xls(ii)],[yls(ii-1) yls(ii)],'color','r');
% end
% fnss = [1 100 200 300 400 450];
% for iii = 1:length(fnss)
%     ii = fnss(iii);
%     C = aC(ii);
% %     plot(C.Major_axis_xs,C.Major_axis_ys,'g');
% %     plot(C.Minor_axis_xs,C.Minor_axis_ys,'g');
%     plot(C.Ellipse_xs,C.Ellipse_ys,'g');
% end
% % plot(xrs(end),yrs(end),'o','color','b');
% % plot(xls(end),yls(end),'o','color','r');
% xlim([zw(1) zw(3)]);
% ylim([zw(2) zw(4)]);
% pdfFileName = sprintf('%s_1.pdf',mfilename);
% pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
% save2pdf(pdfFileName,gcf,600);

%%
hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 9 2.25 1],'color','w');
ts = times(fns)-times(fns(1));
% distR = M.scale;*sqrt((xrs-oxr).^2 + (yrs-oyr).^2);
maxY = M.frame_size(1);
distR = yrs; distR = maxY - distR;
distR = distR * M.scale;
% distL = M.scale;*sqrt((xls-oxl).^2 + (yls-oyl).^2);
distL = yls; distL = maxY - distL;
distL = distL * M.scale;
mmm = 1;%min([distR distL]);
distRV = distR - mmm;
distLV = distL - mmm;
plot(ts,distRV,'b');hold on;
plot(ts,distLV,'r');
set(gca,'TickDir','out','linewidth',0.1,'FontSize',7,'FontWeight','Bold');
xlabel('Time (sec)');
hyl = ylabel({'Vert. Position','(mm)'});
% changePosition(hyl,[0 0 0]);
box off
ylim([min([distRV distLV]) max([distRV distLV])]);
legendText = {'Right','Left'};
thisCols = {'b','r'};
x1 = 0.5; x2 = x1+0.5; y1 = (60:-7:0); y1 = y1(1:2); y2 = y1;
legendFontSize = 7;
for ii = 1:length(legendText)
    plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
    text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
end
changePosition(gca,[0 0 0.07 -0.01]);
pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


%%
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 7 2.25 1],'color','w');
ts = times(fns)-times(fns(1));
distR = xrs;
distR = distR * M.scale;
distL = xls; 
distL = distL * M.scale;
mmm = 1;%min([distR distL]);
distRH = distR - mmm;
distLH = distL - mmm;
plot(ts,distRH,'b');hold on;
plot(ts,distLH,'r');
set(gca,'TickDir','out','linewidth',0.5,'FontSize',7,'FontWeight','Bold');
xlabel('Time (sec)');
hyl = ylabel({'Horiz. Position','(mm)'});
% changePosition(hyl,[0 -2 0]);
box off
ylim([min([distRH distLH]) max([distRH distLH])]);
% legendText = {'Right','Left'};
% thisCols = {'b','r'};
% x1 = 0.5; x2 = x1+0.5; y1 = (18:-2:0); y1 = y1(1:2); y2 = y1;
% legendFontSize = 7;
% for ii = 1:length(legendText)
%     plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
%     text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
% end
changePosition(gca,[0 0 0.07 -0.01]);
pdfFileName = sprintf('%s_2.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

%%
hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 5 2.25 1],'color','w');
ts = times(fns)-times(fns(1));
speedR = [0 diff(distRV)./diff(ts')];
speedL = [0 diff(distLV)./diff(ts')];
distR = speedR;
distL = speedL;
plot(ts,distR,'b');hold on;
plot(ts,distL,'r');
set(gca,'TickDir','out','linewidth',0.5,'FontSize',7,'FontWeight','Bold');
xlabel('Time (sec)');
hyl = ylabel({'Vert. Speed','(mm/sec)'});
% changePosition(hyl,[0.2 -200 0]);
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
changePosition(gca,[0 0 0.07 -0.01]);
pdfFileName = sprintf('%s_3.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

%%
hf = figure(1004);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 3 2.25 1],'color','w');
ts = times(fns)-times(fns(1));
speedR = [0 diff(distRH)./diff(ts')];
speedL = [0 diff(distLH)./diff(ts')];
distR = speedR;
distL = speedL;
plot(ts,distR,'b');hold on;
plot(ts,distL,'r');
set(gca,'TickDir','out','linewidth',0.5,'FontSize',7,'FontWeight','Bold');
xlabel('Time (sec)');
hyl = ylabel({'Horiz. Speed','(mm/sec)'});
% changePosition(hyl,[0.1 -30 0]);
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
changePosition(gca,[0 0 0.07 -0.01]);

pdfFileName = sprintf('%s_4.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


n = 0;

