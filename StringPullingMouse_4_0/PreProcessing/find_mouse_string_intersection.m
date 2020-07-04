function msint = find_mouse_string_intersection(handles,fn,ow)

% if fn == 535
%     n = 0;
% end

boxes = getParameter(handles,'Mouse String Intersections');
present = 0;
if ~isempty(boxes)
    indBox = boxes(:,1) == fn;
    if sum(indBox) > 0
        present = 1;
        if ~ow
            msint = boxes(indBox,2:3);
            return;
        end
    end
end


frames = get_frames(handles);
% zw = getParameter(handles,'Auto Zoom Window');
% string_thickness = floor(getParameter(handles,'String Thickness in Pixels'));
% if isempty(string_thickness)
%     displayMessageBlinking(handles,'Measure string thickness first',{'ForegroundColor','r'},2);
%     topPoint = [];
%     return;
% end
if get(handles.checkbox_Reduce_Image_Size,'Value')
    try
        image_resize_factor = str2double(get(handles.edit_reduce_image_factor,'String'));
%         thisFrame = imresize(thisFrame,(1/image_resize_factor));
%         thisFrame = imresize(thisFrame,image_resize_factor,'OutputSize',[size(thisFrame,1) size(thisFrame,2)]);
    catch
        displayMessageBlinking(handles,'Enter a number for image resize factor',{'ForegroundColor','r'},2);
        return;
    end
else
    image_resize_factor = 16;
end
cF = getColors(handles,'Fur',4:6,0);cS = getColors(handles,'String',4:6,0);cN = getColors(handles,'Nose',4:6,0);
thisFrame = frames{fn};
[xBox,msint] = get_mouse_string_xBox(handles,fn,thisFrame,image_resize_factor,[10,10],ow);
% thisFrame = thisFrameH(xBox(2):xBox(4),xBox(1):xBox(3),:);
% % figure(hf);subplot 143;
% % imagesc(thisFrame);axis equal; axis off;
% % title('Mouse-String-X Box');
% % pause(0.1);
% 
% if ~get(handles.checkbox_use_approximations,'Value')
%     % find left right
%     binsh = 1; binsv = floor(size(thisFrame,1)/1);Im = thisFrame(:,:,1);
%     fgb = find_feature_grid(handles,thisFrame,{cS},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1 0.1]);
%     % gF = fgb.xs{1} | fgb.xs{2};
%     gS = fgb.xs{1};
%     cgS = conv(double(gS),[1 1 1],'same');
%     inds = find(cgS > 0);
%     left = min(inds); right = max(inds);
%     left = fgb.horiz(1,left);
%     right = fgb.horiz(2,right);
%     oleft = left;
%     oright = right;
%     try
%         while 1
%             thisFrame1 = thisFrame(:,left:right,:);
%             temp = getThisMask(thisFrame1,cF,size(thisFrame1(:,:,1),1),size(thisFrame1(:,:,1),2),radius);
%             temp = temp | getThisMask(thisFrame1,cN,size(thisFrame1(:,:,1),1),size(thisFrame1(:,:,1),2),radius);
% 
%             if sum(temp(:))/numel(temp) > 0.1
%                 break;
%             else
%                 left = left - 1;
%         %         right = right + 1;
%             end
%         end
%     catch
%         try
%             left = oleft;
%             while 1
%                 thisFrame1 = thisFrame(:,left:right,:);
%                 temp = getThisMask(thisFrame1,cF,size(thisFrame1(:,:,1),1),size(thisFrame1(:,:,1),2),radius);
%                 temp = temp | getThisMask(thisFrame1,cN,size(thisFrame1(:,:,1),1),size(thisFrame1(:,:,1),2),radius);
% 
%                 if sum(temp(:))/numel(temp) > 0.1
%                     break;
%                 else
%                     right = right + 1;
%             %         right = right + 1;
%                 end
%             end
%         catch
%             left = oleft; right = oright;
%         end
%     end
% 
%     thisFrame = thisFrame(:,left:right,:);
%     binsh = floor(size(thisFrame,2)/1); binsv = 1;Im = thisFrame(:,:,1);
%     fgb = find_feature_grid(handles,thisFrame,{cF,cN},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1 0.1]);
%     gF = fgb.xs{1} | fgb.xs{2};
%     cgS = conv(double(gF),[1 1],'same');
%     inds = find(cgS > 0);
% 
%     top = min(inds);
%     top = fgb.vert(1,top);
%     thisFrame1 = thisFrame(top,:,:);
%     left1 = getLeft(handles,thisFrame,cS);
% 
%     try
%         msint(1) = top + xBox(2) + hb(2);
%         msint(2) = left1 + left + xBox(1) + hb(1);
%     catch
%         msint = [NaN NaN];
%     end
%     % msint(2) = msint(2) + left1 + left2;
%     oFrame = frames{fn};
% else
%     msint(1) = floor(xBox(4)-xBox(2)/2) + hb(2);
%     msint(2) = floor(xBox(3)-xBox(1)/2) + hb(1);
% end
% 


if present
    boxes(indBox,:) = [fn msint];
else
    boxes = [boxes;[fn msint]];
end
setParameter(handles,'Mouse String Intersections',boxes);

% % update display
% if get(handles.checkbox_updateDisplay,'Value')
%     oFrame = frames{fn};
%     figure(hf);subplot 144;
%     imagesc(oFrame);axis equal; axis off;
%     hold on;
%     plot(msint(2),msint(1),'*k','markerSize',10)
%     title(sprintf('Mouse-String-X'));
% %     displayFrames(handles,M.dfn,fn);
%     xlim([zw(1) zw(3)]);
%     ylim([zw(2) zw(4)]);
%     pause(0.1);
% end


function left1 = getLeft(handles,thisFrame,cS)
binsh = 1; binsv = floor(size(thisFrame,1)/1);Im = thisFrame(:,:,1);
fgb = find_feature_grid(handles,thisFrame,{cS},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1 0.1]);
% gF = fgb.xs{1} | fgb.xs{2};
gS = fgb.xs{1};
cgS = conv(double(gS),[1 1 1],'same');
inds = find(cgS > 0);
left1 = min(inds);
left1 = fgb.horiz(1,left1);