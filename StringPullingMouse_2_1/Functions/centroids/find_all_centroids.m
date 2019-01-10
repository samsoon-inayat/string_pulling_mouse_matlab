function Cs = find_all_centroids(handles,fn,thisFrame)
% masks = getMasks(handles,fn);
M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = handles.md.resultsMF.zoomWindow;
M.scale = handles.md.resultsMF.scale;
M.frameSize = handles.d.frameSize;
Cs = [];

tMasks = get_masks_KNN(handles,fn);
Cs{1} = find_centroids(M,fn,'mouse',tMasks,thisFrame,Cs);
Cs{2} = find_centroids(M,fn,'ears',tMasks,thisFrame,Cs);
Cs{2} = findBoundary(Cs{2},size(thisFrame));
indexC = strfind(M.tags,'Left Hand');
tag = find(not(cellfun('isempty', indexC)));
LiaL = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
indexC = strfind(M.tags,'Right Hand');
tag = find(not(cellfun('isempty', indexC)));
LiaR = ismember(M.R(:,[1 2]),[fn tag(1)],'rows');
Lia = LiaL | LiaR;
if ~any(Lia) | get(handles.checkbox_over_write,'Value')
%     tMasks = find_masks(handles,thisFrame);
    if fn > 1
        try
            Cs{3} = find_centroids_hand(handles,M,fn,'hands',tMasks,thisFrame,Cs);
        catch
            Cs{3} = manuallyTagHands(handles,fn,1);
        end
    end
    if fn == 1
        Cs{3} = manuallyTagHands(handles,1,1);
%         Cs{3} = find_centroids_hand(handles,M,fn,'handsNoInitialValue',tMasks,thisFrame,Cs);
    end
    Cs{3} = findBoundary(Cs{3},size(thisFrame));
else
    Cs{1} = [];
    Cs{2} = [];
    Cs{3} = [];
end



