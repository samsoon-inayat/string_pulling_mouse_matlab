function groupIndices1 = getGroupIndicesForFigure(numberOfRows,numberOfCols,numberOfData)

% numberOfRows = 5;
% numberOfCols = 5;
graphsOnOneFigure = numberOfRows * numberOfCols;
numberOfGroups = ceil(numberOfData/graphsOnOneFigure);
% numberOfFullGroups = floor(numberOfData/graphsOnOneFigure);
indices = NaN(1,(numberOfGroups*graphsOnOneFigure));
indices(1:numberOfData) = 1:numberOfData;
groupIndices = reshape(indices,numberOfCols,numberOfRows,numberOfGroups);
for gg = 1:numberOfGroups
    groupIndices1(:,:,gg) = groupIndices(:,:,gg)';
end

