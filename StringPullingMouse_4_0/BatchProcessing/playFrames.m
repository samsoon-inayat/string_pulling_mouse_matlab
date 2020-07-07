function playFrames(handles,incr)

% epochs = getParameter(handles,'Epochs');
% sfn = epochs{epochNum,1};
% efn = epochs{epochNum,2};
h = figure(1001);clf;
ha = axes;
md = get_meta_data(handles);
try
for ii = 1:incr:length(handles.data.frames)
    displayFrameWithTags(handles,ii,ha);
    pause(0.1);
end
catch
    rethrow(lasterror);
end
% displayMasks(handles,fn);
% set(handles.pushbutton_stopPlay,'Visible','Off');
% set(hObject,'Visible','On');
close(h);