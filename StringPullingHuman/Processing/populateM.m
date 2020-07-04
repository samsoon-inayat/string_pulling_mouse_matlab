function M = populateM (handles,thisFrame,fn)
handles.md = get_meta_data(handles);
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.md.frame_size;
M.pushbutton_stop_processing = handles.pushbutton_stop_processing;
M.cmasksMap = getParameter(handles,'CMasks Order');
M.dfn = round(get(handles.slider1,'Value'));
M.TouchingHandsArea = getParameter(handles,'Touching Hands Area');
M.text_processing = handles.text_processing;
M.axes_main = handles.axes_main;
% M.Ib = get_masks(handles,fn,7);
if ~isempty(fn)
    M.wholeFrame = thisFrame;
    M.fn = fn;
    M.thisFrame = thisFrame(M.zw(2):M.zw(4),M.zw(1):M.zw(3),:);
    M.sizeMasks = [size(M.thisFrame,1) size(M.thisFrame,2)];
end