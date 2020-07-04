function viewNMFs(handles,nmf,saveFileName)

tpc = nmf;
plot_pcs(handles,101,9,tpc,[saveFileName '_img_seq']);

if ~isempty(nmf.motion)
tpc = nmf.motion;
plot_pcs(handles,102,6,tpc,[saveFileName 'motion']);
end


function plot_pcs(handles,fn,ypos,nmf,saveFileName)
nrows = nmf.nrows;
ncols = nmf.ncols;
nPCs = 10;
ff = makeFigureRowsCols(fn,[22 5.5 6 4],'RowsCols',[1 nPCs+1],...
    'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 -0.010],'widthHeightAdjustment',...
    [0 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 6.9 2],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

[~,minds] = max(nmf.H,[],2);
[sev,sevi] = sort(minds);
comps = nmf.W(:,sevi);

pcs = comps(:,1:nPCs);
mouse_color = getParameter(handles,'Mouse Color');
if strcmp(mouse_color,'Black')
    minpcs = min(pcs(:))+0.2;
    maxpcs = max(pcs(:))+38.6;
else
    minpcs = min(pcs(:));
    maxpcs = max(pcs(:));
end
nstd = 2;
for ii = 1:nPCs
    axes(ff.h_axes(1,ii));
    thisFrame = reshape(pcs(:,ii),nrows,ncols);
    imagesc(thisFrame,[minpcs maxpcs]);axis equal; axis off;hold on
    fd = find_FD(thisFrame);
    entv = entropy(mat2gray(thisFrame));
    afd(ii) = fd;
    mval = mean(thisFrame(:));
    sval = std(thisFrame(:));
    thresh = mval + nstd * sval;
    [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',0.5,'ShowText','off','Color','r');
    text(1,-20,sprintf('C%0d ',ii),'FontSize',7);
    text(2,size(thisFrame,1)+10,sprintf('Fractal Dim %.2f',fd),'FontSize',6,'color','k','FontWeight','normal');
%     text(1,size(thisFrame,1)+20,sprintf('PC%0d (%.2f)',ii,explained(ii)),'FontSize',8);
    box off;
%     if ii == 1
%         text(1,-15,sprintf('%s',handles.md.file_name),'FontSize',8,'Interpreter','none');
%         n = 0;
%     end
end
axes(ff.h_axes(1,ii+1));
axis off;
hc = colorbar('northoutside');
changePosition(hc,[-0.1 0.12 -0.02 -0.05]);
colormap parula;
caxis([minpcs maxpcs]);
set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6)

if exist('saveFileName','var')
    folder = fullfile(handles.md.processed_data_folder,'pdfs');
    if ~exist(folder,'dir')
        mkdir(folder);
    end
    saveFileName = fullfile(folder,saveFileName);
    save2pdf(saveFileName,ff.hf,600);
end



% 
% 
% function plot_nmfs(handles,nmf,saveFileName)
% [~,minds] = max(nmf.H,[],2);
% [sev,sevi] = sort(minds);
% groupIndices = getGroupIndicesForFigure(3,3,size(nmf.W,2));
% ff = makeFigureRowsCols(101,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)+1],...
%     'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 0.010],'widthHeightAdjustment',...
%     [0 -50]);
% add_window_handle(handles,ff.hf);
% set(ff.hf,'Position',[8 2.5 10 8]);
% set(gcf,'color','w');
% comps = nmf.W(:,sevi);
% 
% pcs = comps;%(:,1:nPCs);
% minpcs = min(pcs(:));
% maxpcs = max(pcs(:));
% nstd = 6;
% % set(ff.hf,'KeyPressFcn',@myfun);
% ii = 1;
% while 1
%     for cc = 1:size(groupIndices,2)
%         for rr = 1:size(groupIndices,1)
%             axes(ff.h_axes(rr,cc));cla;
%             title('');
%             if isnan(groupIndices(rr,cc,ii))
%                 continue;
%             end
%             thisFrame = reshape(pcs(:,groupIndices(rr,cc,ii)),pc.nrows,pc.ncols);
%             imagesc(thisFrame,[minpcs maxpcs]);axis equal; axis off;hold on
%             mval = mean(thisFrame(:));
%             sval = std(thisFrame(:));
%             thresh = mval + nstd * sval;
%             [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',0.5,'ShowText','off','Color','r');
% %             text(1,size(thisFrame,1)+20,sprintf('PC%0d (%.2f)',ii,pc.explained(ii)),'FontSize',8);
%             box off; title(groupIndices(rr,cc,ii))
%         end
%     end
%     w = 0;
%     while ~w
%         w = waitforbuttonpress;
%     end
%     % 28 leftarrow     % 29 rightarrow    % 30 uparrow    % 31 downarrow
%     value = double(get(gcf,'CurrentCharacter'));
%     if value == 29
%         ii = ii + 1;
%         if ii > size(groupIndices,3)
%             ii = size(groupIndices,3);
%         end
%     end
%     if value == 28
%         ii = ii - 1;
%         if ii < 1
%             ii = 1;
%         end
%     end
%     if value == 30
%         break;
%     end
%     n = 0;
% end
% % axes(ff.h_axes(1,ii+1));
% % axis off;
% % hc = colorbar('northoutside');
% % changePosition(hc,[-0.5 0.1 0 -0.05]);
% % colormap parula;
% % caxis([minpcs maxpcs]);
% % set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)})
% 
% 
% if exist('saveFileName','var')
%     folder = fullfile(handles.md.processed_data_folder,'pdfs');
%     if ~exist(folder,'dir')
%         mkdir(folder);
%     end
%     saveFileName = fullfile(folder,saveFileName);
%     save2pdf(saveFileName,ff.hf,600);
% end
% 
