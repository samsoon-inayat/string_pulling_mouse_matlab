function viewFrames_ICs(handles,ics,saveFileName)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end
if isfield(handles,'figure1')
    handles.md = get_meta_data(handles);
    saveFileName = 'selected_frames_ICs';
    ics = load_ics(handles);
end

if ~iscell(saveFileName)
    plot_ics_frames(handles,101,8,ics,[saveFileName '_img_seq']);
    set(gcf,'name','ICs of Image Sequence and Speed Frames');
    plot_ics_frames(handles,102,5,ics.pc,[saveFileName '_motion']);
    set(gcf,'name','ICs of PCs of Image Sequence and Speed Frames');
else
    plot_ics_frames(handles,101,8,ics,{saveFileName{1},[saveFileName{2} '_img_seq']});
    set(gcf,'name','ICs of Image Sequence and Speed Frames');
    plot_ics_frames(handles,102,5,ics.pc,{saveFileName{1},[saveFileName{2} '_motion']});
    set(gcf,'name','ICs of PCs of Image Sequence and Speed Frames');
end

function plot_ics_frames(handles,fn,ypos,ics,saveFileName)
ic = ics.ics;
mouse_color = getParameter(handles,'Mouse Color');
if strcmp(mouse_color,'Black')
    comps = ic.Z';
    mi = 11; ma = 0;%20;
else
    comps = ic.Z';
    mi = 17; ma = 1.5;
end
% if ~isempty(strfind(handles.md.file_name,'Sim_Data'))
%     mi = 13.5; ma = -3.55;
% end
minpcs = -15;%min(comps(:))+mi;
maxpcs = 30;%max(comps(:))-ma;
frameNums = 1:10;
nIms = 5;
ff = makeFigureRowsCols(fn,[22 5.5 6 4],'RowsCols',[1 nIms+1],...
    'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 -0.010],'widthHeightAdjustment',...
    [0 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[8 ypos 3.5 2]);
set(gcf,'color','w');
nstd = 7;

zw = getParameter(handles,'Zoom Window');
for ii = 1:nIms%length(frameNums)
    fn = frameNums(ii);
    axes(ff.h_axes(1,ii));
    
    thisFrame = reshape(comps(:,fn),ics.nrows,ics.ncols);
    imagesc(thisFrame,[minpcs maxpcs]);hold on;
    text(20,-20,sprintf('IC %d',fn),'FontSize',7);
     mval = mean(thisFrame(:));
    sval = std(thisFrame(:));
    thresh = mval + nstd * sval;
    threshN = mval - nstd * sval;
    [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',0.5,'ShowText','off','Color','r');
    [M,Cntr] = contour(thisFrame,[threshN threshN],'LineWidth',0.5,'ShowText','off','Color','m');
    
    axis equal; axis off;hold on
    box off;
end
ha_hc = ff.h_axes(1,ii+1);
axes(ff.h_axes(1,ii+1));
axis off;
% if isempty(strfind(handles.md.file_name,'Sim_Data'))
hc = colorbar;
changePosition(ha_hc,[-0.2 0.3 0 -0.65]);
colormap jet;
% caxis([minpcs maxpcs]);
% set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6)

try
    caxis([minpcs maxpcs]);
    set(hc,'Ticks',[minpcs maxpcs],'TickLabels',[],'FontSize',6);
    poshc = get(hc,'Position');
    text(1.3,-0.1,sprintf('%.1f',(minpcs)),'FontSize',7);
    text(1.3,1.1,sprintf('%.1f',(maxpcs)),'FontSize',7);
catch
end


if exist('saveFileName','var')
    if iscell(saveFileName)
        save_pdf(ff.hf,saveFileName{1},saveFileName{2},600);
    else
        folder = fullfile(handles.md.processed_data_folder,'pdfs');
        if ~exist(folder,'dir')
            mkdir(folder);
        end
        saveFileName = fullfile(folder,saveFileName);
        save2pdf(saveFileName,ff.hf,600);
    end
end


% 
% function plot_ics_frames(handles,fn,ypos,ics,saveFileName)
% % saveFileName = 'selected_frames_ICs';
% if ~exist('handles','var')
%     fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
%     handles = guidata(fh);
% end
% if isfield(handles,'figure1')
%     handles.md = get_meta_data(handles);
% end
% % ics = load_ics(handles);
% ic = ics.ics;
% mouse_color = getParameter(handles,'Mouse Color');
% if strcmp(mouse_color,'Black')
%     comps = -ic.Z';
%     mi = 11; ma = 0;%20;
% else
%     comps = ic.Z';
%     mi = 17; ma = 1.5;
% end
% % if ~isempty(strfind(handles.md.file_name,'Sim_Data'))
% %     mi = 13.5; ma = -3.55;
% % end
% minpcs = min(comps(:))+mi;
% maxpcs = max(comps(:))-ma;
% frameNums = 12:72;
% nIms = 10;
% ff = makeFigureRowsCols(fn,[22 5.5 6 4],'RowsCols',[1 nIms+1],...
%     'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 -0.010],'widthHeightAdjustment',...
%     [0 0]);
% add_window_handle(handles,ff.hf);
% set(ff.hf,'Position',[8 ypos 6.9 2]);
% set(gcf,'color','w');
% nstd = 7;
% 
% zw = getParameter(handles,'Zoom Window');
% for ii = 1:10%length(frameNums)
%     fn = frameNums(ii);
%     axes(ff.h_axes(1,ii));
%     if ii < 9%length(frameNums)
%         thisFrame = reshape(comps(:,fn),ics.nrows,ics.ncols);
%         imagesc(thisFrame,[minpcs maxpcs]);hold on;
%         text(20,-20,sprintf('IC %d',fn),'FontSize',7);
%          mval = mean(thisFrame(:));
%         sval = std(thisFrame(:));
%         thresh = mval + nstd * sval;
%         threshN = mval - nstd * sval;
%         [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',0.5,'ShowText','off','Color','r');
%         [M,Cntr] = contour(thisFrame,[threshN threshN],'LineWidth',0.5,'ShowText','off','Color','m');
%     end
%     if ii == 9 
% %         mics = max([max(comps,[],2) -min(comps,[],2)],[],2);
%         thisFrame = max(comps,[],2);
%         thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
%         fd = BoxCountfracDim((thisFrame)-min(thisFrame(:)));
%         imagesc(thisFrame);
%         mamics = thisFrame;
%         text(1,-20,sprintf('Max Projection'),'FontSize',7);
%         text(7,size(thisFrame,1)+10,sprintf('Fractal Dim %.2f',fd),'FontSize',6,'color','k','FontWeight','normal');
%     end
%     if ii == 10 
% %         mics = max([max(comps,[],2) -min(comps,[],2)],[],2);
%         thisFrame = min(comps,[],2);
%         thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
%         fd = BoxCountfracDim((thisFrame)-min(thisFrame(:)));
%         imagesc(thisFrame);
%         mimics = thisFrame;
%         text(1,-20,sprintf('Min Projection'),'FontSize',7);
%         text(7,size(thisFrame,1)+10,sprintf('Fractal Dim %.2f',fd),'FontSize',6,'color','k','FontWeight','normal');
%     end
%     axis equal; axis off;hold on
%     box off;
% end
% axes(ff.h_axes(1,ii+1));
% axis off;
% % if isempty(strfind(handles.md.file_name,'Sim_Data'))
% hc = colorbar('northoutside');
% changePosition(hc,[-0.3 0.14 -0.025 -0.05]);
% colormap jet;
% caxis([minpcs maxpcs]);
% set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6)
% 
% 
% minpcs = min(mamics(:));
% maxpcs = max(mamics(:))-ma;
% ha = axes('Position',ff.axesPos{1,ii+1});
% axis off;
% hc = colorbar('northoutside');
% changePosition(hc,[-0.19 0.14 -0.025 -0.05]);
% colormap jet;
% caxis([minpcs maxpcs]);
% set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6)
% 
% minpcs = min(mimics(:))+mi;
% maxpcs = max(mimics(:))
% ha1 = axes('Position',ff.axesPos{1,ii+1});
% axis off;
% hc = colorbar('northoutside');
% changePosition(hc,[-0.09 0.14 -0.025 -0.05]);
% colormap jet;
% caxis([minpcs maxpcs]);
% set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6)
% % end
% 
% if exist('saveFileName','var')
%     if iscell(saveFileName)
%         save_pdf(ff.hf,saveFileName{1},saveFileName{2},600);
%     else
%         folder = fullfile(handles.md.processed_data_folder,'pdfs');
%         if ~exist(folder,'dir')
%             mkdir(folder);
%         end
%         saveFileName = fullfile(folder,saveFileName);
%         save2pdf(saveFileName,ff.hf,600);
%     end
% end