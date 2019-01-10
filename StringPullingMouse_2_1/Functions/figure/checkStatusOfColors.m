function out = checkStatusOfColors(handles)
vars = {'text_selectHandColor','text_selectFurColor','text_selectStringColor','text_selectEarColor'};
for ii = 1:4
    val = handles.md.resultsMF.colors(1,ii);
    if isempty(val{1})
        cmdText = sprintf('set(handles.%s,''String'',''X'',''ForegroundColor'',''r'');',vars{ii});
        eval(cmdText);
        out(ii) = false;
    else
        cmdText = sprintf('set(handles.%s,''String'',char(hex2dec(''2713'')),''ForegroundColor'',''g'');',vars{ii});
        eval(cmdText);
        out(ii) = true;
    end
end
vars = {'text_selectHandColorDiff','text_selectStringColorDiff','text_selectHandMinusStringColorDiff'};
for ii = 1:3
    val = handles.md.resultsMF.diffColors(1,ii);
    if isempty(val{1})
        cmdText = sprintf('set(handles.%s,''String'',''X'',''ForegroundColor'',''r'');',vars{ii});
        eval(cmdText);
        out(ii) = false;
    else
        cmdText = sprintf('set(handles.%s,''String'',char(hex2dec(''2713'')),''ForegroundColor'',''g'');',vars{ii});
        eval(cmdText);
        out(ii) = true;
    end
end

