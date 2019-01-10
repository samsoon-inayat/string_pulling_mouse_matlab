function saveMP(handles,fn,tag,pixels)
P = handles.md.resultsMF.P;
if ~isempty(P)
    Lia = ismember(P(:,[1 2]),[fn tag],'rows');
    if any(Lia)
        P(Lia,:) = [];
    end
    P = [P;[ones(size(pixels))*fn ones(size(pixels))*tag pixels]];
else
    P = [ones(size(pixels))*fn ones(size(pixels))*tag pixels];
end
while 1
    try
        handles.md.resultsMF.P = P;
        break;
    catch
    end
end
