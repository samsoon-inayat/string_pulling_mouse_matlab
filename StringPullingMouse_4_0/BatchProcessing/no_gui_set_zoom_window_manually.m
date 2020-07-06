function no_gui_set_zoom_window_manually(handles,fn)

[sfn,efn] = getFrameNums(handles);

% fn = sfn;%get(handles.figure1,'userdata');
% md = get_meta_data(handles);
data = get_data(handles);
hf = figure(10);clf;
imagesc(data.frames{fn});
grid on;
[nX,nY,~]=size(data.frames{fn});
nSeg=30;
set(gca,'xtick',linspace(0,nY,nSeg+1),'xticklabel',[],...
    'xgrid','on','xcolor','w',...
    'ytick',linspace(0,nX,nSeg+1),'ytickLabel',[],...
    'ygrid','on','ycolor','w',...
    'gridLineStyle','-','linewidth',2);
axis equal;
set(hf,'Position',get(0,'ScreenSize'));
set(hf,'WindowStyle','modal');
% axis equal; axis off;
try
    hrect = imrect(gca);
    set(hf,'WindowStyle','normal');
catch
    return;
end
% if isempty(hrect)
%     displayFrames(handles,fn);
%     return;
% end
pos = round(hrect.getPosition);
close(hf);
left = pos(1);
if left <= 0
    left = 1;
end
top = pos(2);
if top <= 0
    top = 1;
end
right = pos(1)+pos(3);
frames = data.frames;
if right > size(frames{1},2)
    right = size(frames{1},2);
end
bottom = pos(2) + pos(4);
if bottom > size(frames{1},1)
    bottom = size(frames{1},1);
end
setParameter(handles,'Auto Zoom Window',[left top right bottom]);
zw = [left top right bottom];
% handles.md.resultsMF.zoomWindow = [left top right bottom];
% set(handles.text_autoZoomWindow,'String',sprintf('[%d %d %d %d]',zw(1),zw(2),zw(3),zw(4)),'userdata',zw,'ForegroundColor','b');
%get_frames(handles);
thisFrame = frames{1}(zw(2):zw(4),zw(1):zw(3),:);
setParameter(handles,'Auto Zoom Window Size',[size(thisFrame,1) size(thisFrame,2)]);
% sfn = round(get(handles.slider1,'Value'));
% displayFrames(handles,sfn);
