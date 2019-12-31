function mouse_rise_fall_Parms(handles,M,out,yR,yL)

% yR = RightHandY;
% yL = LeftHandY;

% first bout 108:187
% second bout 330:430
% bout = 330:430;
bout= [{140:265} {360:455}];
% d = get_data(handles);
% v = d.video_object;
f_rate = M.FrameRate; % fps
scale_dist = M.scale; %mm
RT_R = [];
FT_R = [];
H_R = [];
CD = [];
RT_L = [];
FT_L = [];
H_L = [];
figure(10000);clf;
% maxY = handles.md.frame_size(1);
maxY = M.frame_size(1);
dT = out.times(2)-out.times(1);
lengthR = 12;
lengthL = 12;
cri = 1;
cli = 1;
for bt = 1:length(bout)
    sig_len = cell2mat(bout(1,bt));
    nyR = abs(yR(sig_len)-maxY);
    nyL = abs(yL(sig_len)-maxY);
    zs_nyR = angle(hilbert(zscore(nyR)));
    zs_nyL = angle(hilbert(zscore(nyL)));
    % figure; plot(zs_nyR); hold on ; plot(zs_nyL)
    
    [aL, locL] = findpeaks(zs_nyL, 'MinPeakHeight',2); %, 'MinPeakDistance',20
    indL = crossing(zs_nyL);
    [aR, locR] = findpeaks(zs_nyR, 'MinPeakHeight',2);%, 'MinPeakDistance',10
    indR = crossing(zs_nyR);
    
    if locR(1)>locL(1)
        cR = ismember(indR, locR(2:end-1));%%2+length(locL(2:end-1))
        indexesR = find(cR);
        indR_N = indR((indexesR(1)-1):indexesR(end))
        
        cL = ismember(indL, locL(2:length(locR(1:end-1)-1)));
        indexesL = find(cL);
        indL_N = indL((indexesL(1)):indexesL(end)+1)
        
        comb_down = abs(indR_N-indL_N);
        avg_comb = median(comb_down)
        % avg_comb = floor(mean(comb_down))
    else
        cL = ismember(indL, locL(2:end-1));%%2+length(locL(2:end-1))
        indexesL = find(cL);
        indL_N = indL((indexesL(1)-1):indexesL(end))
        
        cR = ismember(indR, locR(2:length(locL(1:end-1)-1)));
        indexesR = find(cR);
        indR_N = indR((indexesR(1)):indexesR(end)+1)
        
        comb_down = abs(indL_N-indR_N);
        avg_comb = floor(mean(comb_down))
    end
    CD = [CD comb_down]; % combined motion frames
    
    for tt = 1:length(locR)-1
        x = nyR(locR(tt):locR(tt+1)+1)*scale_dist;
        
        mi = find(x==max(x));
        rise_Rmin = find(x==min(x(1:mi)));
        fall_Rmin = find(x==min(x(mi:end)));
%         hold on;
        thisCurve = x-x(rise_Rmin);
        ind = find(thisCurve == 0,1,'first');
        allCurvesR(cri,:) = thisCurve(ind:(ind+lengthR));
        allCurvesRc{cri} = thisCurve(ind:end);
        cri = cri + 1;
%         plot(x-x(rise_Rmin))
        
        R_rise_t = risetime(x,f_rate,'StateLevels',[x(rise_Rmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     figure;
        R_fall_t = falltime(x,f_rate,'StateLevels',[x(fall_Rmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     R_rise_t = sum(ones(1, length(x(rise_Rmin:mi)))).*(1/f_rate);
        %     R_fall_t = sum(ones(1, length(mi:length(x(mi:fall_Rmin))))).*(1/f_rate);
        height_R = mean([(x(mi)-x(rise_Rmin)) (x(mi)-x(fall_Rmin))] ).*scale_dist;
        RT_R = [RT_R R_rise_t];
        FT_R = [FT_R R_fall_t];
        H_R = [H_R height_R];
        
    end
    
    for tt = 1:length(locL)-1
        x = nyL(locL(tt):locL(tt+1)+1)*scale_dist;
        mi = find(x==max(x));
        rise_Lmin = find(x==min(x(1:mi)));
        fall_Lmin = find(x==min(x(mi:end)));
        thisCurve = x-x(rise_Lmin);
        ind = find(thisCurve == 0,1,'first');
        allCurvesL(cli,:) = thisCurve(ind:(ind+lengthL));
        allCurvesLc{cli} = thisCurve(ind:end);
        cli = cli + 1;
%         plot(x-x(rise_Rmin))
        
        L_rise_t = risetime(x,f_rate,'StateLevels',[x(rise_Lmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     figure;
        L_fall_t = falltime(x,f_rate,'StateLevels',[x(fall_Lmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     R_rise_t = sum(ones(1, length(x(rise_Rmin:mi)))).*(1/f_rate);
        %     R_fall_t = sum(ones(1, length(mi:length(x(mi:fall_Rmin))))).*(1/f_rate);
        height_L = mean([(x(mi)-x(rise_Lmin)) (x(mi)-x(fall_Lmin))] ).*scale_dist;
        RT_L = [RT_L L_rise_t];
        FT_L = [FT_L L_fall_t];
        H_L = [H_L height_L];
        
    end
end
plotCurves(allCurvesRc,allCurvesLc,dT,bt)
%%
asym_t = (RT_R - FT_R)./((RT_R + FT_R)); % asymmetry index
comb_pull = mean(CD).*(1/f_rate); % pull time with both hands
data{1} = RT_R; data{2} = RT_L;
data{3} = FT_R; data{4} = FT_L;
sigT = significanceTesting(data);
RT = [RT_R RT_L];
FT = [FT_R FT_L];
thisPlotBarGraph(RT,FT);
n=0;
%%
ff = makeFigureWindow__one_axes_only(101,[25 4 1.5 1.5],[0.33 0.17 0.6 0.75]);
axes(ff.ha);
hb = bar(mean(CD.*(1/f_rate)),'BaseValue',0.0001,'ShowBaseline','off','BarWidth',0.45);
set(hb,'FaceColor',[0.7 0.7 0],'EdgeColor',[0.7 0.7 0]);
hold on ; errorbar(mean(CD.*(1/f_rate)), std(CD.*(1/f_rate))/sqrt(length(CD)),'Color','k');
% xlim([0.6 1.4]);
hyl = ylabel('Time (sec)');
pos = get(hyl,'Position');pos = pos + [0 0 0];set(hyl,'Position',pos);
set(ff.ha,'linewidth',1.25);
set(ff.ha,'TickDir','out','FontSize',9);
legendT_all = {'Combined Pull'};
set(ff.ha,'XTick',[1],'XTickLabel',legendT_all);
set(ff.ha,'Fontweight','bold');
pdfFileName = sprintf('%s_combined.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


% figure(1000);
% clf;
% 
% subplot 412
% bar(mean(asym_t))
% hold on ; errorbar(mean(asym_t), std(asym_t))
% title('asymmetry index (AI)')
% 
% subplot 413
% bar(mean(H_R))
% hold on ; errorbar(mean(H_R), std(H_R))
% title('average height (cm/mm/change scale factor')
% 
% subplot 414
% bar(mean(CD.*(1/f_rate)))
% hold on ; errorbar(mean(CD.*(1/f_rate)), std(CD.*(1/f_rate)))
% title('combined pull time (s)')

function plotCurves(curvesR,curvesL,dT,bt)

%%
hf = figure(1001);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 9 1 1],'color','w');
hold on;
for ii = 1:length(curvesR)
    ta = linspace(0,length(curvesR{ii})*dT,length(curvesR{ii}));
    plot(ta,curvesR{ii},'b');
end
for ii = 1:length(curvesL)
    ta = linspace(0,length(curvesL{ii})*dT,length(curvesL{ii}));
    plot(ta,curvesL{ii},'r');
end
xlabel('Time (secs)');
hyl = ylabel('Distance (mm)');
% changePosition(hyl,[0 -5 0]);
% xlim([0 0.25]);
% ylim([-1 30]);
box off
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','Bold');
% changePosition(gca,[0 0 0 -0.1]);
pdfFileName = sprintf('%s_%d.pdf',mfilename,bt);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);


function thisPlotBarGraph(RT,FT)
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 7 1 1],'color','w');
[mVals(1),semVals(1)] = findMeanAndStandardError(RT);
[mVals(2),semVals(2)] = findMeanAndStandardError(FT);
[hrT,prT,ci,stats] = ttest2(RT,FT,'Tail','both')
effect_size = computeCohen_d(RT,FT)
thisCols_all = {[0 0 0],'b','m','r',[0 0.7 0.3],[0 0 0],'b','m','r'};
plotBarsWithSigLines(mVals,semVals,[1 2],[hrT prT],'colors',{[0.7 0.3 0],[0 0.7 0.3]},'BaseValue',0,'maxY',0.3,'ySpacing',0.1,'sigAsteriskFontSize',12);
xlim([0.5 2.5]);
hyl = ylabel('Time (sec)');
set(gca,'TickDir','out','linewidth',1,'FontSize',7,'FontWeight','Bold');
% set(ff.ha,'linewidth',1.25);
% set(ff.ha,'TickDir','out','FontSize',9);
legendT_all = {'Rise' 'Fall'};
set(gca,'XTick',[1 2],'XTickLabel',legendT_all);
xtickangle(30);
pdfFileName = sprintf('%s_riseTimeFallTime.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

