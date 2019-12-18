function headBox = get_head_box_from_msint(handles,fn,thisFrame,msint,varargin)

margin = get_margins(handles,'head');
radius = 1;%getParameter(handles,'Range Search Radius');
boxes = getParameter(handles,'Head Boxes from msint');
present = 0;
% if ~isempty(boxes)
%     indHeadBox = boxes(:,1) == fn;
%     if sum(indHeadBox) > 0
%         present = 1;
%         if ~get(handles.checkbox_over_write,'Value')
%             headBox = boxes(indHeadBox,2:5);
%             if nargin == 5
%                 zw = headBox;
%                 hf = figure_window(handles,100);
%                 % update display
%                 if get(handles.checkbox_updateDisplay,'Value')
%                     figure(hf);
%                     imagesc(thisFrame);axis equal;
%                     title(sprintf('%d - Head Box',fn));
%                 %     displayFrames(handles,M.dfn,fn);
%                     xlim([zw(1) zw(3)]);
%                     ylim([zw(2) zw(4)]);
%                     pause(0.01);
%                 end
%             end
%             return;
%         end
%     end
% end
cE = getColors(handles,'Ears',4:6,0);
cB = getColors(handles,'Fur',4:6,0);
oFrame = thisFrame;

rowX = msint(1);
colX = msint(2);

% bodyBox = get_body_box(handles,fn,thisFrame,16);
bodyBox = getParameter(handles,'Auto Zoom Window');
leftB = bodyBox(1); topB = bodyBox(2); rightB = bodyBox(3); bottomB = bodyBox(4);


% going left
incrdecr = 3;

cols = colX:-incrdecr:leftB;
if isempty(cols)
    cols = colX:-1:leftB;
end

for ii = 1:length(cols)
    col = cols(ii);
    thisRow = thisFrame(topB:bottomB,col,:);
    mtr = getThisMask(thisRow,cE,size(thisRow(:,:,1),1),size(thisRow(:,:,1),2),radius);
    mtrB = getThisMask(thisRow,cB,size(thisRow(:,:,1),1),size(thisRow(:,:,1),2),radius);
    if sum(mtr|mtrB) == 0
        break;
    end
end
left = col;
left = left - floor((left-leftB)/4);

if left < leftB
    left = leftB;
end

% going right


cols = colX:incrdecr:rightB;

for ii = 1:length(cols)
    col = cols(ii);
    thisRow = thisFrame(topB:bottomB,col,:);
    mtr = getThisMask(thisRow,cE,size(thisRow(:,:,1),1),size(thisRow(:,:,1),2),radius);
    mtrB = getThisMask(thisRow,cB,size(thisRow(:,:,1),1),size(thisRow(:,:,1),2),radius);
    if sum(mtr|mtrB) == 0
        break;
    end
end
right = col;
right = right + ceil((rightB-right)/4);

if right > rightB
    right = rightB;
end



% going up

rows = rowX:-incrdecr:topB;
if isempty(rows)
    rows = rowX:-1:topB;
end
    
for ii = 1:length(rows)
    row = rows(ii);
    thisRow = thisFrame(row,leftB:rightB,:);
    mtr = getThisMask(thisRow,cE,size(thisRow(:,:,1),1),size(thisRow(:,:,1),2),radius);
    mtrB = getThisMask(thisRow,cB,size(thisRow(:,:,1),1),size(thisRow(:,:,1),2),radius);
    if sum(mtr|mtrB) == 0
        break;
    end
end

top = row;

top = top - floor((top-topB)/2);
if top < topB
    top = topB;
end

% going down

bottom = rowX + ceil((bottomB-rowX)/3);
headBox = [left,top,right,bottom];



if present
    boxes(indHeadBox,:) = [fn headBox];
else
    boxes = [boxes;[fn headBox]];
end
setParameter(handles,'Head Boxes from msint',boxes);

if nargin == 5
    zw = headBox;
%     hf = figure_window(handles,100);
    % update display
    if get(handles.checkbox_updateDisplay,'Value')
        axes(handles.axes_main);cla
        imagesc(oFrame);axis equal;axis off;
        title(sprintf('%d - Head Box',fn));
    %     displayFrames(handles,M.dfn,fn);
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
        pause(0.01);
    end
end