function save_global_P(handles,fn,tag,pixels)
[~,globalP,~] = get_R_P_RDLC(handles);

if isempty(pixels)
    if ~isempty(globalP)
        Lia = ismember(globalP(:,[1 2]),[fn tag],'rows');
        if any(Lia)
                globalP(Lia,:) = [];
        end
    end
    set_R_P_RDLC(handles,'',globalP,'',1);
    return;
end


if ~isempty(globalP)
    Lia = ismember(globalP(:,[1 2]),[fn tag],'rows');
    if any(Lia)
        globalP(Lia,:) = [];
    end
    globalP = [globalP;[ones(size(pixels))*fn ones(size(pixels))*tag pixels]];
else
    globalP = [ones(size(pixels))*fn ones(size(pixels))*tag pixels];
end

set_R_P_RDLC(handles,'',globalP,'',1);