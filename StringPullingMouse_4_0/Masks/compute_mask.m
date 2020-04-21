function mask = compute_mask(handles,frame1,object,mc)
if get(handles.radiobutton_KNN,'Value')
    mask = compute_masks_KNN_select(handles,frame1,object,mc);
end
% if get(handles.radiobutton_GridWay,'Value')
%     grid_specs = get_grid_specs(handles);
%     [success,mask] = find_mask_grid_way(handles,frame1,getColors(handles,objectsMap{ind},4:6,0),grid_specs);
%     if ~success
% %                 mask = compute_masks_range_search(handles,frame1,object,0);
%         continue;
%     end
% end
if get(handles.radiobutton_Simple,'Value')
    mask = compute_masks_range_search_select(handles,frame1,object,mc);
end