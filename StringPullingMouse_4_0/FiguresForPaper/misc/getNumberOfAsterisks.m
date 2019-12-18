function sigText = getNumberOfAsterisks(pvalue)
sigText = 'ns';
if pvalue < 0.05 && pvalue > 0.01
    sigText = '*'; 
end
if pvalue < 0.01 && pvalue > 0.001
    sigText = '**';
end
if pvalue < 0.001
    sigText = '***';
end