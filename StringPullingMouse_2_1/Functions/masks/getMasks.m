function masks = getMasks(handles,fn)
try
    masks.Im = handles.masksM(:,:,fn);
    masks.Ih = handles.masksH(:,:,fn);
    masks.Is = handles.masksS(:,:,fn);
catch
    masks = [];
end
