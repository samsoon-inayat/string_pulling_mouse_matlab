clear all
clc

mainFolder = '\\mohajerani-nas.uleth.ca\storage\homes\arashk.ghasroddashti\Sam\SampleData';

blackFolder = fullfile(mainFolder,'Black_Videos - v4');
whiteFolder = fullfile(mainFolder,'White_Videos - v4');

temp = dir(blackFolder);
ind = 1;
for ii = 1:length(temp)
    if ~temp(ii).isdir
        blackFiles{ind} = temp(ii).name;
        ind = ind + 1;
    end
end

temp = dir(whiteFolder);
ind = 1;
for ii = 1:length(temp)
    if ~temp(ii).isdir
        whiteFiles{ind} = temp(ii).name;
        ind = ind + 1;
    end
end

folder = blackFolder;
files = blackFiles;
for ii = 1
    ii
    %black
    pd_folder = fullfile(folder,sprintf('%s_processed_data',files{ii}(1:(end-4))));
    config_file = fullfile(pd_folder,'config.mat');
    config = load(config_file);
    ind = strcmp(config.names,'Epochs'); epochs = config.values{ind};
    ind = strcmp(config.names,'Scale'); scaleB(ii) = config.values{ind};
    sfn = epochs{1,1};
    efn = epochs{1,2};
    m_fileName = fullfile(pd_folder,sprintf('PCs_motion_%d_%d.mat',sfn,efn))
    pc = load(m_fileName);
    bPC1s{ii} = reshape(pc.score(:,1),pc.nrows,pc.ncols);
    bPCs{ii} = pc;
    n = 0;
end

folder = whiteFolder;
files = whiteFiles;
for ii = 1
    ii
    % white
    pd_folder = fullfile(folder,sprintf('%s_processed_data',files{ii}(1:(end-4))));
    config_file = fullfile(pd_folder,'config.mat');
    config = load(config_file);
    ind = strcmp(config.names,'Epochs'); epochs = config.values{ind};
    ind = strcmp(config.names,'Scale'); scaleW(ii) = config.values{ind};
    sfn = epochs{1,1};
    efn = epochs{1,2};
    m_fileName = fullfile(pd_folder,sprintf('PCs_motion_%d_%d.mat',sfn,efn))
    pc = load(m_fileName);
    wPC1s{ii} = reshape(pc.score(:,1),pc.nrows,pc.ncols);
    wPCs{ii} = pc;
    n = 0;
end

%%
for ii = 1:5
    tPC = bPC1s{ii};
    minsb(ii) = min(tPC(:));
    maxsb(ii) = max(tPC(:));
    [rowsb(ii),colsb(ii)] = size(tPC);
    tPC = wPC1s{ii};
    minsw(ii) = min(tPC(:));
    maxsw(ii) = max(tPC(:));
    [rowsw(ii),colsw(ii)] = size(tPC);
end

minb = min(minsb);maxb = max(maxsb); minw = min(minsw); maxw = max(maxsw);
minbw = min([minb minw]); maxbw = max([maxb maxw]);


%% for plotting
mm = 25;
% nCols = 50;

ff = makeFigureRowsCols(101,[22 5.5 6.9 2],'RowsCols',[2 5],...
    'spaceRowsCols',[0.03 -0.05],'rightUpShifts',[0.05 0.020],'widthHeightAdjustment',...
    [0 -50]);
set(ff.hf,'Position',[8 5.5 6.9 2]);
set(gcf,'color','w');

nstd = 2;
for ii = 1:5
    axes(ff.h_axes(1,ii));
    thisFrame = bPC1s{ii};
    cC = floor(size(thisFrame,2)/2);
    if isnan(mm)
        nCols = floor(mm/(4*scaleB(ii)));
    else
        nCols = 50;
    end
    sC = cC-nCols;
    eC = cC+nCols;
    if sC < 1
        sC = 1;
    end
    if eC > size(thisFrame,2)
        eC = size(thisFrame,2);
    end
    thisFrame = thisFrame(:,sC:eC);
    imagesc(thisFrame);
    hc = colorbar;
    changePosition(hc,[0.03 0 0 0]);
    mint = min(thisFrame(:)); maxt = max(thisFrame(:)); dt = maxt - mint;
    set(hc,'XTick',[round(mint + 0.05*dt) round(maxt  - 0.05*dt)],'FontSize',8);
    axis equal; axis off;hold on
    mval = mean(thisFrame(:));
    sval = std(thisFrame(:));
    thresh = mval + nstd * sval;
    [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',0.5,'ShowText','off','Color','r');
    bwThisFrame = zeros(size(thisFrame));
    bwThisFrame(thisFrame>thresh) = 1;
    s = findRegions(bwThisFrame);
    areas = getRegionValues(s,'Area');
    s = s(areas == max(areas));
    plot(s.Ellipse_xs,s.Ellipse_ys,'k','LineWidth',0.25);
    if ii == 1
        text(-60,100+size(thisFrame,1)/2,'Black Mice','FontSize',10,'FontWeight','Bold','Rotation',90);
    end
    box off;
    ratioMajMinB(ii) = s.MajorAxisLength/s.MinorAxisLength;
%     text(1,-15,sprintf('Black_mouse_%d',ii),'FontSize',8,'Interpreter','none');
end

for ii = 1:5
    axes(ff.h_axes(2,ii));
    thisFrame = wPC1s{ii};
    cC = floor(size(thisFrame,2)/2);
    if isnan(mm)
        nCols = floor(mm/(4*scaleW(ii)));
    else
        nCols = 50;
    end
    sC = cC-nCols;
    eC = cC+nCols;
    if sC < 1
        sC = 1;
    end
    if eC > size(thisFrame,2)
        eC = size(thisFrame,2);
    end
    thisFrame = thisFrame(:,sC:eC);
    imagesc(thisFrame);
    hc = colorbar;
    changePosition(hc,[0.03 0 0 0]);
    mint = min(thisFrame(:)); maxt = max(thisFrame(:)); dt = maxt - mint;
    set(hc,'XTick',[round(mint + 0.05*dt) round(maxt  - 0.05*dt)],'FontSize',8);
    axis equal; axis off;hold on
    mval = mean(thisFrame(:));
    sval = std(thisFrame(:));
    thresh = mval + nstd * sval;
    [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',0.5,'ShowText','off','Color','r');
    bwThisFrame = zeros(size(thisFrame));
    bwThisFrame(thisFrame>thresh) = 1;
    s = findRegions(bwThisFrame);
    areas = getRegionValues(s,'Area');
    s = s(areas == max(areas));
    plot(s.Ellipse_xs,s.Ellipse_ys,'k','LineWidth',0.25);
    if ii == 1
        text(-60,100+size(thisFrame,1)/2,'White Mice','FontSize',10,'FontWeight','Bold','Rotation',90);
    end
    box off;
    ratioMajMinW(ii) = s.MajorAxisLength/s.MinorAxisLength;
%     text(1,-15,sprintf('Black_mouse_%d',ii),'FontSize',8,'Interpreter','none');
end

% ratioMajMinB(ratioMajMinB < 0) = ratioMajMinB (ratioMajMinB < 0) + 180;
% ratioMajMinW(ratioMajMinW < 0) = ratioMajMinW (ratioMajMinW < 0) + 180;

[h,p,ci,stats] = ttest2(ratioMajMinB,ratioMajMinW)

saveFileName = 'All_PC1s.pdf';
folder = fullfile(mainFolder,'pdfs');
if ~exist(folder,'dir')
    mkdir(folder);
end
saveFileName = fullfile(folder,saveFileName);
save2pdf(saveFileName,ff.hf,600);

%%
eB = []; eW = [];
for ii = 1
    tPC = bPCs{ii};
    eB(ii,:) = tPC.explained(1:10);
    fdb(ii,:) = getFractalDimension(tPC.score(:,1:10),tPC.nrows,tPC.ncols);
    tPC = wPCs{ii};
    eW(ii,:) = tPC.explained(1:10);
    fdw(ii,:) = getFractalDimension(tPC.score(:,1:10),tPC.nrows,tPC.ncols);
end
var1 = eB(1,:); var2 = eW(1,:);

for ii = 1:5
    group{ii,1} = 'Black';
end
for ii = 1:5
    group{ii+5,1} = 'White';
end
for ii = 1:10
    PCnames{ii} = sprintf('PC%d',ii);
end
tbl = table(group);
tbl = [tbl,array2table([eB;eW])];
tbl.Properties.VariableNames = {'Group',PCnames{1:10}};
within = table(PCnames','VariableNames',{'PC'});
rm = fitrm(tbl,'PC1-PC10~Group','WithinDesign',within,'WithinModel','PC');
mauchlytbl = mauchly(rm)
ranovatbl = ranova(rm);
mctbl_group = find_sig_mctbl(multcompare(rm,'Group','ComparisonType','bonferroni'));
mctbl_PC = find_sig_mctbl(multcompare(rm,'Group','by','PC','ComparisonType','bonferroni'),6);

%% Plot Explained Variance vs PCs

ff = makeFigureWindow__one_axes_only(2,[9 4 1.7 1.5],[0.2 0.22 0.73 0.75]);
axes(ff.ha);
ha = ff.ha;
hold on;
txs = 1:10;
mSize = 5;

mVarB = (eB); mVarW = (eW);
% semVarB = std(eB)/sqrt(size(eB,1)); semVarW = std(eW)/sqrt(size(eW,1));

c_col = 'k';
d_col = 'b';
plot(txs,mVarB,'color',c_col,'linewidth',1.5);hold on;
plot(txs,mVarW,'color',d_col,'linewidth',1.5);
% shadedErrorBar(txs,mVarB,semVarB,{'color',c_col},0.7);
% shadedErrorBar(txs,mVarW,semVarW,{'color',d_col},0.7);
xlim([0.75 10.25]);
ylim([0 50]);
ylabel('Explained Variance');
xlabel('Principal Component');
set(ha,'FontSize',7,'FontWeight','Bold');

% legend text
legendText = {'Black','White'};
thisCols = {c_col,d_col};
x1 = 4; x2 = x1+0.25; y1 = (45:-7:0); y1 = y1(1:2); y2 = y1;
legendFontSize = 7;
len = [5 5];
for ii = 1:length(legendText)
    plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
    text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
end


saveFileName = 'ExplainedVarianceVsPCs.pdf';
folder = fullfile(mainFolder,'pdfs');
if ~exist(folder,'dir')
    mkdir(folder);
end
saveFileName = fullfile(folder,saveFileName);
save2pdf(saveFileName,ff.hf,600);

%%
ff = makeFigureWindow__one_axes_only(2,[9 4 1.7 1.5],[0.2 0.22 0.73 0.75]);
axes(ff.ha);
ha = ff.ha;
hold on;
txs = 1:10;
mSize = 5;

mVarB = (fdb); mVarW = (fdw);
% semVarB = std(eB)/sqrt(size(eB,1)); semVarW = std(eW)/sqrt(size(eW,1));

c_col = 'k';
d_col = 'b';
plot(txs,mVarB,'color',c_col,'linewidth',1.5);hold on;
plot(txs,mVarW,'color',d_col,'linewidth',1.5);
% shadedErrorBar(txs,mVarB,semVarB,{'color',c_col},0.7);
% shadedErrorBar(txs,mVarW,semVarW,{'color',d_col},0.7);
xlim([0.75 10.25]);
ylim([1.75 2.75]);
ylabel('Fractal Dimension');
xlabel('Principal Component');
set(ha,'FontSize',7,'FontWeight','Bold');

% legend text
legendText = {'Black','White'};
thisCols = {c_col,d_col};
x1 = 4; x2 = x1+0.25; y1 = (2.65:-0.1:0); y1 = y1(1:2); y2 = y1;
legendFontSize = 7;
len = [5 5];
for ii = 1:length(legendText)
    plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
    text(x2+0.15,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
end

saveFileName = 'FractalDimensionPCs_motion.pdf';
folder = fullfile(mainFolder,'pdfs');
if ~exist(folder,'dir')
    mkdir(folder);
end
saveFileName = fullfile(folder,saveFileName);
save2pdf(saveFileName,ff.hf,600);