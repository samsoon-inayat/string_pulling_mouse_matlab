function saveMR(handles,fn,tag,x,y,ma)
R = handles.md.resultsMF.R;
if ~isempty(R)
    Lia = ismember(R(:,[1 2]),[fn tag],'rows');
    if any(Lia)
%         if R(Lia,5) == 0
            R(Lia,:) = [fn tag x y ma];
%         end
    else
        R = [R;[fn tag x y ma]];
    end
else
    R = [R;[fn tag x y ma]];
end
while 1
    try
        handles.md.resultsMF.R = R;
        break;
    catch
    end
end