function viewICs_min_max(handles,ics,saveFileName)

if ~iscell(saveFileName)
    plot_ics_min_max(handles,101,8,ics,[saveFileName '_img_seq_and_motion']);
    set(gcf,'name','ICs of Image Sequence and Speed Frames');
    plot_ics_min_max(handles,102,5,ics.pc,[saveFileName '_pc_and_motion']);
    set(gcf,'name','ICs of PCs of Image Sequence and Speed Frames');
else
    plot_ics_min_max(handles,101,8,ics,{saveFileName{1},[saveFileName{2} '_img_seq_and_motion']});
    set(gcf,'name','ICs of Image Sequence and Speed Frames');
    plot_ics_min_max(handles,102,5,ics.pc,{saveFileName{1},[saveFileName{2} '_pc_and_motion']});
    set(gcf,'name','ICs of PCs of Image Sequence and Speed Frames');
end


function plot_ics_min_max(handles,fn,ypos,ics,saveFileName)
ic = ics.ics;
icm = ics.ics_motion;
% mouse_color = getParameter(handles,'Mouse Color');
comps = ic.Z';
compsm = icm.Z';
nIms = 4;
ff = makeFigureRowsCols(fn,[22 5.5 2.49 4],'RowsCols',[1 nIms],...
    'spaceRowsCols',[0.03 0.075],'rightUpShifts',[0.01 0.00],'widthHeightAdjustment',...
    [-80 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[10 ypos 3.49 1.6]);
set(gcf,'color','w');
nstd = 7;

str1 = {'Max Projection','Min Projection','Max Projection','Min Projection'};
str2 = {'Image Sequence','Image Sequence','Speed Frames','Speed Frames'};

for ii = 1:4
    axes(ff.h_axes(1,ii));
    switch ii
        case 1
%             if strcmp(mouse_color,'Black')
%                 thisFrame = -min(comps,[],2);
%             else
                thisFrame = max(comps,[],2);
%             end
        case 2
%             if strcmp(mouse_color,'Black')
%                 thisFrame = -max(comps,[],2);
%             else
                thisFrame = min(comps,[],2);
%             end
        case 3
            thisFrame = max(compsm,[],2);
        case 4
            thisFrame = min(compsm,[],2);
    end
    thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
    fd = find_FD(thisFrame);
    ent = entropy(mat2gray(thisFrame));
    sn = estimate_sharpness(mat2gray(thisFrame));
%     if strcmp(mouse_color,'Black')
%         imagesc(imcomplement(thisFrame));
%     else
        imagesc(thisFrame);
%     end
    text(1,-35,{str2{ii},str1{ii}},'FontSize',7);
    txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
    text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
    axis equal; axis off; box off;
    pos = get(gca,'Position');
    ha(ii) = axes('Position',pos,'Visible','off');
    hc = colorbar;
    changePosition(ha(ii),[-0.04 0.27 0 -0.55]);
    colormap jet; minpcs = min(thisFrame(:)); maxpcs = max(thisFrame(:));
    try
        caxis([minpcs maxpcs]);
        set(hc,'Ticks',[minpcs maxpcs],'TickLabels',[],'FontSize',6);
        poshc = get(hc,'Position');
        text(1.3,-0.1,sprintf('%.1f',(minpcs)),'FontSize',7);
        text(1.3,1.1,sprintf('%.1f',(maxpcs)),'FontSize',7);
    catch
    end
    
end
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