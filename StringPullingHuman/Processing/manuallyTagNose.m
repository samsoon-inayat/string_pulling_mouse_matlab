function manuallyTagNose(handles,fn)

frames = get_frames(handles);
thisFrame = frames{fn};
M = populateM(handles,thisFrame,fn);
zw = M.zw;


masksMap = getParameter(handles,'Masks Order');
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
radius = 3;
try
while 1
    hf = figure(100);clf;
    set(hf,'Position',get(0,'ScreenSize'),'units','Pixels');
%     set(hf,'WindowStyle','modal');
    imagesc(thisFrame); axis equal;
    title(sprintf('Frame %d',fn));
    ha = gca;
    ht = text(10,30,sprintf('Draw window around Nose'),'color','m');
    if get(handles.checkbox_draw_region,'Value')
        hrect = imrect(gca);
        pvs = round(hrect.getPosition);
        pvs = bbox2points(pvs);
        BW = poly2mask(pvs(:,1),pvs(:,2),M.sizeMasks(1),M.sizeMasks(2));
        s = findRegions(BW);
    else
        hrect = imrect(gca);
        pos = round(hrect.getPosition);
        left = pos(1);
        if left <= 0
            left = 1;
        end
        top = pos(2);
        if top <= 0
            top = 1;
        end
        right = pos(1)+pos(3);
        if right > size(thisFrame,2)
            right = size(thisFrame,2);
        end
        bottom = pos(2) + pos(4);
        if bottom > size(thisFrame,1)
            bottom = size(thisFrame,1);
        end
        subFrame = thisFrame(top:bottom,left:right,:);
        nrows = size(subFrame,1);
        ncols = size(subFrame,2);
        colorVals = getParameter(handles,'Nose Color');
        CVs = colorVals(:,4:6);
        Ih = getThisMask(subFrame,CVs,nrows,ncols,radius);
        Ih = imfill(Ih,'holes');
        Ih = bwareaopen(Ih,100,8);
        Ih = bwconvhull(Ih,'objects');
        Ih = bwconvhull(Ih);
        Ihm = zeros(size(thisFrame(:,:,1)));
        Ihm(top:bottom,left:right) = Ih;
        s = findRegions(Ihm);
    end
    if length(s) == 1
        Cs = s;
    else
        continue;
    end
    figure(100);clf;imagesc(thisFrame);axis equal;
    title(sprintf('Frame %d',fn));
    hold on;
    for ii = 1:length(Cs)
        zm = zeros(size(thisFrame(:,:,1)));
        zm(Cs(ii).PixelIdxList) = 1;
        bnd = bwboundaries(zm);
        ys = bnd{1}(:,1);
        xs = bnd{1}(:,2);
        plot(xs,ys,'.','color','m');
        text(min(xs),min(ys),'L');
    end
    opts.Interpreter = 'tex';opts.Default = 'Yes';
    quest = 'Confirm the selected region is correct?';
    answer = questdlg(quest,'Please select',...
                      'Yes','No',opts);
    if strcmp(answer,'Yes')
        break;
    end
end
catch
    displayMessage(handles,'Could not find nose');
    return;
end


indexC = strfind(M.tags,'Nose');
tag = find(not(cellfun('isempty', indexC)));
save_global_R(handles,fn,tag,[],[],[]);
save_global_P(handles,fn,tag,[]);
pause(0.3);
saveValsNose(handles,M,fn,Cs,1);

if get(handles.checkbox_saveOnTheGo,'Value')
    save_R_P_RDLC(handles);
else
    set(handles.pushbutton_saveData,'Enable','On');
end
ofn = fn;
fn = get(handles.slider1,'Value');
displayFrames(handles,fn,ofn);
close(hf);