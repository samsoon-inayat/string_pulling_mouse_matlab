function oMasks = get_masks_KNN (handles,fn)

oMasks.IsTitle = 'String HSV';
oMasks.IhTitle = 'Hand HSV';
oMasks.IeTitle = 'Ear HSV';
oMasks.ImTitle = 'Fur HSV';

global masks;
fmasks = masks.frameMasks;

zw = handles.md.resultsMF.zoomWindow;

% if ~get(handles.checkbox_calculate_masks_again,'Value')
    tMask = fmasks(:,fn);
    btMask = de2bi(tMask,6);
    oMasks.Im = reshape(btMask(:,1),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
    oMasks.Ie = reshape(btMask(:,2),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
    oMasks.Ih = reshape(btMask(:,3),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
    oMasks.Is = reshape(btMask(:,4),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
%     if fn > 1
        oMasks.bd = reshape(btMask(:,5),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
        oMasks.fd = reshape(btMask(:,6),zw(4)-zw(2)+1,zw(3)-zw(1)+1);
%     end
% else
%     global frames;
%     thisFrame = frames{fn};
%     thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     temp = find_masks_1(handles,thisFrame);
%     oMasks.Im = temp.Im; oMasks.Ie = temp.Ie; oMasks.Ih = temp.Ih; oMasks.Is = temp.Is;
%     if fn > 1
%         thisFramem1 = frames{fn-1};
%         thisFramem1 = thisFramem1(zw(2):zw(4),zw(1):zw(3),:);
%         bthisFrame = thisFrame - thisFramem1;
%         fthisFrame = thisFramem1 - thisFrame;
%         temp = find_mask_1(handles,bthisFrame,'hand');
%         oMasks.bd = temp.bd;
%         temp = find_mask_1(handles,fthisFrame,'hand');
%         oMasks.fd = temp.fd;
%     end
% end