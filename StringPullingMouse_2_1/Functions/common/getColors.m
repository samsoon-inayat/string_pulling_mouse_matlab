function colVals = getColors(handles,object,colorCols)

acv{1} = getParameter(handles,'Fur Color');
acv{2} = getParameter(handles,'Ears Color');
acv{3} = getParameter(handles,'Hands Color');
acv{4} = getParameter(handles,'Nose Color');
acv{5} = getParameter(handles,'String Color');

if strcmp(object,'Fur')
    colVals = acv{1}(:,colorCols);
    oColVals = [acv{2}(:,colorCols);acv{3}(:,colorCols);acv{4}(:,colorCols);acv{5}(:,colorCols)];
    [C,ia,ib] = intersect(colVals,oColVals,'rows');
    if ~isempty(ia)
        colVals(ia,:) = [];
    end
end

if strcmp(object,'Ears')
    colVals = acv{2}(:,colorCols);
    oColVals = [acv{1}(:,colorCols);acv{3}(:,colorCols);acv{4}(:,colorCols);acv{5}(:,colorCols)];
    [C,ia,ib] = intersect(colVals,oColVals,'rows');
    if ~isempty(ia)
        colVals(ia,:) = [];
    end
end


if strcmp(object,'hands')
    colVals = acv{3}(:,colorCols);
    oColVals = [acv{1}(:,colorCols);acv{2}(:,colorCols);acv{4}(:,colorCols);acv{5}(:,colorCols)];
    [C,ia,ib] = intersect(colVals,oColVals,'rows');
    if ~isempty(ia)
        colVals(ia,:) = [];
    end
end

if strcmp(object,'Nose')
    colVals = acv{4}(:,colorCols);
    oColVals = [acv{2}(:,colorCols);acv{3}(:,colorCols);acv{1}(:,colorCols);acv{5}(:,colorCols)];
    [C,ia,ib] = intersect(colVals,oColVals,'rows');
    if ~isempty(ia)
        colVals(ia,:) = [];
    end
end

if strcmp(object,'String')
    colVals = acv{5}(:,colorCols);
    oColVals = [acv{2}(:,colorCols);acv{3}(:,colorCols);acv{1}(:,colorCols);acv{4}(:,colorCols)];
    [C,ia,ib] = intersect(colVals,oColVals,'rows');
    if ~isempty(ia)
        colVals(ia,:) = [];
    end
end