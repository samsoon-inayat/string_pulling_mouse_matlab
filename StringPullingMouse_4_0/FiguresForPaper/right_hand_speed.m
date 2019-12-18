function figure_right_hand_speed
variablesToGetFromBase = {'ds_b','ds_w','motion_b','motion_w','pdfFolder','fd_ent_b','fd_ent_w','config_b','config_w','all_params_w','all_params_b'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',variablesToGetFromBase{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
n = 0;


% % White mouse
boutw{1} = [{65:102} {151:208}]; % 1st animal
boutw{2} = {42:202}; % 2nd animal
boutw{3} = [{17:107} {160:205}]; % 3rd animal
boutw{4} = {70:154}; % 4th animal
boutw{5} = {136:195}; %5th animal

%% black mouse

boutb{1} = [{140:260} {360:450} ]; %1st animal
boutb{2} = {15:130};  %2nd animal
boutb{3} = [{72:132} {229:332}]; %3rd animal
boutb{4} = [{25:67} {86:162}]; %4th animal
boutb{5} = {63:150}; %5th animal

%%
runthis = 1;
if runthis
varNameT = 'Right Hand Vertical Speed';
for ii = 1:5
    thisP = all_params_b{ii}; config = config_b{ii};
    ts = thisP.times; 
    thisBout = boutb{ii};
    speedjj = [];
    for jj = 1:length(thisBout)
        theseFrames = thisBout{jj};
        varVal = (thisP.right_hand.centroid(theseFrames,2)*getParameter(config,'Scale'))/10;
        speedjj(jj) = mean(abs(diff(varVal)/0.0167));
    end
    meanb(ii) = mean(speedjj);
    
    thisP = all_params_w{ii}; config = config_w{ii};
    ts = thisP.times; 
    thisBout = boutw{ii};
    speedjj = [];
    for jj = 1:length(thisBout)
        theseFrames = thisBout{jj};
        varVal = (thisP.right_hand.centroid(theseFrames,2)*getParameter(config,'Scale'))/10;
        speedjj(jj) = mean(abs(diff(varVal)/0.0167));
    end
    meanw(ii) = mean(speedjj);
    
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
save_pdf(hf,pdfFolder,sprintf('Mean %s',varNameT),600);
[hmean pmean]
return;
end