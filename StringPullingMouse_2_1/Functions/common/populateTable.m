function populateTable(handles)
eends = handles.md.resultsMF.epochEnds;
estarts = handles.md.resultsMF.epochStarts;
ml = max([length(estarts) length(eends)]);
data = cell(ml,2);
data(1:length(estarts),1) = num2cell(estarts);
data(1:length(eends),2) = num2cell(eends);
set(handles.epochs,'Data',data);