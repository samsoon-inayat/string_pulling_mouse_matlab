function colVals = getColors(handles,object,colorCols,intsct)

objectsMap = {'Fur';'Ears';'hands';'Nose';'String';'Background'};
intersectWith = {[2 3 4 5 6];
                [1 3 4 5 6];
                [1 2 4 5 6];
                [];
                [1 2 3 4 6];
                [1 2 3 4 5]
                };
acv{1} = getParameter(handles,'Fur Color');
acv{2} = getParameter(handles,'Ears Color');
acv{3} = getParameter(handles,'Hands Color');
acv{4} = getParameter(handles,'Nose Color');
acv{5} = getParameter(handles,'String Color');
% acv{6} = getParameter(handles,'Background Color');
acv{6} = getParameter(handles,'Hands Color Backward Difference');

colind = strcmp(objectsMap,object);
ci = find(colind);
colVals = acv{ci}(:,colorCols);


if ~intsct
    return;
end

% if strcmp(object,'Background')
%     return;
% end

iw = intersectWith{ci};
if isempty(iw)
    return;
end
oColVals = [];
for ii = 1:length(iw)
    oColVals = [oColVals;acv{iw(ii)}(:,colorCols)];
end

[C,ia,ib] = intersect(colVals,oColVals,'rows');
if ~isempty(ia)
    colVals(ia,:) = [];
end
% 
% if strcmp(object,'Fur')
%     colVals = acv{1}(:,colorCols);
%     oColVals = [acv{2}(:,colorCols);acv{3}(:,colorCols);acv{4}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
%     [C,ia,ib] = intersect(colVals,oColVals,'rows');
%     if ~isempty(ia)
%         colVals(ia,:) = [];
%     end
% end
% 
% if strcmp(object,'Ears')
%     colVals = acv{2}(:,colorCols);
%     oColVals = [acv{1}(:,colorCols);acv{3}(:,colorCols);acv{4}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
% %     oColVals = [acv{1}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
%     [C,ia,ib] = intersect(colVals,oColVals,'rows');
%     if ~isempty(ia)
%         colVals(ia,:) = [];
%     end
% end
% 
% 
% if strcmp(object,'hands')
%     colVals = acv{3}(:,colorCols);
%     oColVals = [acv{1}(:,colorCols);acv{2}(:,colorCols);acv{4}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
% %     oColVals = [acv{1}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
%     [C,ia,ib] = intersect(colVals,oColVals,'rows');
%     if ~isempty(ia)
%         colVals(ia,:) = [];
%     end
% end
% 
% if strcmp(object,'hands_bd')
% %     colVals = acv{7}(:,colorCols);
% %     oColVals = [acv{1}(:,colorCols);acv{2}(:,colorCols);acv{4}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
% %     [C,ia,ib] = intersect(colVals,oColVals,'rows');
% %     if ~isempty(ia)
% %         colVals(ia,:) = [];
% %     end
% end
% 
% 
% if strcmp(object,'Nose')
%     colVals = acv{4}(:,colorCols);
%     oColVals = [acv{2}(:,colorCols);acv{3}(:,colorCols);acv{1}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
% %     oColVals = [acv{1}(:,colorCols);acv{5}(:,colorCols);acv{6}(:,colorCols)];
%     [C,ia,ib] = intersect(colVals,oColVals,'rows');
%     if ~isempty(ia)
%         colVals(ia,:) = [];
%     end
% end
% 
% if strcmp(object,'String')
%     colVals = acv{5}(:,colorCols);
%     oColVals = [acv{2}(:,colorCols);acv{3}(:,colorCols);acv{1}(:,colorCols);acv{4}(:,colorCols);acv{6}(:,colorCols)];
%     [C,ia,ib] = intersect(colVals,oColVals,'rows');
%     if ~isempty(ia)
%         colVals(ia,:) = [];
%     end
% end
% 
