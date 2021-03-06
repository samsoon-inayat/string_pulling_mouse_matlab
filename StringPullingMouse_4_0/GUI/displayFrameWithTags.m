function displayFrameWithTags(handles,fn,ha)
if ~exist('ha','var')
    hf = figure;clf;
    add_window_handle(handles,hf);
    ha = axes;
end
frames = get_frames(handles);
try
    zw = getParameter(handles,'Zoom Window');
catch
    zw = getParameter(handles,'Auto Zoom Window');
end
if ~isempty(zw)
    tdx = zw(1)+20;
    tdy = zw(2)+20;
else
    tdx = 50;
    tdy = 70;
end
axes(ha)
imagesc(frames{fn});
axis equal; axis off;
if isfield(handles,'figure1')
    plotTags(handles,gca,fn);
end
text(tdx,tdy,num2str(fn));
if ~isempty(zw)
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end