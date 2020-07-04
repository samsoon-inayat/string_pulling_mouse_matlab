function strking_image

fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
handles = guidata(fh);

frames = get_frames(handles);
motion = load_motion(handles);
ent = load_entropy(handles);

zeroFRGB = zeros(size(frames{1}));
zeroF = zeroFRGB(:,:,1);

gifFlag = 1;
f_start = 175;
fns = f_start:(f_start+50);
p = get_all_params(handles,fns(1),fns(end));


azw = getParameter(handles,'Auto Zoom Window');
dzw = [100 200 -120 0];
% dzw = [25 50 130 264];
lzw = azw + dzw;
aRows = 5; aCols = 5;
ff = makeFigureRowsCols(101,[22 5.5 5.9 5.9],'RowsCols',[aRows aCols],...
    'spaceRowsCols',[-0.15 -0.2],'rightUpShifts',[-0.1 -0.2],'widthHeightAdjustment',...
    [200 200],'visibility',1);
zf = 4;
set(ff.hf,'color',[0.35 0.35 0.35],'Position',[0.2 0.2 (6*zf) (5*zf)]);
axis tight manual

axesList = [3,3;
            2,1;
            2,5;
            4,5;
            4,1;
            ];

[Cs,Rs] = meshgrid(1:aRows,1:aCols);

for rr = 1:aRows
    for cc = 1:aCols
        aPair = [Rs(rr,cc),Cs(rr,cc)];
        [loc1,loc2] = ismember(aPair,axesList,'rows');
        if ~loc1
            curr_axes = ff.h_axes(aPair(1),aPair(2)); set(curr_axes,'visible','off');
        end
    end
end

fn= 175;
for ii = 1:size(axesList,1)
    curr_axes = ff.h_axes(axesList(ii,1),axesList(ii,2));
    thisFrame = frames{fn};
    axes(curr_axes);
    hims(ii) = imagesc(thisFrame);axis equal;axis off;
%     plotTags_striking_image(handles,curr_axes,fn);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    if axesList(ii,:) == [2,1] | axesList(ii,:) == [4,1]
        changePosition(gca,[0.05 0 0 0]);
    end
    if axesList(ii,:) == [2,5] | axesList(ii,:) == [4,5]
        changePosition(gca,[-0.05 0 0 0]);
    end
end
pause(0.1);

rectangle(curr_axes,'Position',[0 0 150 200],'EdgeColor','w','linewidth',3);
annotation('rectangle',[0.3 0.25 0.4 0.5],'Color','w','linewidth',3);
annotation('line',[0 0.3],[0.5 0.5],'Color','w','linewidth',3);
annotation('line',[0.7 1],[0.5 0.5],'Color','w','linewidth',3);
annotation('line',[0.5 0.5],[0 0.25],'Color','w','linewidth',3);
annotation('line',[0.5 0.5],[0.75 1],'Color','w','linewidth',3);

for ii = 1:length(fns)
    fn = fns(ii);
    thisFrame = frames{fn};
    grayFrames(:,:,ii) = double(rgb2gray((imcomplement(thisFrame))));
end

md = get_meta_data(handles);

filename = fullfile(md.processed_data_folder,'striking_image.gif');

% for jj = 1:2
for ii = 1:length(fns)
    fn = fns(ii);
    
    axn = 5; curr_axes = ff.h_axes(axesList(axn,1),axesList(axn,2));
    thisFrame = frames{fn};
    set(hims(axn),'CData',thisFrame);
    axes(curr_axes);hold on;
    plot(p.left_hand.centroid(1:ii,1),p.left_hand.centroid(1:ii,2),'linewidth',3,'color','c');
    plot(p.right_hand.centroid(1:ii,1),p.right_hand.centroid(1:ii,2),'linewidth',3,'color','m');
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
%     axn = 5; curr_axes = ff.h_axes(axesList(axn,1),axesList(axn,2));
%     thisFrame = (mean(grayFrames(:,:,1:ii),3));
%     axes(curr_axes);
%     set(hims(axn),'CData',thisFrame);
%     xlim(curr_axes,[lzw(1) lzw(3)]);
%     ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axn = 4; curr_axes = ff.h_axes(axesList(axn,1),axesList(axn,2));
    thisFrame = (std(grayFrames(:,:,1:ii),[],3));
    axes(curr_axes);
    set(hims(axn),'CData',thisFrame);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axn = 3; curr_axes = ff.h_axes(axesList(axn,1),axesList(axn,2));
    fn = fns(ii);
    thisFramem = motion.speedInCmPerSec(:,:,fn);    thisFramem = imresize(thisFramem,4);
    thisFrame = zeroF;
    thisFrame((azw(2)-1):(azw(4)+1),(azw(1)-2):(azw(3)+1)) = thisFramem;
    axes(curr_axes);
    set(hims(axn),'CData',thisFrame);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axn = 2; curr_axes = ff.h_axes(axesList(axn,1),axesList(axn,2));
    delete_text_lines(curr_axes);
    thisFrame = frames{fn};
    set(hims(axn),'CData',thisFrame);
    plotTags_striking_image(handles,curr_axes,fn);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axn = 1; curr_axes = ff.h_axes(axesList(axn,1),axesList(axn,2));
    delete_text_lines(curr_axes);
    thisFrame = frames{fn};
    set(hims(axn),'CData',thisFrame);
%     plotTags_striking_image(handles,curr_axes,fn);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    if gifFlag
        frame = getframe(ff.hf); 
        im = frame2im(frame); 
        [imind,cm] = rgb2ind(im,256); 
        % Write to the GIF File 
        if ii == 1 
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
        else 
          imwrite(imind,cm,filename,'gif','WriteMode','append'); 
        end
        if ii == length(fns)
            imwrite(imind,cm,'striking_image.tif','tif');
        end
    end
end
% end


function delete_text_lines(ha)
h_children = get(ha,'Children');
for ii = 1:length(h_children)
    if strcmp(h_children(ii).Type,'line')
        delete(h_children(ii));
        continue;
    end
    if strcmp(h_children(ii).Type,'text')
        delete(h_children(ii));
        continue;
    end
end