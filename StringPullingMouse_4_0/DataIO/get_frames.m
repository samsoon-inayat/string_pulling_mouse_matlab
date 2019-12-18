function frames = get_frames(handles,fns)

if ~isfield(handles,'figure1')
    frames = [];
    return;
end

data = get(handles.text_data,'userdata');

if exist('fns','var')
    frames = data.frames(fns);
else
    frames = data.frames;
end
