

function processFrames(handles,fn,numFrames)
clc
if get(handles.pushbutton_processThisFrame,'userdata')
    set(handles.pushbutton_processMultipleFrames,'Enable','on');
    set(handles.pushbutton_processEpoch,'Enable','on');
    set(handles.pushbutton_eraseTagsThisFrame,'Enable','on');
    set(handles.pushbutton_eraseAllTags,'Enable','on');
    set(handles.pushbutton_eraseTagsMultipleFrames,'Enable','on');
    set(handles.pushbutton_userProcess,'Enable','on');
    set(handles.pushbutton_processThisFrame,'userdata',0,'String','Process Selected Frame');
    return;
else
    set(handles.pushbutton_processMultipleFrames,'Enable','off');
    set(handles.pushbutton_processEpoch,'Enable','off');
    set(handles.pushbutton_eraseTagsThisFrame,'Enable','off');
    set(handles.pushbutton_eraseAllTags,'Enable','off');
    set(handles.pushbutton_eraseTagsMultipleFrames,'Enable','off');
    set(handles.pushbutton_userProcess,'Enable','off');
    set(handles.pushbutton_processThisFrame,'userdata',1,'String','Stop Processing');
end
frames = get_frames(handles);

tags = handles.md.tags;
sfn = fn - 1;
set(handles.text_processing,'String',sprintf('Processing Frame %d',fn));
pause(0.1);
zw = getParameter(handles,'Zoom Window');
stopped = 0;
for ii = 1:numFrames
    if ~get(handles.pushbutton_processThisFrame,'userdata')
        stopped = 1;
        break;
    end
    fn = sfn + ii;
    set(handles.text_processing,'userdata',fn);
    
    thisFrame = frames{fn};
    set(handles.text_processing,'String',sprintf('Processing Frame %d',fn));
%     if fn == 1
        allCs = find_all_centroids(handles,fn,thisFrame(zw(2):zw(4),zw(1):zw(3),:));
%     else
%         allCs = find_all_centroids(handles,fn,thisFrame(zw(2):zw(4),zw(1):zw(3),:),thisFramem1(zw(2):zw(4),zw(1):zw(3),:));
%     end
    C = allCs{1};
    if isfield(C,'PixelList')
        indexC = strfind(tags,'Subject');
        tag = find(not(cellfun('isempty', indexC)));
        saveMR(handles,fn,tag(1),C.Centroid(1)+zw(1),C.Centroid(2)+zw(2),0);
        indexC = strfind(tags,'Subject Props');
        tag = find(not(cellfun('isempty', indexC)));
        saveMR(handles,fn,tag,C.MajorAxisLength,C.MinorAxisLength,C.Orientation);
    end
    if length(allCs{2}) > 1
        C = allCs{2}(2);%find_centroids(M,fn,'Left Ear');
        if isfield(C,'PixelList')
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Left Ear');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.Area);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
        C = allCs{2}(1); % right ear
        if isfield(C,'PixelList')
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Right Ear');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.Area);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind(handles.md.frameSize,pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
    end
    if fn > 1
        M.R = handles.md.resultsMF.R;
        M.tags = tags;
        [xl,yl] = getxyFromR(M,fn-1,'Left Hand');
        [xr,yr] = getxyFromR(M,fn-1,'Right Hand');
    else
        xr = []; xl = [];
    end
%     if ~isempty(xr) && ~isempty(xl)
    if ~isempty(allCs{3})
        Cs = allCs{3};%find_centroids(M,fn,'Right Hand_A');
        if strcmp(Cs(1).Hand,'Left Hand')
            C = Cs(1);
        else
            C = Cs(2);
        end
        if ~isempty(C)
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Left Hand');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.manual);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind([size(thisFrame,1) size(thisFrame,2)],pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
        % C = find_centroids(M,fn,'Right Hand_A');
        if strcmp(Cs(1).Hand,'Right Hand')
            C = Cs(1);
        else
            C = Cs(2);
        end
        if ~isempty(C)
            x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
            indexC = strfind(tags,'Right Hand');
            tag = find(not(cellfun('isempty', indexC)));
            saveMR(handles,fn,tag,x,y,C.manual);
            pixels = [(C.xb + zw(1)) (C.yb + zw(2))];
            pixelsI = sub2ind([size(thisFrame,1) size(thisFrame,2)],pixels(:,2),pixels(:,1));
            saveMP(handles,fn,tag,pixelsI);
        end
    end
%     hf = displayFrameWithTags_F(handles,fn,allCs);
%     displayMasks(handles,fn,allCs);
    if numFrames > 1 & mod(ii,5) == 0
        displayFrames(handles,sfn+1);
    end
    pause(0.1);
end
if ~stopped
%     displayFrames(handles,sfn+1);
end
set(handles.pushbutton_processMultipleFrames,'Enable','on');
set(handles.pushbutton_processEpoch,'Enable','on');
set(handles.pushbutton_eraseTagsThisFrame,'Enable','on');
set(handles.pushbutton_eraseAllTags,'Enable','on');
set(handles.pushbutton_eraseTagsMultipleFrames,'Enable','on');
set(handles.pushbutton_userProcess,'Enable','on');
set(handles.pushbutton_processThisFrame,'userdata',0,'String','Process Selected Frame');
ht = text(10,10,'Done!','FontSize',50);
pause(1);
delete(ht);
% displayFrames(handles,sfn+1);

