function algo_accuracy

objects = {'body','right_ear','left_ear','nose','hands'};
vals = ...
[100.00	94.18	99.67;
100.00	95.56	78.40;
99.58	92.59	74.57;
99.58	76.29	83.39];


valsB = ...
[100.00	94.18;
100.00	95.56;
99.58	92.59;
99.58	76.29];

mean(vals(1,:))
std(vals(1,:))/sqrt(length(vals(1,:)))
[mVals,semVals] = findMeanAndStandardError(vals,2);

[mVals semVals]
