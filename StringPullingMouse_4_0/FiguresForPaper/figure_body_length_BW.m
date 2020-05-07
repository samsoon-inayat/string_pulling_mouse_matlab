function figure_body_length_BW
variablesToGetFromBase = {'ds_b','ds_w','motion_b','motion_w','pdfFolder','fd_ent_b','fd_ent_w','config_b','config_w','all_params_w','all_params_b'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',variablesToGetFromBase{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
n = 0;

%%
% motion mean
runthis = 0;
if runthis
varNameT = 'Body Length';
for ii = 1:5
    meanb(ii) = (max(all_params_b{ii}.body.length) - min(all_params_b{ii}.body.length))*getParameter(config_b{ii},'Scale')/10;
    meanw(ii) = (max(all_params_w{ii}.body.length) - min(all_params_w{ii}.body.length))*getParameter(config_b{ii},'Scale')/10;
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.4,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Delta Body Length (cm)');changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end


%%
runthis = 0;
if runthis
varNameT = 'Dominant Frequency Body Length';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; body_length = thisP.body.angle;
    meanb(ii) = find_dominant_frequency(ts,body_length,getParameter(config,'Frame Rate'));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; body_length = thisP.body.angle;
    meanw(ii) = find_dominant_frequency(ts,body_length,getParameter(config,'Frame Rate'));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.4,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Frequency (Hz)');%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end


%%
runthis = 0;
if runthis
varNameT = 'Dominant Frequency Left Hand';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; body_length = thisP.left_hand.centroid(:,2);
    meanb(ii) = find_dominant_frequency(ts,body_length,getParameter(config,'Frame Rate'));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; body_length = thisP.left_hand.centroid(:,2);
    meanw(ii) = find_dominant_frequency(ts,body_length,getParameter(config,'Frame Rate'));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.4,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Frequency (Hz)');%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end

%%
runthis = 0;
if runthis
varNameT = 'Dominant Frequency Right Hand';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; body_length = thisP.right_hand.centroid(:,2);
    meanb(ii) = find_dominant_frequency(ts,body_length,getParameter(config,'Frame Rate'));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; body_length = thisP.right_hand.centroid(:,2);
    meanw(ii) = find_dominant_frequency(ts,body_length,getParameter(config,'Frame Rate'));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]; semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.4,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Frequency (Hz)');%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end


%%
runthis = 0;
if runthis
varNameT = 'Max Body Length';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; body_length = thisP.body.length*getParameter(config,'Scale');
    meanb(ii) = max(body_length);
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; body_length = thisP.body.length*getParameter(config,'Scale');
    meanw(ii) = max(body_length);
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.4,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
hy = ylabel('Min Body Length');%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end

%%
runthis = 0;
if runthis
varNameT = 'Body Angular Speed';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; varVal = thisP.body.angle;
    meanb(ii) = mean(abs(diff(varVal)./diff(ts)));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; varVal = thisP.body.angle;
    meanw(ii) = mean(abs(diff(varVal)./diff(ts)));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanb,meanw)
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/3;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',10,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Body Angular','Speed (deg/s)'});%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end

%%
runthis = 0;
if runthis
varNameT = 'Body Linear Speed';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; varVal = (thisP.body.length*getParameter(config,'Scale'))/10;
    meanb(ii) = mean(abs(diff(varVal)./diff(ts)));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; varVal = thisP.body.length*getParameter(config,'Scale')/10;
    meanw(ii) = mean(abs(diff(varVal)./diff(ts)));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanb,meanw)
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0 3]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Body Linear','Speed (cm/s)'});%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end

%%
runthis = 1;
if runthis
varNameT = 'Left Hand Vertical Speed';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; varVal = (thisP.left_hand.centroid(:,2)*getParameter(config,'Scale'))/10;
    meanb(ii) = max(abs(diff(varVal)./diff(ts)));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; varVal = (thisP.left_hand.centroid(:,2)*getParameter(config,'Scale'))/10;
    meanw(ii) = max(abs(diff(varVal)./diff(ts)));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
effect_size = computeCohen_d(meanw,meanb)
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0.25 2.5]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Peak Left Hand','Vert. Speed (cm/s)'});%changePosition(hy,[-0.3 -0.5 0]);
set(hy,'FontSize',6.5)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 -0.01 -0.3 -0.05]);
save_pdf(hf,pdfFolder,sprintf('%s',varNameT),600);
[hmean pmean]
return;
end

%%
runthis = 0;
if runthis
varNameT = 'Right Hand Vertical Speed';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; varVal = (thisP.right_hand.centroid(:,2)*getParameter(config,'Scale'))/10;
    meanb(ii) = mean(abs(diff(varVal)./diff(ts)));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; varVal = (thisP.right_hand.centroid(:,2)*getParameter(config,'Scale'))/10;
    meanw(ii) = mean(abs(diff(varVal)./diff(ts)));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0.25 2.5]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Right Hand','Vert. Speed (cm/s)'});%changePosition(hy,[-0.3 -0.5 0]);
set(hy,'FontSize',6.5)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 -0.01 -0.3 -0.05]);
save_pdf(hf,pdfFolder,sprintf('%s',varNameT),600);
[hmean pmean]
return;
end


%%
runthis = 0;
if runthis
varNameT = 'Hands Vertical Speed each other';
for ii = 1:5
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; varVal = (thisP.left_hand.centroid(:,2)*getParameter(config,'Scale'))/10;
    meanb(ii) = mean(abs(diff(varVal)./diff(ts)));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; varVal = (thisP.right_hand.centroid(:,2)*getParameter(config,'Scale'))/10;
    meanw(ii) = mean(abs(diff(varVal)./diff(ts)));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0.25 2.5]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Left','Right'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Max Left Hand','Vert. Speed (cm/s)'});%changePosition(hy,[-0.3 -0.5 0]);
set(hy,'FontSize',6.5)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 -0.01 -0.3 -0.05]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end

%%
runthis = 0;
if runthis
varNameT = 'Abs Left Hand Speed';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; varVal = (diff(thisP.right_hand.centroid*getParameter(config,'Scale'))./diff(ts))/10;
    temp = varVal(:,1) + varVal(:,2) * i;
    meanb(ii) = mean(abs(temp));
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; varVal = (diff(thisP.right_hand.centroid*getParameter(config,'Scale'))./diff(ts))/10;
    temp = varVal(:,1) + varVal(:,2) * i;
    meanw(ii) = mean(abs(temp));
    
end
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0.25 2.5]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Max Hand Vert.','Speed (cm/s)'});%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end

%%
runthis = 0;
if runthis
varNameT = 'Right Hand Amplitude';
% White	Black
meansbw = [
23.45	26.85
19.21	26.21
21.41	26.43
24.14	23.39
27.65	21.15];
meanb = meansbw(:,2); meanw = meansbw(:,1);
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0.25 2.5]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Right Hand','Amplitude (mm)'});%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
ylim([20 30]);
changePosition(gca,[0.1 -0.02 -0.3 0]);
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end




%% values surjeet provided
runThis = 0;
if runThis
    amplitude_w = [
23.68
20.27
24.99
25.04
23.33
19.95
17.84
19.36
21.06
20.56
19.17
20.00
17.75
19.59
21.70
14.77
18.71
18.47
20.10
19.85
20.93
22.10
23.57
22.06
23.05
21.47
17.76
21.81
21.90
24.14
25.30
24.52
25.19
26.98
20.97
15.95
38.25
31.91
29.03
23.12
];

amplitude_b = [
19.21
16.97
22.59
25.86
24.72
22.49
23.76
22.62
23.60
25.09
34.49
26.69
29.60
21.76
25.52
24.77
28.54
28.10
26.86
29.05
16.83
28.04
27.81
24.51
22.84
25.56
26.57
28.71
29.01
27.63
26.41
25.28
26.07
27.91
29.43
];
minb = min(amplitude_b);maxb = max(amplitude_b);
minw = min(amplitude_w);maxw = max(amplitude_w);
incr = 1;
barsb = []; barsw = [];
cdfb = []; cdfw = [];
minB = min([minb minw]);maxB = max([maxb maxw]);
bins = (minB-incr):incr:(maxB+incr);
    bd = amplitude_b;
    [bar1,xs,bandwidth] = ksdensity(bd,bins);
%     [bandwidthb(ii),bar1,xs,cdf]=kde(bd,length(bins),minB-incr,maxB+incr);
%     [bar1 xs] = hist(bd,bins); 
    bar1 = 100*bar1/sum(bar1); cdf = cumsum(bar1);
    barsb = [barsb bar1'];
    cdfb = [cdfb cdf'];
%     plot(bins,bar1,'k');
    bd = amplitude_w;
    [bar1,xs,bandwidth] = ksdensity(bd,bins);
%     [bandwidthw(ii),bar1,xs,cdf]=kde(bd,length(bins),minB-incr,maxB+incr);
%     [bar1 xs] = hist(bd,bins); 
    bar1 = 100*bar1/sum(bar1); cdf = cumsum(bar1);
    barsw = [barsw bar1'];
    cdfw = [cdfw cdf'];
%     plot(bins,bar1,'b');

hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 1.25 1],'color','w');
hold on;
plot(xs,barsb,'k');
plot(xs,barsw,'b');
% [ht,pt] = ttest2(amplitude_b,amplitude_w);
xlim([min(xs) max(xs)]);
[h,p,ks2stat] = kstest2(amplitude_b,amplitude_w);
hk = h; pk = p;
hx = xlabel('Amplitude'); %changePosition(hx,[0 1.25 0]);
hy = ylabel('Percentage');%changePosition(hy,[0.2 0 0]);
ylim([0 20]);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
legs = {'Black (N=35)','White (N=40)'};
legs{3} = [17 3 20 3];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
% text(15,30,{'CDF'},'FontSize',7,'FontWeight','normal');
text(30,10,{getNumberOfAsterisks(pk)},'FontSize',12,'FontWeight','normal'); text(30,8,{'(ks-test)'},'FontSize',7,'FontWeight','normal');
save_pdf(hf,pdfFolder,sprintf('Distribution %s','Amplitude'),600);

% return;
meanb = amplitude_b; meanw = amplitude_w;
hf = figure(1002);clf;set(gcf,'Units','Inches');set(gcf,'Position',[12 8 1.25 1],'color','w');
hold on;
[h,p,ci,t_stat] = ttest2(meanb,meanw)
hmean = h; pmean = p;
mVar = [mean(meanb) mean(meanw)]
semVar = [std(meanb)/sqrt(5) std(meanw)/sqrt(5)]; xdata = [1 2]; colors = {'k','b'}; combs = nchoosek(1:length(mVar),2);
maxY = max(mVar + semVar); maxY = maxY + maxY/5;
minY = max(mVar - semVar); minY = minY - minY/1.5;
plotBarsWithSigLines(mVar,semVar,combs,[h p],'colors',colors,'sigColor','k',...
        'maxY',maxY,'ySpacing',0.6,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',xdata,'sigFontSize',7,'sigAsteriskFontSize',12,'barWidth',0.7,'sigLinesStartYFactor',0.1);
xlim([0.25 2.5]); ylim([minY maxY]);
set(gca,'XTick',[1 2],'XTickLabel',{'Black','White'}); xtickangle(45);
set(gca,'FontSize',7,'FontWeight','bold','TickDir','out');
hy = ylabel({'Right Hand Vert.','Amplitude (mm)'});%changePosition(hy,[-0.3 -0.5 0]);set(hy,'FontSize',6)
% text(1,-1.85,{'***'},'FontSize',12,'FontWeight','Normal');
changePosition(gca,[0.1 0 -0.3 -0.05]);
save_pdf(hf,pdfFolder,sprintf('Mean %s','Right Hand Vertical Ampitude'),600);
[hmean pmean]

return;
end