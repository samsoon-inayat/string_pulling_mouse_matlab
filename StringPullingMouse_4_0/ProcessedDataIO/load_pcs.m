function pc = load_pcs(handles)


if ~isfield(handles,'figure1')
    [sfn,efn] = getFrameNums(handles);
    pc = get_file_data(handles.pd_folder,sfn,efn,'pcs');
    return;
end

md = get_meta_data(handles);
[sfn,efn] = getFrameNums(handles);
pc = get(handles.pushbutton_find_PCs,'userdata');
if isempty(pc)
    fileName = fullfile(md.processed_data_folder,sprintf('pcs_%d_%d.mat',sfn,efn));
    if ~exist(fileName,'file')
        pc = [];
        return;
    else
        displayMessageBlinking(handles,'Please wait ... loading file',{'ForegroundColor','r'},2);
    end
    displayMessage(handles,'Please wait ... loading file');
    pc = load(fileName);
    displayMessage(handles,'');
    set(handles.pushbutton_find_PCs,'userdata',pc);
end

