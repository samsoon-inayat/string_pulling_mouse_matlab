function write_ranova_tables_to_XL(rmaR,pdfFolder,file_name)


fileName = fullfile(pdfFolder,sprintf('%s_ranova_data_results.xlsx',file_name))
if exist(fileName,'file')
    delete(fileName);
    pause(0.5);
end
write_this_table(rmaR.rm.BetweenDesign,fileName,'Between Data Table');
write_this_table(rmaR.rm.WithinDesign,fileName,'Within Data Table');
Delete_sheets_Excel(fileName,{'Sheet1','Sheet2','Sheet3'});  %To delete 2 sheets
write_this_table(rmaR.gourp_stats,fileName,'Group Stats');
write_this_table(rmaR.ranova,fileName,'RANOVA Results');
mcs = rmaR.mcs;
field_names = fields(mcs);
for ii = 1:length(field_names)
    cmdTxt = sprintf('this_table = mcs.%s;',field_names{ii}); eval(cmdTxt);
    if istable(this_table)
        write_this_table(this_table,fileName,sprintf('mc_%s',field_names{ii}));
    end
end

function write_this_table(this_table,fileName,sheet_name)
tn = 0;
while 1
    fid = fopen(fileName);
    if fid == -1
        tn = tn + 1;
        if tn < 11
            continue;
        else
            break;
        end
    end
    if fid == 3
        fclose(fid);
        pause(0.5);
        break;
    end
end

tn = 1;
while tn < 3
    try
        writetable(this_table,fileName,'Sheet',sheet_name,'WriteRowNames',true);
        break;
    catch
        disp(sprintf('Could not write in try %d',tn));
        tn = tn + 1;
    end
end
% if tn == 11
%     rethrow(lasterror);
% end