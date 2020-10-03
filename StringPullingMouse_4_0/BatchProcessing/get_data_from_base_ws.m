function out = get_data(varName)

allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
groups = {'o','p','y'};
indCs = {1:16;1:8;1:10}; 
for ii = 1:3
    cmdTxt = sprintf('out.%s_%s_p = %s(ii,indCs{ii});',varName,groups{ii},varName);
    eval(cmdTxt);
    cmdTxt = sprintf('out.%s_%s_r = %s(ii+3,indCs{ii});',varName,groups{ii},varName);
    eval(cmdTxt);
end
