function out = populate_multcomp_h_p(rm,mc1,mc2)
% [mVar,semVar,combs,h,p]
numBars = length(rm.ResponseNames);
barsList = [];
for ii = 1:length(rm.BetweenFactorNames)
    thisFact = rm.BetweenFactorNames{ii};
    ind = (strfind(rm.BetweenDesign.Properties.VariableNames,thisFact));
    ind = find(~cellfun(@isempty,ind));
    n(ii) = length(unique(rm.BetweenDesign{:,ind}));
end

for ii = 1:length(n)
    
end


numBars = findNumBars(rm);
length_responses = length(rm.ResponseNames);
within = rm.WithinDesign;
all_data = rm.BetweenDesign;

nBF = length(rm.BetweenFactorNames);



if length(BF) == 0
else
    
end

allRows = categorical(within{:,:});

combs = nchoosek(1:size(all_data,2),2); p = ones(size(combs,1),1); h = logical(zeros(size(combs,1),1));
if ~isempty(mcTI)
    if size(mcTI,2) == 7
        for rr = 1:size(mcTI,1)
            thisRow = mcTI(rr,:);
            Num1 = thisRow{1,1}; Num2 = thisRow{1,2};
            try
                row = [Num1 Num2]; ii = ismember(categorical(combs),row,'rows'); p(ii) = mcTI{1,5}; h(ii) = 1;
            catch
                row = [Num1 Num2]; ii = ismember((combs),row,'rows'); p(ii) = mcTI{1,5}; h(ii) = 1;
            end
        end
    else
        for rr = 1:size(mcTI,1)
            thisRow = mcTI(rr,:);
            conditionN =  thisRow{1,1}; Rtype1 = thisRow{1,2}; Rtype2 = thisRow{1,3};
            Num1 = find(ismember(allRows,[conditionN Rtype1],'rows'));
            Num2 = find(ismember(allRows,[conditionN Rtype2],'rows'));
            row = [Num1 Num2]; ii = ismember(combs,row,'rows'); p(ii) = mcTI{1,6}; h(ii) = 1;
        end
    end
end
if ~isempty(mcDays)
    if size(mcDays,2) == 7
        for rr = 1:size(mcDays,1)
            thisRow = mcDays(rr,:);
            Num1 = thisRow{1,1}; Num2 = thisRow{1,2};
            try
                row = [Num1 Num2]; ii = ismember(categorical(combs),row,'rows'); p(ii) = mcDays{1,5}; h(ii) = 1;
            catch
                row = [Num1 Num2]; ii = ismember((combs),row,'rows'); p(ii) = mcDays{1,5}; h(ii) = 1;
            end
        end
    else
        for rr = 1:size(mcDays,1)
            thisRow = mcDays(rr,:);
            Rtype =  thisRow{1,1}; Condition1 = thisRow{1,2}; Condition2 = thisRow{1,3};
            Num1 = find(ismember(allRows,[Condition1 Rtype],'rows'));
            Num2 = find(ismember(allRows,[Condition2 Rtype],'rows'));
            row = [Num1 Num2]; ii = ismember(combs,row,'rows'); p(ii) = mcDays{1,6}; h(ii) = 1;
        end
    end
end



