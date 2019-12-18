function hf = figure_window(handles,fn,specs)

if ~isfield(handles,'figure1')
    hf = figure(fn);clf;
    return;
end

hf = figure(fn);clf;
whs = get(handles.pushbutton_close_extra_windows,'userdata');
whs{length(whs)+1} = hf;
set(handles.pushbutton_close_extra_windows,'userdata',whs);

if exist('specs','var')
    name = specs{1};
    if strcmp(name,'SameAsDisplayWindow')
        mainWindowSize = get(handles.figure1,'Position');
        screenSize = get(0,'ScreenSize');
        left = mainWindowSize(1) + mainWindowSize(3)+10;
        bottom = floor(mainWindowSize(2) - (mainWindowSize(2)/4));
        width = screenSize(3) - left - 10;
        height = screenSize(4) - bottom - 100;
        set(hf,'Position',[left bottom width height]);
    end
end