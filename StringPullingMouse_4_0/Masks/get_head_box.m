function headBox = get_head_box(handles,fn,thisFrame,imrf,ow)

margin = get_margins(handles,'head');
% if fn == 535
%     n = 0;
% end
boxes = getParameter(handles,'Head Boxes');
present = 0;
if ~isempty(boxes)
    indHeadBox = boxes(:,1) == fn;
    if sum(indHeadBox) > 0
        present = 1;
        if ~ow
            headBox = boxes(indHeadBox,2:5);
            return;
        end
    end
end
zw = getParameter(handles,'Zoom Window');
cF = getColors(handles,'Fur',4:6,0);
cS = getColors(handles,'String',4:6,0);
cE = getColors(handles,'Ears',4:6,0);
% oFrame = thisFrame;

bodyBox = getParameter(handles,'Auto Zoom Window');%get_body_box(handles,fn,thisFrame,16,0);
left1 = bodyBox(1); top1 = bodyBox(2); right1 = bodyBox(3); bottom1 = bodyBox(4);
oFrame = thisFrame;
% finding top of mouse fine
thisFrame = thisFrame(top1:bottom1,left1:right1,:);
image_resize_factor = imrf;%str2double(get(handles.edit_reduce_image_factor,'String'));
thisFrame = imresize(thisFrame,(1/image_resize_factor));
margin = floor(margin/imrf);
binsh = floor(size(thisFrame,2)/2); binsv = floor(size(thisFrame,1)/10);Im = thisFrame(:,:,1);
fgb = find_feature_grid(handles,thisFrame,{cF,cE},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1 0.1]);
gF = fgb.xs{1} | fgb.xs{2};
for ii = 1:size(gF,1)
    thisRow = gF(ii,:);
    if (sum(thisRow == 1)/length(thisRow)) > 0.1
        rrs = ii - 1;
        break;
    end
end
if rrs < 1
    rrs = 1;
end
top = fgb.vert(1,rrs)-margin(3);
if top < 1
    top = 1;
end
bottom = fgb.vert(2,rrs)+margin(4);
if bottom > size(thisFrame,1)
    bottom = size(thisFrame,1);
end

% % find top bottom with ears
% binsh = floor(size(thisFrame,2)/5); binsv = floor(size(thisFrame,1)/30);Im = thisFrame(:,:,1);
% fgb = find_feature_grid(handles,thisFrame,{cE},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1 0.1]);
% gF = fgb.xs{1};
% for ii = 1:size(gF,1)
%     thisRow = gF(ii,:);
%     sgF(ii,1) = sum(thisRow);
% end
% if rrs < 1
%     rrs = 1;
% end
% top = fgb.vert(1,rrs)-margin(3);
% if top < 1
%     top = 1;
% end
% bottom = fgb.vert(2,rrs)+margin(4);
% if bottom > size(thisFrame,1)
%     bottom = size(thisFrame,1);
% end



% use top bottom
thisFrame = thisFrame(top:bottom,:,:);

binsh = floor(size(thisFrame,2)/20); binsv = floor(size(thisFrame,1)/1);Im = thisFrame(:,:,1);
fgb = find_feature_grid(handles,thisFrame,{cF,cS,cE},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1 0.1]);
gF = fgb.xs{1} | fgb.xs{3}; gS = fgb.xs{1};
[~,ccsF] = find(gF);
[~,ccsS] = find(gS);

ccs = [ccsF ccsS];
miccs = min(ccs);
maccs = max(ccs);
left = fgb.horiz(1,miccs)-margin(1);
if left < 1
    left = 1;
end
right = fgb.horiz(2,maccs)+margin(2);
if right > size(thisFrame,2)
    right = size(thisFrame,2);
end

top = image_resize_factor * top; bottom = image_resize_factor * bottom;
left = image_resize_factor * left; right = image_resize_factor * right;

left = left + left1 - 1;
top = top + top1-1;
right = right + left1 - 1;
bottom = bottom + top1 - 1;
% thisFrame = thisFrame(:,left:right,:);

headBox = [left,top,right,bottom];

if present
    boxes(indHeadBox,:) = [fn headBox];
else
    boxes = [boxes;[fn headBox]];
end
setParameter(handles,'Head Boxes',boxes);

% if plotFlag
%     zw = headBox;
%     hf = figure_window(handles,100);
%     % update display
%     if get(handles.checkbox_updateDisplay,'Value')
%         figure(hf);
%         imagesc(oFrame);axis equal;
%         title(sprintf('%d - Head Box',fn));
%     %     displayFrames(handles,M.dfn,fn);
%         xlim([zw(1) zw(3)]);
%         ylim([zw(2) zw(4)]);
%         pause(0.01);
%     end
% end