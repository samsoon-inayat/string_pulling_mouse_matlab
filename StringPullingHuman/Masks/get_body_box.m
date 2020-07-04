function bodyBox = get_body_box(handles,fn,thisFrame,imrf,ow)

margin = get_margins(handles,'body');

bodyBoxes = getParameter(handles,'Body Boxes');
present = 0;
if ~isempty(bodyBoxes)
    indBodyBox = bodyBoxes(:,1) == fn;
    if sum(indBodyBox) > 0
        present = 1;
        if ~ow
            bodyBox = bodyBoxes(indBodyBox,2:5);
            return;
        end
    end
end
framesfn = thisFrame;
zw = getParameter(handles,'Zoom Window');
cF = getColors(handles,'Fur',4:6,0);
cS = getColors(handles,'String',4:6,0);
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
oFrame = thisFrame;
image_resize_factor = imrf;%str2double(get(handles.edit_reduce_image_factor,'String'));
thisFrame = imresize(thisFrame,(1/image_resize_factor));
margin = floor(margin/imrf);

binsh = floor(size(thisFrame,2)/10); binsv = floor(size(thisFrame,1)/1);Im = thisFrame(:,:,1);
fgb = find_feature_grid(handles,thisFrame,{cF,cS},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1]);
gF = fgb.xs{1};
gS = fgb.xs{2};
[~,ccF] = find(gF == 1);
[~,ccS] = find(gS == 1);
ccs = [ccF ccS];
miccs = min(ccs)-1; maccs = max(ccs)+1;
if miccs < 1
    miccs = 1;
end
if maccs > size(fgb.horiz,2)
    maccs = size(fgb.horiz,2);
end
left = fgb.horiz(1,miccs)-margin(1);
right = fgb.horiz(2,maccs)+margin(2);

if left < 1
    left = 1;
end
if right > size(thisFrame,2)
    right = size(thisFrame,2);
end

% left = image_resize_factor * left; right = image_resize_factor * right;
% if get(handles.checkbox_Reduce_Image_Size,'Value')
%     left = image_resize_factor * left; right = image_resize_factor * right;
% end
% thisFrame = oFrame(:,left:right,:);
thisFrame = thisFrame(:,left:right,:);
% figure(100);clf;imagesc(thisFrame);axis equal;title(fn);


binsh = floor(size(thisFrame,2)/1); binsv = floor(size(thisFrame,1)/10);Im = thisFrame(:,:,1);
fgb = find_feature_grid(handles,thisFrame,{cF},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1]);
gF = fgb.xs{1};
% gS = fgb.xs{2};
[ccs,~] = find(gF == 1);
miccs = min(ccs)-1;
if miccs < 1
    miccs = 1;
end
maccs = max(ccs)+1;
if maccs > size(fgb.vert,2)
    maccs = size(fgb.vert,2);
end
top = fgb.vert(1,miccs)-margin(3);
if top < 1
    top = 1;
end
% if get(handles.checkbox_Reduce_Image_Size,'Value')
%     top = image_resize_factor * top;
% end
bottom = fgb.vert(2,maccs)+margin(4);
if bottom > size(thisFrame,1)
    bottom = size(thisFrame,1);
end

top = image_resize_factor * top; bottom = image_resize_factor * bottom;
left = image_resize_factor * left; right = image_resize_factor * right;

if left < 1
    left = 1;
end
if top < 1
    top = 1;
end

if right > size(oFrame,2)
    right = size(oFrame,2);
end

if bottom > size(oFrame,1)
    bottom = size(oFrame,1);
end

left = min(left)+zw(1)-1;
top = min(top)+zw(2)-1;

right = max(right)+zw(1)-1;

bottom = max(bottom)+zw(2)-1;

if present
    bodyBoxes(indBodyBox,:) = [fn left top right bottom];
else
    bodyBoxes = [bodyBoxes;[fn left top right bottom]];
end
setParameter(handles,'Body Boxes',bodyBoxes);

bodyBox = [left,top,right,bottom];

% if plotFlag
%     zw = bodyBox;
%     hf = figure_window(handles,100);
%     oFrame = framesfn;
%     % update display
%     if get(handles.checkbox_updateDisplay,'Value')
%         figure(hf);
%         imagesc(oFrame);axis equal;
%         title(sprintf('%d - Body Box',fn));
%     %     displayFrames(handles,M.dfn,fn);
%         xlim([zw(1) zw(3)]);
%         ylim([zw(2) zw(4)]);
%         pause(0.01);
%     end
% end