function viewOpticalFlow(handles,saveFileName)
saveFileName = 'opticalFlow';
if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
    [sfne,efne] = getFrameNums(handles);
    frameNums = sfne:efne;
end
handles.md = get_meta_data(handles);
frames = get_frames(handles);
motion = load_motion(handles);

mouse_color = getParameter(handles,'Mouse Color');
if strcmp(mouse_color,'Black')
    sfn = 433; efn = sfn + 6;
else
    sfn = 430; efn = sfn + 6;
end
frameNums = sfn:efn; 
nIms = length(frameNums);
frameNums = frameNums(1:5);
ff = makeFigureRowsCols(101,[22 5.5 6 4],'RowsCols',[1 nIms+1],...
    'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 -0.010],'widthHeightAdjustment',...
    [0 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[8 5.5 3.6 1.25]);
set(gcf,'color','w');

zw = getParameter(handles,'Auto Zoom Window');
motion = load_motion(handles);
uv = motion.vxy;
scale_factor = 1;
absuv = abs(uv);
for ii = 1:3%length(frameNums)
    axes(ff.h_axes(1,ii));
    fn = frameNums(ii)-1;
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    thisFrame = imresize(thisFrame,(1/motion.image_resize_factor));
    imagesc(thisFrame);
    axis equal; axis off;hold on
    hold on;
    u = real(uv(:,:,fn-sfne));
    v = imag(uv(:,:,fn-sfne));
    tauv = absuv(:,:,fn-sfne);
    u(tauv < 1) = 0;
    v(tauv < 1) = 0;
    lenx = size(u,2);
    leny = size(u,1);
    [X Y] = meshgrid(1:lenx,1:leny);
    step = 5;
    idxs = 1:step:leny;
    idys = 1:step:lenx;
    X = X(idxs,idys);
    Y = Y(idxs,idys);
    u = u(idxs,idys);
    v = v(idxs,idys);
    quiver(X,Y,u*scale_factor,v*scale_factor,'AutoScale','off','color','c','LineWidth',0.5)
    box off;
    text(10,-20,sprintf('%d',fn),'FontSize',7);
%     text(5,10,sprintf('%d',fn),'FontSize',7,'FontWeight','bold');
%     if ii == 1
%         text(1,-15,sprintf('%s',handles.md.file_name),'FontSize',8,'Interpreter','none');
%         n = 0;
%     end
end


for ii = 1:3%length(frameNums)
    axes(ff.h_axes(1,ii+3));
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    thisFrame = imresize(thisFrame,(1/motion.image_resize_factor));
    imagesc(thisFrame);
    axis equal; axis off;hold on
%     hold on;
    tauv = absuv(:,:,fn-sfne);
    imagesc(tauv);
    mins = min(tauv(:));
    maxs = max(tauv(:));
    box off;
%     text(5,10,sprintf('%d',fn),'FontSize',7,'color','w','FontWeight','bold');
end
hc = putColorBar(gca,[-0.03 0.27 0 -0.55],[min(mins) max(maxs)],7);
% pos = get(gca,'Position');
% ha = axes('Position',pos,'Visible','off');
% hc = colorbar;%('location','northoutside');
% changePosition(hc,[0 0.05 -0.01 -0.05]);
% colormap jet; mincb = min(mins); maxcb = max(maxs);
% caxis([mincb maxcb]);
% try
%     set(hc,'Ticks',[mincb maxcb],'TickLabels',{sprintf('%.1f',(mincb)),sprintf('%.1f',(maxcb))},'FontSize',7);
% catch
% end
text(1.7,0.7,'cm/sec','FontSize',7,'rotation',270);

axes(ff.h_axes(1,7));
axis off;
axes(ff.h_axes(1,8));
axis off;


if exist('saveFileName','var')
    folder = fullfile(handles.md.processed_data_folder,'pdfs');
    if ~exist(folder,'dir')
        mkdir(folder);
    end
    saveFileName = fullfile(folder,saveFileName);
    save2pdf(saveFileName,ff.hf,600);
end