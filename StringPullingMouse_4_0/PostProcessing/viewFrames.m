function viewFrames(handles,saveFileName)
saveFileName = 'selected_frames';
if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
    [sfn,efn] = getFrameNums(handles);
    frameNums = sfn:efn;
end
handles.md = get_meta_data(handles);
frames = get_frames(handles);
mouse_color = getParameter(handles,'Mouse Color');
if strcmp(mouse_color,'Black')
    sfn = 431; efn = sfn + 6;
else
    sfn = 394; efn = sfn + 6;
end
frameNums = sfn:efn;
nIms = length(frameNums);
ff = makeFigureRowsCols(101,[22 5.5 6 4],'RowsCols',[1 nIms+1],...
    'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 -0.010],'widthHeightAdjustment',...
    [0 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[8 5.5 4 1.25]);
set(gcf,'color','w');

zw = getParameter(handles,'Auto Zoom Window');
for ii = 1:length(frameNums)
    axes(ff.h_axes(1,ii));
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    thisFrame = imresize(thisFrame,(1/1));
    imagesc(thisFrame);
    axis equal; axis off;hold on
    text(170,-100,sprintf('%d',fn),'FontSize',7);
    box off;
%     if ii == 1
%         text(1,-15,sprintf('%s',handles.md.file_name),'FontSize',8,'Interpreter','none');
%         n = 0;
%     end
end
axes(ff.h_axes(1,ii+1));
axis off;


if exist('saveFileName','var')
    folder = fullfile(handles.md.processed_data_folder,'pdfs');
    if ~exist(folder,'dir')
        mkdir(folder);
    end
    saveFileName = fullfile(folder,saveFileName);
    save2pdf(saveFileName,ff.hf,600);
end