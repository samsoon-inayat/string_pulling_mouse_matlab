function CVs = findValsAroundMean(colorVals,numberOfVals)

if ~exist('numberOfVals','var')
    numberOfVals(1) = 2; % number of standard deviations
    numberOfVals(2) = 30; % total number of values
end

mCV = mean(colorVals(:,1:3));
sCV = std(colorVals(:,1:3));
for ii = 1:3
    CVs(:,ii) = (linspace(mCV(ii)-(numberOfVals(1)*sCV(ii)),mCV(ii)+(numberOfVals(1)*sCV(ii)),numberOfVals(2)))';
end


[rr,cc]  = find(CVs < 0);
if ~isempty(rr)
    CVs(rr,:) = [];
end