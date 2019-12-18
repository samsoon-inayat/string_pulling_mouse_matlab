function vals = getRegionValues(s,param)

for ii = 1:length(s)
    cmdTxt = sprintf('vals(ii,:) = s(ii).%s;',param);
    eval(cmdTxt);
end