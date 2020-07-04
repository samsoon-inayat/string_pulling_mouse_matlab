function view_descriptive_statistics_masks(handles,ds,saveFileName)
% ypos = 9:-2:0

if ~iscell(saveFileName)
    display_desc_stats(handles,ds.masks.body,[saveFileName '_masks_body'],101,9); set(gcf,'Name','Body');
    display_desc_stats(handles,ds.masks.ears,[saveFileName '_masks_ears'],102,7); set(gcf,'Name','Ears');
    display_desc_stats(handles,ds.masks.hands,[saveFileName '_masks_hands'],103,5); set(gcf,'Name','Hands');
    display_desc_stats(handles,ds.masks.nose,[saveFileName '_masks_nose'],104,3); set(gcf,'Name','Nose');
%     display_desc_stats(handles,ds.masks.string,{saveFileName{1},[saveFileName{2} '_masks_string']},104,5); set(gcf,'Name','String');
else
%     display_desc_stats(handles,ds.masks.body,{saveFileName{1},[saveFileName{2} '_masks_body']},101,9); set(gcf,'Name','Body');
%     display_desc_stats(handles,ds.masks.ears,{saveFileName{1},[saveFileName{2} '_masks_ears']},102,7); set(gcf,'Name','Ears');
%     display_desc_stats(handles,ds.masks.hands,{saveFileName{1},[saveFileName{2} '_masks_hands']},103,5); set(gcf,'Name','Hands');
%     display_desc_stats(handles,ds.masks.nose,{saveFileName{1},[saveFileName{2} '_masks_nose']},104,3); set(gcf,'Name','Nose');
%     display_desc_stats(handles,ds.masks.string,{saveFileName{1},[saveFileName{2} '_masks_string']},104,5); set(gcf,'Name','String');
    display_desc_stats_std(handles,ds.masks,{saveFileName{1},[saveFileName{2} '_masks_behn_std']},104,3); set(gcf,'Name','Std');
end

function display_desc_stats(handles,ds,saveFileName,fn,ypos)
groupIndices = getGroupIndicesForFigure(1,6,6);
ff = makeFigureRowsCols(fn,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
    'spaceRowsCols',[0.05 0.051],'rightUpShifts',[0.005 0.01],'widthHeightAdjustment',...
    [-60 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 6.9 1.5],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

titles = {'Mean','Median','Mode','Standard Deviation','Skewness','Kurtosis'};
vars = {'mean','median','mode','standard_deviation','skewness','kurtosis'};

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
            txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
            text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
%             text(-3,size(thisFrame,1)+20,sprintf('FD (%.2f), Ent (%.2f)',fd,ent),'FontSize',7,'color','k','FontWeight','normal');
            if strcmp(titles(rr,cc),'Standard Deviation')
                text(-3,-15,titles(rr,cc),'FontSize',7,'FontWeight','bold');
            else
                text(25,-15,titles(rr,cc),'FontSize',7,'FontWeight','bold');
            end
            set(gca,'FontSize',7);
            if sum(thisFrame(:)) ~= 0
                pos = get(gca,'Position');
                ha = axes('Position',pos,'Visible','off');
                hc = colorbar('location','eastoutside');
                changePosition(hc,[0.068 0.15 0 -0.3]);
                colormap jet; minpcs = min(thisFrame(:)); maxpcs = max(thisFrame(:));
                try
                    caxis([minpcs maxpcs]);
                    set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%d',round(minpcs)),sprintf('%d',round(maxpcs))},'FontSize',7);
                catch
                end
            end
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


function display_desc_stats_std(handles,ds,saveFileName,fn,ypos)
groupIndices = getGroupIndicesForFigure(1,4,4);
ff = makeFigureRowsCols(fn,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
    'spaceRowsCols',[0.05 0.041],'rightUpShifts',[0.005 0.02],'widthHeightAdjustment',...
    [-60 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 3.5 1.5],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

titles = {'Body','Ears','Nose','Hands'};
varsds = {'body','ears','nose','hands'};
vars = {'standard_deviation','standard_deviation','standard_deviation','standard_deviation'};

ind = 1;
for cc = 1:size(groupIndices,2)
        for rr = 1:size(groupIndices,1)
            axes(ff.h_axes(rr,cc));cla;
            cmdTxt = sprintf('thisFrame = ds.%s.%s;',varsds{rr,cc},vars{rr,cc});
            eval(cmdTxt);
            maxs(ind) = max(thisFrame(:)); mins(ind) = min(thisFrame(:));
            ind = ind + 1;
        end
end
allmin = min(mins);
allmax = max(maxs);
for cc = 1:size(groupIndices,2)
        for rr = 1:size(groupIndices,1)
            axes(ff.h_axes(rr,cc));cla;
            cmdTxt = sprintf('thisFrame = ds.%s.%s;',varsds{rr,cc},vars{rr,cc});
            eval(cmdTxt);
            fd = find_FD(thisFrame);
            ent = entropy(mat2gray(thisFrame));
            sn = estimate_sharpness(mat2gray(thisFrame));
            imagesc(thisFrame,[allmin allmax]);
            axis equal
            axis off;
%             text(-3,size(thisFrame,1)+30,{sprintf('FD (%.2f)',fd),sprintf('Ent (%.2f)',ent)},'FontSize',7,'color','k','FontWeight','normal');
            txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
            text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
            if strcmp(titles(rr,cc),'Standard Deviation')
                text(-3,-15,titles(rr,cc),'FontSize',7,'FontWeight','bold');
            else
                text(25,-15,titles(rr,cc),'FontSize',7,'FontWeight','bold');
            end
            set(gca,'FontSize',7);
            if strcmp(varsds{rr,cc},'hands')
                pos = get(gca,'Position');
                ha = axes('Position',pos,'Visible','off');
                hc = colorbar('location','eastoutside');
                changePosition(ha,[-0.03 0.2 0 -0.5]);
                colormap jet; minpcs = allmin; maxpcs = allmax;
                try
                    caxis([minpcs maxpcs]);
                    set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',(minpcs)),sprintf('%.1f',(maxpcs))},'FontSize',7);
                catch
                end
            end
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

