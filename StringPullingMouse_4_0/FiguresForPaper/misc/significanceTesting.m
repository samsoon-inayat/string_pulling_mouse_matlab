function out = significanceTesting(data,varargin)

% p = inputParser;
% addRequired(p,'data');
% addOptional(p,'maxY',default_maxY,@isnumeric);
% 
% parse(p,means,sems,combs,sig,varargin{:});


if isvector(data)
    %% ANOVA
    anovaVar = [];
    gr = [];
    for ii = 1:length(data)
        thisD = data{ii};
        thisDr = reshape(thisD,numel(thisD),1);
        anovaVar = [anovaVar;thisDr];
        gr = [gr;(ones(size(thisDr))*ii)];
        [mVals(ii) semVals(ii)] = findMeanAndStandardError(thisDr);
        if size(thisD,2) > 2
            try
                anovaRM(ii) = doAnovaRM(thisD);
            catch
                display('Error in repeated measures anova ... disregard if you are not testing');
                anovaRM(ii) = NaN;
            end
        else
            anovaRM(ii) = NaN;
        end
            
    end
    out.ranova = anovaRM;
    [p,tbl,stats] = anova1(anovaVar,gr,'off');%,names);
    out.anova.p = p;
    out.anova.tbl = tbl;
    out.anova.stats = stats;
    out.means = mVals;
    out.sems = semVals;
    % [p,tbl,stats] = kruskalwallis(y2wa,subst,'on');
    hf = figure(2001);
    [c,~,~,gnames] = multcompare(stats,'CType','hsd');
    out.anova.multcompare.c = c;
    out.anova.multcompare.gnames = gnames;
    close(hf);
    pdf = c(:,6);
    hdf = pdf<0.05;
    selGroups = 1:length(data);
    combs = nchoosek(1:length(selGroups),2);
    for ii = 1:size(combs,1)
        inds = ismember(c(:,[1 2]),[selGroups(combs(ii,1)) selGroups(combs(ii,2))],'rows');
        prT(ii,1) = c(inds,6);
        data1 = mean(data{selGroups(combs(ii,1))},2);
        data2 = mean(data{selGroups(combs(ii,2))},2);
        try
            [htt2(ii),ptt2(ii),citt2(ii,:),statstt2(ii)] = ttest2(reshape(data1,1,numel(data1)),reshape(data2,1,numel(data2)));
        catch
            
        end
        try
            [htt(ii),ptt(ii),citt(ii,:),statstt(ii)] = ttest(reshape(data1,1,numel(data1)),reshape(data2,1,numel(data2)));
        catch
        end
    end
    hrT = prT<0.05;
    out.anova.multcompare.h = hrT;
    out.anova.multcompare.p = prT;
    out.combs = combs;
    if exist('htt2','var')
        out.ttest2.h = htt2; out.ttest2.p = ptt2; out.ttest2.ci = citt2; out.ttest2.stats = statstt2;
    end
    if exist('htt','var')
        out.ttest.h = htt; out.ttest.p = ptt; out.ttest.ci = citt; out.ttest.stats = statstt;
    end
    


    %% Kruskal-Walis
    anovaVar = [];
    gr = [];
    for ii = 1:length(data)
        thisD = data{ii};
        thisDr = reshape(thisD,numel(thisD),1);
        anovaVar = [anovaVar;thisDr];
        gr = [gr;(ones(size(thisDr))*ii)];
    %     [mVals(ii) semVals(ii)] = findMeanAndStandardError(thisDr);
    end
    [p,tbl,stats] = kruskalwallis(anovaVar,gr,'off');%,names);
    out.kruskalwallis.p = p;
    out.kruskalwallis.tbl = tbl;
    out.kruskalwallis.stats = stats;
    % [p,tbl,stats] = kruskalwallis(y2wa,subst,'on');
    hf = figure(2001);
    [c,~,~,gnames] = multcompare(stats,'CType','hsd');
    out.kruskalwallis.multcompare.c = c;
    out.kruskalwallis.multcompare.gnames = gnames;
    close(hf);
    pdf = c(:,6);
    hdf = pdf<0.05;
    selGroups = 1:length(data);
    combs = nchoosek(1:length(selGroups),2);
    for ii = 1:size(combs,1)
        inds = ismember(c(:,[1 2]),[selGroups(combs(ii,1)) selGroups(combs(ii,2))],'rows');
        prT(ii,1) = c(inds,6);
    end
    hrT = prT<0.05;
    out.kruskalwallis.multcompare.h = hrT;
    out.kruskalwallis.multcompare.p = prT;
    return;
end

if ismatrix(data)
    if nargin > 1
        pointsToUse = varargin{1};
    else
        pointsToUse = size(data,2);
    end
    anovaVar = [];
    gr1 = [];
    gr2 = [];
    mVals = []; semVals = [];
    for ii = 1:size(data,1)
        for jj = 1:pointsToUse%size(data,2)
            thisD = data{ii,jj};
            thisDr = reshape(thisD,numel(thisD),1);
            if sum(isnan(thisDr))>0
                n = 0;
            end
            anovaVar = [anovaVar;thisDr];
            gr1 = [gr1;(ones(size(thisDr))*ii)];
            gr2 = [gr2;(ones(size(thisDr))*jj)];
            [mVals(ii,jj) semVals(ii,jj)] = findMeanAndStandardError(thisDr);
        end
    end
%     
%     groupType = ['1' '2' '3' '4']';
%     rmT = table(groupType,mVals(:,1),mVals(:,2),mVals(:,3),mVals(:,4),mVals(:,5),mVals(:,6)...
%     ,mVals(:,7),mVals(:,8),mVals(:,9),mVals(:,10),'VariableNames',{'Group','Center1','Center2','Center3',...
%     'Center4','Center5','Center6','Center7','Center8','Center9','Center10'});
%     Centers = [1:10]';
%     rm = fitrm(rmT,'Center1-Center10~Group','WithinDesign',Centers);
%     mauchlytbl = mauchly(rm)
%     ranovatbl = ranova(rm);
%     mcTbl = multcompare(rm,'Group','By','Time','ComparisonType','tukey-kramer')
%     mcTbl = multcompare(rm,'Group','ComparisonType','tukey-kramer')
%     mcTbl = multcompare(rm,'Time','ComparisonType','tukey-kramer')

    inds = isnan(anovaVar);
    [p,tbl,stats] = anovan(anovaVar,{gr1,gr2},'model','full','varnames',{'gr1','gr2'},'display','off');
    out.anova.p = p;
    out.anova.tbl = tbl;
    out.anova.stats = stats;
    out.means = mVals;
    out.sems = semVals;
    % [p,tbl,stats] = kruskalwallis(y2wa,subst,'on');
    hf = figure(2001);
    [c,~,~,gnames] = multcompare(stats,'CType','hsd','Dimension',[1 1]);
    out.anova.multcompare.c = c;
    out.anova.multcompare.gnames = gnames;
    close(hf);
    pdf = c(:,6);
    hdf = pdf<0.05;
    selGroups = 1:size(data,1);
    combs = nchoosek(1:length(selGroups),2);
    for ii = 1:size(combs,1)
        inds = ismember(c(:,[1 2]),[selGroups(combs(ii,1)) selGroups(combs(ii,2))],'rows');
        prT(ii,1) = c(inds,6);
    end
    hrT = prT<0.05;
    out.anova.multcompare.h = hrT;
    out.anova.multcompare.p = prT;
    out.combs = combs;
    out.gr1 = gr1;
    out.gr2 = gr2;
    n = 0;
end


function out = doAnovaRM(trials) % trials have columns as timed trials and each row is individual animal/entity
cmdTxt = 'rmT = table(';
for ii = 1:(size(trials,2)-1)
    cmdTxt = [cmdTxt sprintf('trials(:,%d),',ii)];
end
cmdTxt = [cmdTxt sprintf('trials(:,%d),''VariableNames'',{',ii+1)];
for ii = 1:(size(trials,2)-1)
    cmdTxt = [cmdTxt sprintf('''Trial%d'',',ii)];
end
cmdTxt = [cmdTxt sprintf('''Trial%d''});',ii+1)];
eval(cmdTxt);
% 
% rmT = table(trials(:,1),trials(:,2),trials(:,3)...
% ,trials(:,4),trials(:,5),trials(:,6)...
% ,trials(:,7),trials(:,8),trials(:,9)...
% ,trials(:,10),'VariableNames',{'Trial1','Trial2','Trial3',...
% 'Trial4','Trial5','Trial6','Trial7','Trial8','Trial9','Trial10'});
Time = [1:size(trials,2)]';
rm = fitrm(rmT,'Trial1-Trial10~1','WithinDesign',Time);
mauchlytbl = mauchly(rm);
ranovatbl = ranova(rm);
mcTbl = multcompare(rm,'Time','ComparisonType','tukey-kramer');
% sigs = mcTbl{:,5}<0.05
% mcTbl(sigs,:)
out.model = rm;
out.table = ranovatbl;
out.mauchlytbl = mauchlytbl;
if mauchlytbl.pValue < 0.05
    out.p = ranovatbl.pValueGG;
else
    out.p = ranovatbl.pValue;
end
combs = nchoosek(Time,2);
for ii = 1:size(combs,1)
    inds = ismember(mcTbl{:,[1 2]},[Time(combs(ii,1)) Time(combs(ii,2))],'rows');
    prT(ii,1) = mcTbl{inds,5};
end
hrT = prT<0.05;
out.multcompare.table = mcTbl;
out.multcompare.h = hrT;
out.multcompare.p = prT;
out.multcompare.combs = combs;