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
fns = f_start:(f_start+33);
fns = fns(end);
p = get_all_params(handles,fns(1),fns(end));


azw = getParameter(handles,'Auto Zoom Window');
dzw = [100 200 -120 0];
% dzw = [25 50 130 264];
lzw = azw + dzw;

ff = makeFigureRowsCols(101,[22 5.5 5.9 1.3],'RowsCols',[1 5],...
    'spaceRowsCols',[0.03 0.02],'rightUpShifts',[0.01 0.01],'widthHeightAdjustment',...
    [-20 -10]);
zf = 5;
set(ff.hf,'color','w','Position',[0.2 0.2 (4.4*zf) (1.5*zf)]);
axis tight manual
fn= 175;
for ii = 1:5
    curr_axes = ff.h_axes(1,ii);
    thisFrame = frames{fn};
    axes(curr_axes);
    hims(ii) = imagesc(thisFrame);axis equal;axis off
%     plotTags_striking_image(handles,curr_axes,fn);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
end
pause(0.1);

for ii = 1:length(fns)
    fn = fns(ii);
    thisFrame = frames{fn};
    grayFrames(:,:,ii) = double(rgb2gray((imcomplement(thisFrame))));
end

md = get_meta_data(handles);

filename = fullfile(md.processed_data_folder,'striking_image.gif');

% for jj = 1:2
for ii = length(fns)
    fn = fns(ii);
    
    axes_num = 2;curr_axes = ff.h_axes(1,axes_num);
    thisFrame = frames{fn};
    set(hims(axes_num),'CData',thisFrame);
    axes(curr_axes);hold on;
    plot(p.left_hand.centroid(1:ii,1),p.left_hand.centroid(1:ii,2),'linewidth',4,'color','c');
    plot(p.right_hand.centroid(1:ii,1),p.right_hand.centroid(1:ii,2),'linewidth',4,'color','m');
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axes_num = 5;curr_axes = ff.h_axes(1,axes_num);
    thisFrame = (mean(grayFrames(:,:,1:ii),3));
    axes(curr_axes);
    set(hims(axes_num),'CData',thisFrame);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axes_num = 4;curr_axes = ff.h_axes(1,axes_num);
    thisFrame = (std(grayFrames(:,:,1:ii),[],3));
    axes(curr_axes);
    set(hims(axes_num),'CData',thisFrame);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axes_num = 3;curr_axes = ff.h_axes(1,axes_num);
    fn = fns(ii);
    thisFramem = motion.speedInCmPerSec(:,:,fn);    thisFramem = imresize(thisFramem,4);
    thisFrame = zeroF;
    thisFrame((azw(2)-1):(azw(4)+1),(azw(1)-2):(azw(3)+1)) = thisFramem;
    axes(curr_axes);
    set(hims(axes_num),'CData',thisFrame);
    xlim(curr_axes,[lzw(1) lzw(3)]);
    ylim(curr_axes,[lzw(2) lzw(4)]);
    
    axes_num = 1;curr_axes = ff.h_axes(1,axes_num);
    delete_text_lines(curr_axes);
    thisFrame = frames{fn};
    set(hims(axes_num),'CData',thisFrame);
    plotTags_striking_image(handles,curr_axes,fn);
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
    end
    if ii == length(fns)
        imwrite(imind,cm,'striking_image.tif','tif');
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