function view_entropy(handles,ds,saveFileName)

ads = load_ds(handles);
% ypos = 9:-2:0
ent.f1 = ds.ent;
entm.f1 = ds.motion.ent;
if isfield(ds,'HFD')
    ent.f2 = ds.HFD.ent;
    entm.f2 = ds.HFD.motion.ent;
end
if isfield(ds,'FF')
    ent.f3 = ds.FF.ent;
    entm.f3 = ds.FF.motion.ent;
end
if isfield(ds,'pVRT')
    ent.f4 = ds.pVRT.ent;
    entm.f4 = ds.pVRT.motion.ent;
end
ent.f5 = ads.standard_deviation; entm.f5 = ads.motion.standard_deviation;
ent.f6 = ads.skewness; entm.f6 = ads.motion.skewness; 
ent.f7 = ads.kurtosis; entm.f7 = ads.motion.kurtosis;

if ~iscell(saveFileName)
    display_desc_stats(handles,ent,[saveFileName '_all'],101,9); set(gcf,'Name','Temporal Analysis Image Sequence');
    display_desc_stats(handles,entm,[saveFileName '_all'],102,7); set(gcf,'Name','Temporal Analysis Motion');
else
    display_desc_stats(handles,ent,{saveFileName{1},[saveFileName{2} 'Img Seq']},101,9); set(gcf,'Name','Temporal Analysis Image Sequence');
    display_desc_stats(handles,entm,{saveFileName{1},[saveFileName{2} 'Motion']},102,7); set(gcf,'Name','Temporal Analysis Motion');
end


function display_desc_stats(handles,ds,saveFileName,fn,ypos)
groupIndices = getGroupIndicesForFigure(1,6,6);
ff = makeFigureRowsCols(fn,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
    'spaceRowsCols',[0.05 0.07],'rightUpShifts',[0.007 0.01],'widthHeightAdjustment',...
    [-70 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 6 1.25],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

titles = {'Std. Dev.','Skewness','Kurtosis','Fano Factor','Entropy','Higuchi FD'};
vars = {'f5','f6','f7','f3','f1','f2'};
ads = load_ds(handles);
for cc = 1:size(groupIndices,2)
        for rr = 1:size(groupIndices,1)
            if cc > 6
                delete(ff.h_axes(rr,cc))
                continue;
            end
            axes(ff.h_axes(rr,cc));cla;
            cmdTxt = sprintf('thisFrame = ds.%s;',vars{rr,cc});
            try
                eval(cmdTxt);
            catch
                delete(ff.h_axes(rr,cc))
                continue;
            end
%             thisFrame = thisFrame.*mat2gray(ads.mean);
            fd = find_FD(thisFrame);
            ent = entropy(mat2gray(thisFrame));
            sn = estimate_sharpness(mat2gray(thisFrame));
            imagesc(thisFrame);
            axis equal
            axis off;
            txt = {sprintf('FD (%.2f)',fd),sprintf('EY (%.2f)',ent),sprintf('SN (%.2f)',sn)};
            txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
            text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
%             if strcmp(titles(rr,cc),'Higuchi FD')
                text(1,-19,titles(rr,cc),'FontSize',9,'FontWeight','normal');
%             else
%                 text(25,-19,titles(rr,cc),'FontSize',9,'FontWeight','normal');
%             end
            set(gca,'FontSize',7);
            hc = putColorBar(gca,[-0.02 0.27 0 -0.55],[min(thisFrame(:)) max(thisFrame(:))],7);
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



function display_desc_stats_old(handles,ds,saveFileName,fn,ypos)
groupIndices = getGroupIndicesForFigure(1,3,3);
ff = makeFigureRowsCols(fn,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
    'spaceRowsCols',[0.05 0.15],'rightUpShifts',[0.007 0.01],'widthHeightAdjustment',...
    [-130 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 3 1.25],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

titles = {'Entropy','Higuchi FD','Fano Factor'};
vars = {'f1','f2','f3'};
ads = load_ds(handles);
for cc = 1:size(groupIndices,2)
        for rr = 1:size(groupIndices,1)
            if cc > 3
                delete(ff.h_axes(rr,cc))
                continue;
            end
            axes(ff.h_axes(rr,cc));cla;
            cmdTxt = sprintf('thisFrame = ds.%s;',vars{rr,cc});
            try
                eval(cmdTxt);
            catch
                continue;
            end
%             thisFrame = thisFrame.*mat2gray(ads.mean);
            fd = find_FD(thisFrame);
            ent = entropy(mat2gray(thisFrame));
            sn = estimate_sharpness(mat2gray(thisFrame));
            imagesc(thisFrame);
            axis equal
            axis off;
            txt = {sprintf('FD (%.2f)',fd),sprintf('EY (%.2f)',ent),sprintf('SN (%.2f)',sn)};
            txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
            text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
            if strcmp(titles(rr,cc),'Higuchi FD')
                text(1,-19,titles(rr,cc),'FontSize',9,'FontWeight','normal');
            else
                text(25,-19,titles(rr,cc),'FontSize',9,'FontWeight','normal');
            end
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

