
function displayMasksOnTheGo(handles,fn,thisFrame,tMasks)
rows = 2; cols = 3;
hf = figure(1000);clf;
set(hf,'Name','Masks Window');
subplot(rows,cols,1);
imagesc(thisFrame);axis equal;
title(fn);
subplot(rows,cols,2);
imagesc(tMasks.Im);axis equal;
title(tMasks.ImTitle);
subplot(rows,cols,3);
imagesc(tMasks.Ih);axis equal;
title(tMasks.IhTitle);
subplot(rows,cols,4);
imagesc(tMasks.Is);axis equal;
title(tMasks.IsTitle);
subplot(rows,cols,5);
imagesc(tMasks.Ie);axis equal;
title(tMasks.IeTitle);
% subplot(rows,cols,6);
