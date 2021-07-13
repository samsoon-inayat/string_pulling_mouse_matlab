function viewPCs1(handles,pc,saveFileName,varargin)

if nargin == 4
    figNums = varargin{1};
end

if ~exist('figNums','var')
    figNums = [103,104];
end

if ~iscell(saveFileName)
    tpc = pc;
    plot_pcs(handles,figNums(1),9,tpc.score,tpc.coeff,tpc.latent,tpc.tsquared,tpc.explained,tpc.mu,tpc.nrows,tpc.ncols,tpc.nFrames,[saveFileName '_img_seq']);

    if ~isempty(pc.motion)
    tpc = pc.motion;
    plot_pcs(handles,figNums(2),6,tpc.score,tpc.coeff,tpc.latent,tpc.tsquared,tpc.explained,tpc.mu,tpc.nrows,tpc.ncols,tpc.nFrames,[saveFileName 'motion']);
    end
else
    tpc = pc;
%     plot_pcs(handles,101,9,tpc.coeff,tpc.score,tpc.latent,tpc.tsquared,tpc.explained,tpc.mu,tpc.nrows,tpc.ncols,tpc.nFrames,{saveFileName{1},[saveFileName{2} '_img_seq']});
    plot_pcs_R(handles,figNums(1),9,tpc.coeff,tpc.score,tpc.latent,tpc.tsquared,tpc.explained,tpc.mu,tpc.nrows,tpc.ncols,tpc.nFrames,{saveFileName{1},[saveFileName{2} '_img_seq']});
    if ~isempty(pc.motion)
    tpc = pc.motion;
%     plot_pcs(handles,102,6,tpc.coeff,tpc.score,tpc.latent,tpc.tsquared,tpc.explained,tpc.mu,tpc.nrows,tpc.ncols,tpc.nFrames,{saveFileName{1},[saveFileName{2} 'motion']});
    plot_pcs_R(handles,figNums(2),6,tpc.coeff,tpc.score,tpc.latent,tpc.tsquared,tpc.explained,tpc.mu,tpc.nrows,tpc.ncols,tpc.nFrames,{saveFileName{1},[saveFileName{2} 'motion']});
    end
end


function plot_pcs_R(handles,fn,ypos,coeff,score,latent,tsquared,explained,mu,nrows,ncols,nFrames,saveFileName)
nPCs = 4;
groupIndices = getGroupIndicesForFigure(1,4,4);
ff = makeFigureRowsCols(fn,[22 5.5 10 15],'RowsCols',[size(groupIndices,1) size(groupIndices,2)],...
    'spaceRowsCols',[0.05 0.075],'rightUpShifts',[0.007 0.01],'widthHeightAdjustment',...
    [-80 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 3.35 1.25],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

pcs = score(:,1:nPCs);
try
    mouse_color = getParameter(handles,'Mouse Color');
catch
    mouse_color = 'White';
end
if strcmp(mouse_color,'Black')
    minpcs = min(pcs(:))+0.2;
    maxpcs = max(pcs(:))+38.6;
else
    minpcs = min(pcs(:));
    maxpcs = max(pcs(:));
end
nstd = 2;
for cc = 1:size(groupIndices,2)
    for rr = 1:size(groupIndices,1)
        axes(ff.h_axes(rr,cc));cla;
        thisFrame = reshape(pcs(:,groupIndices(rr,cc)),nrows,ncols);
        imagesc(thisFrame,[minpcs maxpcs]);axis equal; axis off;hold on
        fd = find_FD(thisFrame);
        ent = entropy(mat2gray(thisFrame));
        sn = estimate_sharpness(mat2gray(thisFrame));
        mval = mean(thisFrame(:));
        sval = std(thisFrame(:));
        thresh = mval + nstd * sval;
%         [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',2,'ShowText','off','Color','k');
        text(1,-20,sprintf('PC%0d (%.2f)',groupIndices(rr,cc),explained(groupIndices(rr,cc))),'FontSize',7);
        txt = {sprintf('FD (%.2f)',fd),sprintf('EY (%.2f)',ent),sprintf('SN (%.2f)',sn)};
        txt = sprintf('%.2f - %.2f - %.2f',ent,sn,fd);
        text(-3,size(thisFrame,1)+20,txt,'FontSize',7,'color','k','FontWeight','normal');
        box off;
        set(gca,'FontSize',7);
    end
end
hc = putColorBar(gca,[-0.045 0.27 0 -0.55],[min(minpcs) max(maxpcs)],7);

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


function plot_pcs(handles,fn,ypos,coeff,score,latent,tsquared,explained,mu,nrows,ncols,nFrames,saveFileName)
nPCs = 10;
ff = makeFigureRowsCols(fn,[22 5.5 6 4],'RowsCols',[1 nPCs+1],...
    'spaceRowsCols',[0.03 0.008],'rightUpShifts',[0.01 -0.010],'widthHeightAdjustment',...
    [0 0]);
add_window_handle(handles,ff.hf);
set(ff.hf,'Position',[9 ypos 6.9 2],'MenuBar','None','ToolBar','None');
set(gcf,'color','w');

pcs = score(:,1:nPCs);
try
    mouse_color = getParameter(handles,'Mouse Color');
catch
    mouse_color = 'White';
end
if strcmp(mouse_color,'Black')
    minpcs = min(pcs(:));%+0.2;
    maxpcs = max(pcs(:));%+38.6;
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
    ent = entropy(mat2gray(thisFrame));
    afd(ii) = fd;
    mval = mean(thisFrame(:));
    sval = std(thisFrame(:));
    thresh = mval + nstd * sval;
    [M,Cntr] = contour(thisFrame,[thresh thresh],'LineWidth',2,'ShowText','off','Color','k');
    text(1,-20,sprintf('PC%0d (%.2f)',ii,explained(ii)),'FontSize',7);
%     text(2,size(thisFrame,1)+10,sprintf('Fractal Dim %.2f',fd),'FontSize',6,'color','k','FontWeight','normal');
    text(1,size(thisFrame,1)+30,{sprintf('FD (%.2f)',fd),sprintf('Ent (%.3f)',ent)},'FontSize',7,'color','k','FontWeight','normal');
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
colormap jet;
caxis([minpcs maxpcs]);
set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',minpcs),sprintf('%.1f',maxpcs)},'FontSize',6)

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

