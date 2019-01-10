function coincident = findIfCoincident(handles,s,sbD)
areaTh = getParameter(handles,'Touching Hands Area');
coincident = 0;
if length(s) == 1 & length(sbD) < 2
    coincident = 1;
    return;
else
    for ii = 1:length(s)
        areas(ii) = s(ii).Area;%*scale;
    end
    if sum(areas > areaTh) == 1 & length(sbD) < 2
        coincident = find(areas>areaTh);
        return;
    end
end
