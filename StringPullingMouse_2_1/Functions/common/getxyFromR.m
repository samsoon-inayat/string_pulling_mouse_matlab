function [x,y] = getxyFromR(M,fn,tagS)
if isempty(M.R)
    x = []; y = [];
end
indexC = strfind(M.tags,tagS);
tag = find(not(cellfun('isempty', indexC)));
Lia = ismember(M.R(:,[1 2]),[fn tag],'rows');
x = M.R(Lia,3); y = M.R(Lia,4);

if isempty(x) & isfield(M,'RL')
    Lia = ismember(M.R1(:,[1 2]),[fn tag],'rows');
    x = M.R1(Lia,3); y = M.R1(Lia,4);
end