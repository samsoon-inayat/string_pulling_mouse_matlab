
function manuallyTag(handles,fn,tag)
if ~exist('tag','var')
    tag = generalGUIForSelection(handles.md.tags,1);
end
if tag == 0
    return;
end
frames = get_frames(handles);

thisFrame = frames{fn};
hf = figure(10);clf;
imagesc(thisFrame);
axis equal;
zw = getParameter(handles,'Zoom Window');
if ~isempty(zw)
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end
set(hf,'WindowStyle','modal');
[x,y] = ginput(1);
set(hf,'WindowStyle','normal');
% close(hf);
saveMR(handles,fn,tag,x,y,1);

% x1 = x-zw(1); y1 = y-zw(2);
% thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
% tMasks = find_masks_1(handles,thisFrame);
% 
% M.R = handles.md.resultsMF.R;
% M.tags = handles.md.tags;
% indexC = strfind(M.tags,'Subject');
% tag = find(not(cellfun('isempty', indexC)));
% Lia = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
% if ~any(Lia)
%     tags = M.tags;
%     M.zw = getParameter(handles,'Zoom Window');
%     M.scale = getParameter(handles,'Scale');
%     allCs = [];
%     allCs{1} = find_centroids(M,fn,'mouse',tMasks,thisFrame,allCs);
%     allCs{2} = find_centroids(M,fn,'ears',tMasks,thisFrame,allCs);
% 
% 
%     C = allCs{1};
%     indexC = strfind(tags,'Subject');
%     tag = find(not(cellfun('isempty', indexC)));
%     saveMR(handles,fn,tag(1),C.Centroid(1)+zw(1),C.Centroid(2)+zw(2),0);
%     indexC = strfind(tags,'Subject Props');
%     tag = find(not(cellfun('isempty', indexC)));
%     saveMR(handles,fn,tag,C.MajorAxisLength,C.MinorAxisLength,C.Orientation);
%     if length(allCs{2}) > 1
%         C = allCs{2}(2);%find_centroids(M,fn,'Left Ear');
%         if ~isempty(C.Area)
%             x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%             indexC = strfind(tags,'Left Ear');
%             tag = find(not(cellfun('isempty', indexC)));
%             saveMR(handles,fn,tag,x,y,0);
%         end
%         C = allCs{2}(1); % right ear
%         if ~isempty(C.Area)
%             x = C.Centroid(1)+zw(1);y = C.Centroid(2)+zw(2);
%             indexC = strfind(tags,'Right Ear');
%             tag = find(not(cellfun('isempty', indexC)));
%             saveMR(handles,fn,tag,x,y,0);
%         end
%     end
% end
% close(hf);
% displayMasks(handles,fn);
fn = round(get(handles.slider1,'Value'));
displayFrames(handles,fn);
