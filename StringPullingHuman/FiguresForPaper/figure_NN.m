function figure_NN(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end

frames = get_frames(handles);;
thisFrame = frames{1};
M = populateM(handles,thisFrame,1);
thisFrame = M.thisFrame;
handles.d = get_data(handles);
handles.md = get_meta_data(handles);
sfn = 1;
efn = 477;
out = get_all_params(handles,sfn,efn,10);
outDLC = get_all_params_DLC(handles,sfn,efn,10);

frameTimes = handles.d.frame_times;
ats = frameTimes(sfn:efn);

% varN = {'head.head_yaw','head.head_roll','head.head_pitch','nose.nose_string_distance','right_hand.centroid',...
%     'left_hand.centroid','right_ear.centroid','left_ear.centroid','nose.centroid'};
% ylabels = {'Head Yaw (arb.)','Head Roll (deg)','Head Pitch (mm)','Nose-String distance (mm)','Right Hand','Left Hand',...
%     'Right Ear','Left Ear','Nose'};

varN = {'right_hand.centroid','left_hand.centroid','right_ear.centroid','left_ear.centroid','nose.centroid'};
ylabels = {'Right Hand','Left Hand','Right Ear','Left Ear','Nose'};

for ii = 1:length(varN)
    cmdTxt = sprintf('vals1 = out.%s;',varN{ii});
    eval(cmdTxt);
    cmdTxt = sprintf('vals2 = outDLC.%s;',varN{ii});
    eval(cmdTxt);
    ts = ats(1:length(vals1));
    
   
    hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 9 2.25 1],'color','w');
    if isvector(vals1)
        plot(ts,vals1-vals2);hold on;
%         plot(ts,zeros(size(vals1)));
    else
        plot(ts,vals1-vals2);hold on;
%         plot(ts,zeros(size(vals1,1),1));
        n = 0;
    end
%     if strcmp(ylabels{ii},'Left Hand') | strcmp(ylabels{ii},'Nose')
        xlabel('Time (secs)');
%     end
    if strcmp(ylabels{ii},'Right Ear')
        legend('X','Y','Location','best')
    end
    hyl = ylabel({sprintf('%s',ylabels{ii}),'(pix)'});
    cumV = reshape(vals1-vals2,1,numel(vals1));
    ylim([min(cumV) max(cumV)]);
    changePosition(gca,[-0.02 0 0.05 0]);
    box off
    set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','bold');
    pdfFileName = sprintf('%s_%d.pdf',mfilename,ii);
    pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
    save2pdf(pdfFileName,gcf,600);
end
return;

head_yaw = out.head.head_yaw;
head_roll = out.head.head_roll;
head_pitch = out.head.head_pitch;
nose_string_distance = out.nose.nose_string_distance;
head_yaw_dlc = outDLC.head.head_yaw;
head_roll_dlc = outDLC.head.head_roll;
head_pitch_dlc = outDLC.head.head_pitch;
nose_string_distance_dlc = outDLC.nose.nose_string_distance;


figY = 2; dfigY = 3;

ff = makeFigureRowsCols(101,[22 1 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w','Position',[22 figY+0*dfigY 3.5 1.5]);
plot(ts,head_yaw-head_yaw_dlc);hold on;
plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel('Head Yaw (arb.)');
changePosition(hyl,[-0.1 -0.15 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


ff = makeFigureRowsCols(102,[22 4 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w','Position',[22 figY+1*dfigY 3.5 1.5]);
plot(ts,head_roll-head_roll_dlc);hold on;
plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel('Head Roll (deg)');
changePosition(hyl,[0.1 -5 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_2.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

ff = makeFigureRowsCols(105,[27 6 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w','Position',[22 figY+2*dfigY 3.5 1.5]);
plot(ts,head_pitch-head_pitch_dlc);hold on;
plot(ts,zeros(size(head_yaw)));
xlabel('Time (secs)');
hyl = ylabel('Head Pitch (mm)');
changePosition(hyl,[0.1 -5 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_5.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

ff = makeFigureRowsCols(106,[27 3 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w','Position',[27 figY+2*dfigY 3.5 1.5]);
plot(ts(1:472),nose_string_distance-nose_string_distance_dlc);hold on;
plot(ts(1:472),zeros(size(nose_string_distance)));
xlabel('Time (secs)');
hyl = ylabel('Nose-String Dist(mm)');
changePosition(hyl,[0.1 -1 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_6.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


var1 = out.head.head_yaw;
head_roll = out.head.head_roll;
head_pitch = out.head.head_pitch;
nose_string_distance = out.nose.nose_string_distance;
head_yaw_dlc = outDLC.head.head_yaw;
head_roll_dlc = outDLC.head.head_roll;
head_pitch_dlc = outDLC.head.head_pitch;
nose_string_distance_dlc = outDLC.nose.nose_string_distance;

ff = makeFigureRowsCols(106,[27 3 3.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
    [-150 -400]);
gg = 1;
set(gcf,'color','w','Position',[27 figY+2*dfigY 3.5 1.5]);
plot(ts(1:472),nose_string_distance-nose_string_distance_dlc);hold on;
plot(ts(1:472),zeros(size(nose_string_distance)));
xlabel('Time (secs)');
hyl = ylabel('Nose-String Dist(mm)');
changePosition(hyl,[0.1 -1 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_6.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);