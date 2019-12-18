function viewICs(handles,ic,saveFileName)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end


[sfn,efn] = getFrameNums(handles);
frameNums = sfn:efn;
% handles.md = get_meta_data(handles);
pc = load_pcs(handles);
ics = load_ics(handles);
ic = ics.ics;
% ic = ics.ics_image_sequence_no_string;
% ic = ics.ics_body_ears_nose;
% ic = ics.ics_string;
% ic = ics.ics_hands;
% [~,minds] = max(ic.W,[],2);
% [sev,sevi] = sort(minds);

groupIndices = getGroupIndicesForFigure(3,3,size(ic.Z',2));
ff = makeFigureRowsCols(101,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)+1],...
    'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 0.010],'widthHeightAdjustment',...
    [0 -50]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[8 2.5 10 8]);
set(gcf,'color','w');
comps =  ic.Z';%(sevi,:)';
ics = comps;%(:,1:nPCs);
minpcs = min(ics(:));
maxpcs = max(ics(:));
thisFrame = reshape(ics(:,1),pc.nrows,pc.ncols);
% frames = get_frames(handles);
zw = getParameter(handles,'Auto Zoom Window');
nstd = 10;
zf = zeros(size(thisFrame));
azf = zf;
hf = figure_window(handles,1001);
mics = max([max(ics,[],2) -min(ics,[],2)],[],2);
mics = max(ics,[],2);
% mics = std(ics,[],2);%max([median(ics,2) median(-ics,2)],[],2);
thisFrame = reshape(mics,pc.nrows,pc.ncols);
% fd = BoxCountfracDim(thisFrame)
figure(hf);clf;
imagesc(thisFrame);axis equal; axis off;colormap parula;
hc = colorbar;
save_pdf(ff.hf,saveFileName{1},saveFileName{2},600);
% save2pdf([handles.md.file_name(1:(end-4)) '_ics.pdf'],hf,600);
return
% 
for ii = 1:size(ics,2)
    thisFrame = reshape(ics(:,ii),pc.nrows,pc.ncols);
    mval = mean(thisFrame(:));
    sval = std(thisFrame(:));
    thresh = mval + nstd * sval;
    nthresh = mval - nstd * sval;
%     kval = kurtosis(thisFrame(:));
%     thresh = nstd * kval;
    inds = find(thisFrame > thresh);
    tzf = azf;
    if ~isempty(inds)
        tzf(inds) = 1;
    end
    zf(inds) = ii;
    inds = find(thisFrame < nthresh);
    if ~isempty(inds)
        tzf(inds) = 1;
    end
    zf(inds) = -ii;
    ii
end
% for jj = 1:length(frameNums)
%     fn = frameNums(jj);
%     tF = frames{fn};
%     tF = tF(zw(2):zw(4),zw(1):zw(3),:);
%     tF = imresize(tF,(1/pc.image_resize_factor));
%     tFrame = imoverlay(tF,zf);
%     figure(hf);clf;
%     imagesc(tFrame);axis equal; axis off;
%     hc = colorbar;
%     pause(0.1);
% end
figure(hf);clf;
imagesc(zf);axis equal; axis off;
hc = colorbar;
pause(0.1);
% save2pdf([handles.md.file_name(1:(end-4)) '.pdf'],hf,600);
% return;
figure(hf);clf;
imagesc(zf);axis equal; axis off;
pause(0.1);
hc = colorbar;
% set(ff.hf,'KeyPressFcn',@myfun);
ii = 1;
while 1
    for cc = 1:size(groupIndices,2)
        for rr = 1:size(groupIndices,1)
            axes(ff.h_axes(rr,cc));cla;
            title('');
            if isnan(groupIndices(rr,cc,ii))
                continue;
            end
            thisFrame = reshape(ics(:,groupIndices(rr,cc,ii)),pc.nrows,pc.ncols);
            imagesc(thisFrame,[minpcs maxpcs]);axis equal; axis off;hold on
            mval = mean(thisFrame(:));
            sval = std(thisFrame(:));
            thresh = mval + nstd * sval;
            threshN = mval - nstd * sval;
            [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',0.5,'ShowText','off','Color','r');
            [M,Cntr] = contour(thisFrame,[threshN threshN],'LineWidth',0.5,'ShowText','off','Color','m');
%             text(1,size(thisFrame,1)+20,sprintf('PC%0d (%.2f)',ii,pc.explained(ii)),'FontSize',8);
            box off; title(groupIndices(rr,cc,ii))
        end
    end
    w = 0;
    while ~w
        w = waitforbuttonpress;
    end
    % 28 leftarrow     % 29 rightarrow    % 30 uparrow    % 31 downarrow
    value = double(get(gcf,'CurrentCharacter'));
    if value == 29
        ii = ii + 1;
        if ii > size(groupIndices,3)
            ii = size(groupIndices,3);
        end
    end
    if value == 28
        ii = ii - 1;
        if ii < 1
            ii = 1;
        end
    end
    if value == 30
        break;
    end
    n = 0;
end
% axes(ff.h_axes(1,ii+1));
% axis off;
% hc = colorbar('northoutside');
% changePosition(hc,[-0.5 0.1 0 -0.05]);
% colormap parula;
% caxis([minpcs maxpcs]);
% set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)})


if exist('saveFileName','var')
    folder = fullfile(handles.md.processed_data_folder,'pdfs');
    if ~exist(folder,'dir')
        mkdir(folder);
    end
    saveFileName = fullfile(folder,saveFileName);
    save2pdf(saveFileName,ff.hf,600);
end

