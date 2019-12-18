

function hf = displayFrameWithTags_F(handles,fn,allCs,ha)
if ~exist('ha','var')
    hf = figure(10);clf;
    ha = axes;
end
frames = get_frames(handles);
zw = getParameter(handles,'Zoom Window');
if ~isempty(zw)
    set(handles.text_zoomWindow,'String',char(hex2dec('2713')),'ForegroundColor','g');
    tdx = zw(1)+20;
    tdy = zw(2)+20;
else
    set(handles.text_zoomWindow,'String','X','ForegroundColor','r');
    tdx = 50;
    tdy = 70;
end
imagesc(frames{fn});
axis equal; axis off;
plotTags(handles,gca,fn);
text(tdx,tdy,num2str(fn));
if ~isempty(zw)
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end
Cs = allCs{2};
if ~isempty(Cs)
    if ~isempty(Cs(1).PixelList)
        xs = Cs(1).PixelList(:,1)+zw(1);
        ys = Cs(1).PixelList(:,2)+zw(2);
        plot(xs,ys,'.','color','c');
    end
    if ~isempty(Cs(2).PixelList)
        xs = Cs(2).PixelList(:,1)+zw(1);
        ys = Cs(2).PixelList(:,2)+zw(2);
        plot(xs,ys,'.','color','m');
    end
end

Cs = allCs{3};
if ~isempty(Cs)
    if strcmp(Cs(1).Hand,'Left Hand')
        CL = Cs(1); CR = Cs(2);
    else
        CL = Cs(2); CR = Cs(1);
    end
    xs = CR.PixelList(:,1)+zw(1);
    ys = CR.PixelList(:,2)+zw(2);
    plot(xs,ys,'.','color','c');
    xs = CL.PixelList(:,1)+zw(1);
    ys = CL.PixelList(:,2)+zw(2);
    plot(xs,ys,'.','color','m');
end

n = 0;

