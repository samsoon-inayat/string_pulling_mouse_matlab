function figure_body_params(handles)

if ~exist('handles','var')
    try
        fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
        handles = guidata(fh);
    catch
        handles = evalin('base','config_b{1}');
        [sfn,efn] = getFrameNums(handles);
        out = evalin('base','all_params_b{1}');
        frameRate = getParameter(handles,'Frame Rate');
        frame_times = ((sfn:efn)-sfn)/frameRate;
        M.scale = getParameter(handles,'Scale');
    end
end

if isfield(handles,'figure1')
    sfn = 1;
    efn = 477;
    handles.d = get_data(handles);
    handles.md = get_meta_data(handles);
    [R,P,~] = get_R_P_RDLC(handles);
    M.R = R;
    M.P = P;
    M.tags = handles.md.tags;
    M.zw = getParameter(handles,'Zoom Window');
    M.scale = getParameter(handles,'Scale');
    M.frameSize = handles.d.frame_size;
    out = get_all_params(handles,sfn,efn,10);
    frame_times = handles.d.frame_times;
end

head_yaw = out.head.yaw;
head_roll = out.head.roll;
head_pitch = out.head.pitch;
bodyAngle = out.body.angle;
bodyLength = out.body.length;
nose_string_distance = out.nose.string_distance;

frameTimes = frame_times;

ts = frameTimes(sfn:efn);
hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 9 2.25 1],'color','w');
plot(ts,head_yaw);hold on;
plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel({'Head Yaw','(arb.)'});%changePosition(hyl,[-0.1 -0.15 0]);
box off
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','bold');
% changePosition(gca,[0 0 0 -0.1]);
pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 7 2.25 1],'color','w');
plot(ts,head_roll);hold on;
plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel({'Head Roll','(deg)'});%changePosition(hyl,[0.1 -5 0]);
box off
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','bold');
% changePosition(gca,[0 0 0 -0.1]);
pdfFileName = sprintf('%s_2.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

hf = figure(1003);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 5 2.25 1],'color','w');
plot(ts,bodyLength*M.scale);hold on;
% plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel({'Body Length','(mm)'});%changePosition(hyl,[0.05 -7 0]);
box off
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','bold');
ylim([min(bodyLength*M.scale)-5 max(bodyLength*M.scale)+5]);
% changePosition(gca,[0 0 0 -0.1]);
pdfFileName = sprintf('%s_3.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


hf = figure(1004);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 3 2.25 1],'color','w');
plot(ts,bodyAngle);hold on;
% plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel({'Body Angle','(deg)'});%changePosition(hyl,[0.1 -10 0]);
box off
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','bold');
ylim([min(bodyAngle) max(bodyAngle)]);
% changePosition(gca,[0 0 0 -0.1]);
pdfFileName = sprintf('%s_4.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

hf = figure(1005);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 1 2.25 1],'color','w');
plot(ts,head_pitch);hold on;
plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel({'Head Pitch','(mm)'});%changePosition(hyl,[0.1 -5 0]);
box off
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','bold');
% changePosition(gca,[0 0 0 -0.1]);
pdfFileName = sprintf('%s_5.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


hf = figure(1006);clf;set(gcf,'Units','Inches');set(gcf,'Position',[16 8 2.25 1],'color','w');
plot(ts,nose_string_distance);hold on;
xlabel('Time (secs)');
hyl = ylabel({'Nose-String','Dist(mm)'});%changePosition(hyl,[0.1 -1 0]);
box off
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','bold');
ylim([min(nose_string_distance)-1 max(nose_string_distance)+1]);
% changePosition(gca,[0 0 0 -0.1]);
pdfFileName = sprintf('%s_6.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);