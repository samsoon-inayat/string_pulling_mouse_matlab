function out = checkStatusOfColors(handles)
% vars = {'text_selectHandColor','text_selectFurColor','text_selectStringColor','text_selectRtEarColor','text_selectLtEarColor'};
vars = {'pushbutton_selectHandColor','pushbutton_selectFurColor','pushbutton_selectStringColor',...
    'pushbutton_selectRtEarColor','pushbutton_selectLtEarColor','pushbutton_ears','pushbutton_selectNoseColors'};
vars = {'pushbutton_selectHandColor','pushbutton_selectFurColor','pushbutton_selectStringColor',...
    'pushbutton_ears','pushbutton_selectNoseColors','pushbutton_backgroundColor'};
colNames = {'Hands Color', 'Fur Color', 'String Color', 'Ears Color','Nose Color','Background Color'};
for ii = 1:length(colNames)
%     val = handles.md.resultsMF.colors(1,ii);
    val = getParameter(handles,colNames{ii});
    if isempty(val)
%         cmdText = sprintf('set(handles.%s,''String'',''X'',''ForegroundColor'',''r'');',vars{ii});
        cmdText = sprintf('set(handles.%s,''ForegroundColor'',''r'');',vars{ii});
        eval(cmdText);
        out(ii) = false;
    else
%         cmdText = sprintf('set(handles.%s,''String'',char(hex2dec(''2713'')),''ForegroundColor'',''g'');',vars{ii});
        cmdText = sprintf('set(handles.%s,''ForegroundColor'',''[0 0.6 0.2]'',''FontWeight'',''Bold'');',vars{ii});
        eval(cmdText);
        out(ii) = true;
    end
end
[~,~,globalRDLCS] = get_R_P_RDLC(handles);
if ~isempty(globalRDLCS)
    set(handles.checkbox_display_DLC_results,'Visible','On');
else
    set(handles.checkbox_display_DLC_results,'Visible','Off','Value',0);
end
% vars = {'text_selectHandColorDiff','text_selectStringColorDiff','text_selectHandMinusStringColorDiff'};
% colNames = {'Hands Diff Color', 'String Diff Color', 'Hands-String Diff Color'};
% for ii = 1:3
% %     val = handles.md.resultsMF.diffColors(1,ii);
%     val = getParameter(handles,colNames{ii});
%     if isempty(val)
%         cmdText = sprintf('set(handles.%s,''String'',''X'',''ForegroundColor'',''r'');',vars{ii});
%         eval(cmdText);
%         out(ii) = false;
%     else
%         cmdText = sprintf('set(handles.%s,''String'',char(hex2dec(''2713'')),''ForegroundColor'',''g'');',vars{ii});
%         eval(cmdText);
%         out(ii) = true;
%     end
% end

