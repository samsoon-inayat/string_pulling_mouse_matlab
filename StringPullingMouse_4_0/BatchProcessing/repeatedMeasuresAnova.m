function out = repeatedMeasuresAnova(between,within,varargin)


% p = inputParser;
% addRequired(p,'between',@isnumeric);
% addOptional(p,'dimension',1,@isnumeric);
% addOptional(p,'decimal_places',3,@isnumeric);
% addOptional(p,'do_mean','Yes');
% parse(p,between,varargin{:});
% 
% dimension = p.Results.dimension;
% decimal_places = p.Results.decimal_places;


b_varNames = between.Properties.VariableNames;

between_factors = 0;
for ii = 1:length(b_varNames)
    cmdTxt = sprintf('colClass = class(between.%s);',b_varNames{ii});
    eval(cmdTxt);
    if strcmp(colClass,'categorical')
        between_factors = between_factors + 1;
    end
end

within_factors = size(within,2);
n=0;
%%
if between_factors == 1 && within_factors == 1
    wilk_text = '';
    for ii = 2:size(between,2)
        wilk_text = [wilk_text between.Properties.VariableNames{ii} ','];
    end
    wilk_text(end) = '~';
    wilk_text = [wilk_text between.Properties.VariableNames{1}];
    rm = fitrm(between,wilk_text);
    rm.WithinDesign = within;
    rm.WithinModel = within.Properties.VariableNames{1};
    out.rm = rm;
    out.ranova = rm.ranova('WithinModel',rm.WithinModel);
    mc_between_by_within = find_sig_mctbl(multcompare(rm,between.Properties.VariableNames{1},'By',within.Properties.VariableNames{1},'ComparisonType','bonferroni'),6);
    mc_within_by_between = find_sig_mctbl(multcompare(rm,within.Properties.VariableNames{1},'By',between.Properties.VariableNames{1},'ComparisonType','bonferroni'),6);
    mc_between = find_sig_mctbl(multcompare(rm,between.Properties.VariableNames{1},'ComparisonType','bonferroni'),5);
    mc_within = find_sig_mctbl(multcompare(rm,within.Properties.VariableNames{1},'ComparisonType','bonferroni'),5);
    est_margmean = margmean(rm,{between.Properties.VariableNames{1},within.Properties.VariableNames{1}});
    combs = nchoosek(1:size(est_margmean,1),2); p = ones(size(combs,1),1);
    if ~isempty(mc_between_by_within)
        for ii = 1:size(mc_between_by_within,1)
            wit = mc_between_by_within{ii,1};
            bet1 = mc_between_by_within{ii,2};
            num1 = find(ismember(est_margmean{:,1:2},[bet1,wit],'rows'));
            bet2 = mc_between_by_within{ii,3};
            num2 = find(ismember(est_margmean{:,1:2},[bet2,wit],'rows'));
            ind = find(ismember(combs,[num1,num2],'rows'));
            p(ind) = mc_between_by_within{ii,6};
        end
    end
    if ~isempty(mc_within_by_between)
        for ii = 1:size(mc_within_by_between,1)
            bet = mc_within_by_between{ii,1};
            wit1 = mc_within_by_between{ii,2};
            num1 = find(ismember(est_margmean{:,1:2},[bet,wit1],'rows'));
            wit2 = mc_within_by_between{ii,3};
            num2 = find(ismember(est_margmean{:,1:2},[bet,wit2],'rows'));
            ind = find(ismember(combs,[num1,num2],'rows'));
            p(ind) = mc_within_by_between{ii,6};
        end
    end
    out.mc_between = mc_between;
    out.mc_within = mc_within;
    out.mc_between_by_within = mc_between_by_within;
    out.mc_within_by_between = mc_within_by_between;
    out.est_marginal_means = est_margmean;
    out.combs = combs;
    out.p = p;
    return;
end
%%
if between_factors == 1 && within_factors == 2
    wilk_text = '';
    for ii = 2:size(between,2)
        wilk_text = [wilk_text between.Properties.VariableNames{ii} ','];
    end
    wilk_text(end) = '~';
    wilk_text = [wilk_text between.Properties.VariableNames{1}];
    rm = fitrm(between,wilk_text);
    rm.WithinDesign = within;
    rm.WithinModel = [within.Properties.VariableNames{1} '*' within.Properties.VariableNames{2}];
    out.rm = rm;
    out.ranova = rm.ranova('WithinModel',rm.WithinModel);
    mc_between_by_within = find_sig_mctbl(multcompare(rm,between.Properties.VariableNames{1},'By',within.Properties.VariableNames{1},'ComparisonType','bonferroni'),6);
    mc_within_by_between = find_sig_mctbl(multcompare(rm,within.Properties.VariableNames{1},'By',between.Properties.VariableNames{1},'ComparisonType','bonferroni'),6);
    mc_between = find_sig_mctbl(multcompare(rm,between.Properties.VariableNames{1},'ComparisonType','bonferroni'),5);
    mc_within = find_sig_mctbl(multcompare(rm,within.Properties.VariableNames{1},'ComparisonType','bonferroni'),5);
    est_margmean = margmean(rm,{between.Properties.VariableNames{1},within.Properties.VariableNames{1}});
    combs = nchoosek(1:size(est_margmean,1),2); p = ones(size(combs,1),1);
    if ~isempty(mc_between_by_within)
        for ii = 1:size(mc_between_by_within,1)
            wit = mc_between_by_within{ii,1};
            bet1 = mc_between_by_within{ii,2};
            num1 = find(ismember(est_margmean{:,1:2},[bet1,wit],'rows'));
            bet2 = mc_between_by_within{ii,3};
            num2 = find(ismember(est_margmean{:,1:2},[bet2,wit],'rows'));
            ind = find(ismember(combs,[num1,num2],'rows'));
            p(ind) = mc_between_by_within{ii,6};
        end
    end
    if ~isempty(mc_within_by_between)
        for ii = 1:size(mc_within_by_between,1)
            bet = mc_within_by_between{ii,1};
            wit1 = mc_within_by_between{ii,2};
            num1 = find(ismember(est_margmean{:,1:2},[bet,wit1],'rows'));
            wit2 = mc_within_by_between{ii,3};
            num2 = find(ismember(est_margmean{:,1:2},[bet,wit2],'rows'));
            ind = find(ismember(combs,[num1,num2],'rows'));
            p(ind) = mc_within_by_between{ii,6};
        end
    end
    out.mc_between = mc_between;
    out.mc_within = mc_within;
    out.mc_between_by_within = mc_between_by_within;
    out.mc_within_by_between = mc_within_by_between;
    out.est_marginal_means = est_margmean;
    out.combs = combs;
    out.p = p;
    return;
end