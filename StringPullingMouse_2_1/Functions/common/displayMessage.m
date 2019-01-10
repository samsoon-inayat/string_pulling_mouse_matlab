function displayMessage(handles,msg,props)

set(handles.text_processing,'String',msg);
if exist('props','var')
    for ii = 1:2:length(props)
        set(handles.text_processing,props{ii},props{ii+1});
    end
end
pause(0.01);