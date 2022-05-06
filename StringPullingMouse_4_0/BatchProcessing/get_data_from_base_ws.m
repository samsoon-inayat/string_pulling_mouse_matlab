function out = get_data_from_base_ws(varName,type)

if ~exist('type','var')
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
else
    allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs','all_file_names'};
    variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs','files_to_process'};
    for ii = 1:length(variablesToGetFromBase)
        cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
        eval(cmdTxt);
    end
    for ii = 1:3:54
        f1 = all_file_names{ii};
        f2 = all_file_names{ii+1};
        f3 = all_file_names{ii+2};
        if ~strcmp(f1(1:12),f2(1:12)) | ~strcmp(f1(1:12),f3(1:12))
            print('something wrong in file names');
            error;
        end
    end
    groups = {'r6','r7','rf'};
    indCs = {1:3:54;2:3:54;3:3:54}; 
    for ii = 1:3
        cmdTxt = sprintf('out.%s_%s = %s(indCs{ii});',varName,groups{ii},varName);
        eval(cmdTxt);
    end
end