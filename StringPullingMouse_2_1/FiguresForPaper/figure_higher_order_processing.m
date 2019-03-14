function figure_higher_order_processing(handles)

M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frameSize;
times = handles.d.times;

sfn = 1;
efn = 477;
out = get_all_params(handles,sfn,efn);
areaRatio_R2L = out.head.head_yaw;
angleV = out.head.head_roll;
bodyAngle = out.body.body_angle;
bodyLength = out.body.body_length;

xr = out.right_hand.centroid(:,1);
yr = out.right_hand.centroid(:,2);
xl = out.left_hand.centroid(:,1);
yl = out.left_hand.centroid(:,2);
n = 0;
global frames;
global frameTimes;
ppromthn = 20;
ppromth = 20;
ts = times(sfn:efn)-times(sfn);
oxr = xr(1);
oyr = yr(1);
distR = getParameter(handles,'Scale')*sqrt((xr-oxr).^2 + (yr-oyr).^2);
oxl = xl(1);
oyl = yl(1);
distL = getParameter(handles,'Scale')*sqrt((xl-oxl).^2 + (yl-oyl).^2);

var1 = out.right_hand.centroid(:,2);
var2 = out.left_hand.centroid(:,2);

var1 = abs(var1 - max(var1));
var2 = abs(var2 - max(var2));

[pks,locs,w,p] = findpeaks(var1);
inds = p>ppromth;
p = p(inds);
pks = pks(inds);
locs = locs(inds);
w = w(inds);

[npks,nlocs,nw,np] = findpeaks(-var1);
inds = np>ppromthn;
np = np(inds);
npks = npks(inds);
nlocs = nlocs(inds);
nw = nw(inds);

figure(100);clf;plot(var1);hold on;plot(nlocs,var1(nlocs),'b*');plot(locs,pks,'r*');
for ii = 1:length(pks)
%     txt = sprintf('%.1f',p(ii));
    txt = sprintf('%d',ii);
    text(locs(ii),pks(ii)+1,txt,'FontSize',7);
end
for ii = 1:length(npks)
%     txt = sprintf('%.1f',p(ii));
    txt = sprintf('%d',ii);
    text(nlocs(ii),var1(nlocs(ii))-1,txt,'FontSize',7);
end


% tD = [2];
% pks(tD) = []; locs(tD) = []; w(tD) = []; p(tD) = [];
% 
% tD = [1 2 4 5 13 15 16 23];
% npks(tD) = []; nlocs(tD) = []; nw(tD) = []; np(tD) = [];
% 
% pksR = pks; locsR = locs; wR = w; pR = p;
% npksR = npks; nlocsR = nlocs; nwR = nw; npR = np;
ptK = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27];
ntK = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26];
pksR = pks(ptK); locsR = locs(ptK); wR = w(ptK); pR = p(ptK);
npksR = npks(ntK); nlocsR = nlocs(ntK); nwR = nw(ntK); npR = np(ntK);

for ii = 1:length(locsR)
    thisFrame = frames{locsR(ii)};
    nthisFrame = frames{nlocsR(ii)};
    plotDistAndFrame(10000,var1,pksR,locsR,npksR,nlocsR,nthisFrame,nlocsR(ii));
    pause;
    plotDistAndFrame(10000,var1,pksR,locsR,npksR,nlocsR,thisFrame,locsR(ii));
    pause;
end

ppromthL = 10; ppromthnL = 10;
[pks,locs,w,p] = findpeaks(var2);
inds = p>ppromthL;
p = p(inds);
pks = pks(inds);
locs = locs(inds);
w = w(inds);

[npks,nlocs,nw,np] = findpeaks(-var2);
inds = np>ppromthnL;
np = np(inds);
npks = npks(inds);
nlocs = nlocs(inds);
nw = nw(inds);

figure(100);clf;plot(var2);hold on;plot(nlocs,var2(nlocs),'b*');plot(locs,pks,'r*');
for ii = 1:length(pks)
%     txt = sprintf('%.1f',p(ii));
    txt = sprintf('%d',ii);
    text(locs(ii),pks(ii),txt,'FontSize',7);
end
for ii = 1:length(npks)
%     txt = sprintf('%.1f',p(ii));
    txt = sprintf('%d',ii);
    text(nlocs(ii),var2(nlocs(ii)),txt,'FontSize',7);
end

ptK = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36];
ntK = [1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35];
pksL = pks(ptK); locsL = locs(ptK); wL = w(ptK); pL = p(ptK);
npksL = npks(ntK); nlocsL = nlocs(ntK); nwL = nw(ntK); npL = np(ntK);



% curves of individual pulls
indsR = [];
for ii = 1:length(pksR)
    temp = var1(nlocsR(ii):locsR(ii) + 2)-var1(nlocsR(ii));
    if length(temp) < 20
    if sum(temp>=0) == length(temp)
        indsR = [indsR ii];
        lenTempR(length(indsR)) = length(temp);
    end
    end
end
indsL = [];
for ii = 1:length(pksL)
    temp = var2(nlocsL(ii):locsL(ii) + 2)-var2(nlocsL(ii));
    if length(temp) < 20
    if sum(temp>=0) == length(temp)
        indsL = [indsL ii];
        lenTempL(length(indsL)) = length(temp);
    end
    end
end

curvesR = NaN(length(lenTempR),max(lenTempR));
curvesL = NaN(length(lenTempL),max(lenTempL));

for iii = 1:length(indsR)
    ii = indsR(iii);
    temp = var1(nlocsR(ii):locsR(ii) + 2)-var1(nlocsR(ii));
    curvesR(iii,1:length(temp)) = temp;
end
for iii = 1:length(indsL)
    ii = indsL(iii);
    temp = var2(nlocsL(ii):locsL(ii) + 2)-var2(nlocsL(ii));
    curvesL(iii,1:length(temp)) = temp';
end

dT = frameTimes(2)-frameTimes(1);
ta = linspace(0,size(curvesR,2)*dT,size(curvesR,2));
figure(100);clf;hold on;
for ii = 1:length(indsR)
    plot(ta,curvesR(ii,:),'b');
end
ta = linspace(0,size(curvesL,2)*dT,size(curvesL,2));
for ii = 1:length(indsL)
    plot(ta,curvesL(ii,:),'r');
end

ts = frameTimes(sfn:efn);
riseTimeR = (locsR(indsR) - nlocsR(indsR)) * (ts(3)-ts(2));
riseTimeL = (locsL(indsL) - nlocsL(indsL)) * (ts(3)-ts(2));

AmpR = var1(locsR(indsR)) - var1(nlocsR(indsR));
AmpL = var2(locsL(indsL)) - var2(nlocsL(indsL));



% ff = makeFigureRowsCols(101,[22 5.5 3.5 1.5],'RowsCols',[1 1],...
%     'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.12 0.3],'widthHeightAdjustment',...
%     [-150 -350]);
% gg = 1;
% set(gcf,'color','w');
% st = nlocsR(2)-30; et = locsR(7)+35;
% plot(ts(st:et),var1(st:et),'b');hold on;
% plot(ts(st:et),var2(st:et),'r');
% xlim([ts(st) ts(et)]);
% xlabel('Time (secs)');
% hyl = ylabel('Distance (mm)');
% % changePosition(hyl,[-0.1 -0.15 0]);
% box off
% set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
% pdfFileName = sprintf('%s_1.pdf',mfilename);
% pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
% save2pdf(pdfFileName,gcf,600);

%%
ff = makeFigureRowsCols(101,[22 1.5 1.5 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.25 0.3],'widthHeightAdjustment',...
    [-300 -400]);
gg = 1;
set(gcf,'color','w');hold on;
ta = linspace(0,size(curvesR,2)*dT,size(curvesR,2));
for ii = 1:length(indsR)
    plot(ta,curvesR(ii,:),'b');
end
ta = linspace(0,size(curvesL,2)*dT,size(curvesL,2));
for ii = 1:length(indsL)
    plot(ta,curvesL(ii,:),'r');
end
xlabel('Time (secs)');
hyl = ylabel('Distance (mm)');
% changePosition(hyl,[0.1 -5 0]);
xlim([0 0.29]);
ylim([-1 30]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal');
pdfFileName = sprintf('%s_2.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);

%%
ff = makeFigureRowsCols(101,[22 3.5 1 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.3 0.3],'widthHeightAdjustment',...
    [-350 -400]);
gg = 1;
set(gcf,'color','w');
plot(ones(size(AmpR)),AmpR,'.b');hold on;
semR = mean(AmpR)/sqrt(length(AmpR));
semL = mean(AmpL)/sqrt(length(AmpL));
errorbar(0.75,mean(AmpR),semR,'.b');
plot(ones(size(AmpL))*2,AmpL,'.r');
plot(2.25,mean(AmpL),'.r');
errorbar(2.25,mean(AmpL),semL,'.r');
xlim([0.5 2.5]);
xlabel('Hand');
hyl = ylabel('Amplitude (mm)');
changePosition(hyl,[0.25 -5 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal','XTickLabel',{'Right','Left'});
pdfFileName = sprintf('%s_3.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);
[p,h] = ranksum(AmpR,AmpL,'tail','right')
[h,p] = ttest2(AmpR,AmpL,'tail','right')

%%
ff = makeFigureRowsCols(101,[22 3.5 1 1.5],'RowsCols',[1 1],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.3 0.3],'widthHeightAdjustment',...
    [-350 -400]);
gg = 1;
set(gcf,'color','w');
plot(ones(size(riseTimeR)),riseTimeR,'.b');hold on;
semR = mean(riseTimeR)/sqrt(length(riseTimeR));
semL = mean(riseTimeL)/sqrt(length(riseTimeL));
errorbar(0.75,mean(riseTimeR),semR,'.b');
plot(ones(size(riseTimeL))*2,riseTimeL,'.r');
plot(2.25,mean(riseTimeL),'.r');
errorbar(2.25,mean(riseTimeL),semL,'.r');
xlim([0.5 2.5]);
xlabel('Hand');
hyl = ylabel('Rise Time (sec)');
changePosition(hyl,[0.35 -0.05 0]);
box off
set(gca,'TickDir','out','linewidth',1.25,'FontSize',9,'FontWeight','Normal','XTickLabel',{'Right','Left'});
pdfFileName = sprintf('%s_4.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);
[p,h] = ranksum(riseTimeR,riseTimeL,'tail','right')
[h,p] = ttest2(riseTimeR,riseTimeL,'tail','right')
