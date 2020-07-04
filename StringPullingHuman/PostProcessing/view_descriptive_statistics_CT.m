function view_descriptive_statistics_CT(handles,ds,saveFileName)

% ypos = 9:-2:0
if ~iscell(saveFileName)
display_desc_stats(handles,ds,[saveFileName '_image_sequence_CT'],101,9);  set(gcf,'Name','Image Sequence');
if ~isempty(ds.motion)
    display_desc_stats(handles,ds.motion,[saveFileName '_motion_CT'],102,7);  set(gcf,'Name','Motion');
end
else
    display_desc_stats(handles,ds,{saveFileName{1},[saveFileName{2} '_image_sequence_CT']},101,9);  set(gcf,'Name','Image Sequence');
    if ~isempty(ds.motion)
        display_desc_stats(handles,ds.motion,{saveFileName{1},[saveFileName{2} '_motion_CT']},102,7);  set(gcf,'Name','Motion');
    end
end
% display_desc_stats(handles,ds.masks.body,[saveFileName '_masks_body'],103,5);  set(gcf,'Name','Body');
% display_desc_stats(handles,ds.masks.hands,[saveFileName '_masks_hands'],104,3);  set(gcf,'Name','Hands');
% display_desc_stats(handles,ds.masks.string,[saveFileName '_masks_string'],105,1);  set(gcf,'Name','String');

function display_desc_stats(handles,ds,saveFileName,fn,ypos)
groupIndices = getGroupIndicesForFigure(1,3,3);
ff = makeFigureRowsCols(fn,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
    'spaceRowsCols',[0.05 0.15],'rightUpShifts',[0.007 0.01],'widthHeightAdjustment',...
    [-130 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 3 1.25],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

titles = {'Mean','Median','Mode'};%,'Standard Deviation','Skewness','Kurtosis'};
vars = {'mean','median','mode'};%,'standard_deviation','skewness','kurtosis'};

for cc = 1:size(groupIndices,2)
        for rr = 1:size(groupIndices,1)
            axes(ff.h_axes(rr,cc));cla;
            cmdTxt = sprintf('thisFrame = ds.%s;',vars{rr,cc});
            eval(cmdTxt);
            fd = find_FD(thisFrame);
            ent = entropy(mat2gray(thisFrame));
            sn = estimate_sharpness(mat2gray(thisFrame));
            imagesc(thisFrame);
            axis equal
            axis off;
            hold on;
            if cc == 1 && isfield(ds,'mean_mask')
                bndry = bwboundaries(ds.mean_mask);
                for ii = 1:length(bndry)
                    thisbndry = bndry{ii};
                    plot(thisbndry(:,2),thisbndry(:,1),'k','linewidth',1.5);
                end
                n = 0;
            end
%             txt = {sprintf('FD (%.2f)',fd),sprintf('EY (%.2f)',ent),sprintf('SN (%.2f)',sn)};
            txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
            txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
            text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
%             text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
            text(25,-19,titles(rr,cc),'FontSize',9,'FontWeight','normal');
            set(gca,'FontSize',7);
            hc = putColorBar(gca,[-0.05 0.27 0 -0.55],[min(thisFrame(:)) max(thisFrame(:))],7);
        end
end
colormap jet;
% saveFileName = sprintf('descriptive_statistics.pdf');

if exist('saveFileName','var')
    if iscell(saveFileName)
        save_pdf(ff.hf,saveFileName{1},saveFileName{2},600);
    else
        handles.md = get_meta_data(handles);
        folder = fullfile(handles.md.processed_data_folder,'pdfs');
        if ~exist(folder,'dir')
            mkdir(folder);
        end
    %     saveFileName = [saveFileName '_image_sequence'];
        save_pdf(ff.hf,folder,saveFileName,600);
    end
end



% groupIndices = getGroupIndicesForFigure(2,3,6);
% ff = makeFigureRowsCols(101,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
%     'spaceRowsCols',[0.05 0.08],'rightUpShifts',[0.02 0.020],'widthHeightAdjustment',...
%     [-100 -50]);
% add_window_handle(handles,ff.hf);
% set(ff.hf,'Position',[8 2.5 3.5 5]);
% set(gcf,'color','w');
% 
% titles = {'Mean','Median','Mode';'Standard Deviation','Skewness','Kurtosis'};
% vars = {'mean','median','mode';'standard_deviation','skewness','kurtosis'};
% 
% for cc = 1:size(groupIndices,2)
%         for rr = 1:size(groupIndices,1)
%             axes(ff.h_axes(rr,cc));cla;
%             cmdTxt = sprintf('thisFrame = ds.motion.%s;',vars{rr,cc});
%             eval(cmdTxt);
%             fd = BoxCountfracDim((thisFrame)-min(thisFrame(:)));
% %             fd = entropy((thisFrame)-min(thisFrame(:)));
%             imagesc(thisFrame);
%             axis equal
%             axis off;
%             text(20,size(thisFrame,1)+10,sprintf('Fractal Dim %.2f',fd),'FontSize',6,'color','k','FontWeight','normal');
%             if strcmp(titles(rr,cc),'Standard Deviation')
%                 text(-3,-15,titles(rr,cc),'FontSize',7,'FontWeight','bold');
%             else
%                 text(25,-15,titles(rr,cc),'FontSize',7,'FontWeight','bold');
%             end
%             set(gca,'FontSize',7);
%             pos = get(gca,'Position');
%             ha = axes('Position',pos,'Visible','off');
%             hc = colorbar('location','eastoutside');
%             changePosition(hc,[0.14 0.04 0 -0.07]);
%             colormap parula; minpcs = min(thisFrame(:)); maxpcs = max(thisFrame(:));
%             caxis([minpcs maxpcs]);
%             set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6);
%         end
% end
% colormap jet;
% % saveFileName = sprintf('descriptive_statistics.pdf');
% 
% if exist('saveFileName','var')
%     handles.md = get_meta_data(handles);
%     folder = fullfile(handles.md.processed_data_folder,'pdfs');
%     if ~exist(folder,'dir')
%         mkdir(folder);
%     end
%     saveFileName = fullfile(folder,saveFileName);
%     save2pdf(saveFileName,ff.hf,600);
% end
% 
% 
