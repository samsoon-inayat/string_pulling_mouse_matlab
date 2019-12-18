function save_global_R(handles,fn,tag,x,y,ma)
[globalR,~,~] = get_R_P_RDLC(handles);

if isempty(x) && isempty(y)
    if ~isempty(globalR)
        Lia = ismember(globalR(:,[1 2]),[fn tag],'rows');
        if any(Lia)
                globalR(Lia,:) = [];
        end
    end
    set_R_P_RDLC(handles,globalR,'','',1);
    return;
end


if ~isempty(globalR)
    Lia = ismember(globalR(:,[1 2]),[fn tag],'rows');
    if any(Lia)
%         if globalR(Lia,5) == 0
            globalR(Lia,:) = [fn tag x y ma];
%         end
    else
        globalR = [globalR;[fn tag x y ma]];
    end
else
    globalR = [globalR;[fn tag x y ma]];
end
set_R_P_RDLC(handles,globalR,'','',1);