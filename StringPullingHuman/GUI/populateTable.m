function populateTable(handles)
epochs = getParameter(handles,'Epochs');
if isempty(epochs)
    return;
end
eends = epochs{2};
estarts = epochs{1};
ml = max([length(estarts) length(eends)]);
data = cell(ml,2);
data(1:length(estarts),1) = num2cell(estarts);
data(1:length(eends),2) = num2cell(eends);
set(handles.epochs,'Data',data);