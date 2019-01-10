function mo = findIfMoved(bdF,fdF)
if isempty(bdF) & isempty(fdF)
    mo = '00';
end

if isempty(fdF) & ~isempty(bdF)
    mo = '10';
end

if ~isempty(fdF) & isempty(bdF)
    mo = '01';
end

if ~isempty(fdF) & ~isempty(bdF)
    mo = '11';
end

