function viewICs(handles,ic,saveFileName)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end


[sfn,efn] = getFrameNums(handles);
frameNums = sfn:efn;
handles.md = get_meta_data(handles);
pc = load_pcs(handles);
ics = load_ics(handles);
ic = ics.ics_image_sequence;
% ic = ics.ics_image_sequence_no_string;
% ic = ics.ics_body_ears_nose;
% ic = ics.ics_string;
% ic = ics.ics_hands;
groupIndices = getGroupIndicesForFigure(2,3,6);
ff = makeFigureRowsCols(101,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
    'spaceRowsCols',[0.05 0.08],'rightUpShifts',[0.02 0.010],'widthHeightAdjustment',...
    [-100 -50]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[8 2.5 3.49 4]);
set(gcf,'color','w');

titles = {'Image Sequence','Image Sequence (no string)','Body';'String','Hands',''};
vars = {'ics_image_sequence','ics_image_sequence_no_string','ics_body_ears_nose';'ics_string','ics_hands',''};

titles = {'Image Sequence','','';'','',''};
vars = {'ics_image_sequence','','';'','',''};

mouse_color = getParameter(handles,'Mouse Color');

for cc = 1:size(groupIndices,2)
        for rr = 1:size(groupIndices,1)
            if isempty(vars{rr,cc})
                delete(ff.h_axes(rr,cc));
                continue;
            end
            axes(ff.h_axes(rr,cc));cla;
            cmdTxt = sprintf('ic = ics.%s;',vars{rr,cc});
            eval(cmdTxt);
            if strcmp(mouse_color,'Black')
                comps =  -ic.Z';%(sevi,:)';
            else
                comps =  ic.Z';
            end
%             minpcs = min(comps(:));
%             maxpcs = max(comps(:));
            mics = max([max(comps,[],2) -min(comps,[],2)],[],2);
            thisFrame = max(comps,[],2);
            thisFrame = reshape(thisFrame,ics.nrows,ics.ncols);
            fd = BoxCountfracDim(thisFrame);
            imagesc(thisFrame);
            axis equal
            axis off;
            if strcmp(titles{rr,cc},'Image Sequence')
                text(1,-15,sprintf('%s (%.2f)',titles{rr,cc},fd),'FontSize',6);
            else
                text(30,-15,sprintf('%s (%.2f)',titles{rr,cc},fd),'FontSize',6);
            end
            set(gca,'FontSize',7);
            pos = get(gca,'Position');
            ha = axes('Position',pos,'Visible','off');
            hc = colorbar('location','eastoutside');
            changePosition(hc,[0.14 0.04 0 -0.07]);
            colormap parula; minpcs = min(thisFrame(:)); maxpcs = max(thisFrame(:));
            caxis([minpcs maxpcs]);
            set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6);
        end
end
colormap jet;
saveFileName = sprintf('all_ics.pdf');

if exist('saveFileName','var')
    handles.md = get_meta_data(handles);
    folder = fullfile(handles.md.processed_data_folder,'pdfs');
    if ~exist(folder,'dir')
        mkdir(folder);
    end
    saveFileName = fullfile(folder,saveFileName);
    save2pdf(saveFileName,ff.hf,600);
end
