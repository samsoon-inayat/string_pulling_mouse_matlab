function frameNums = getAllEpochFrameNums(handles)
frameNums = [];
data = get(handles.epochs,'Data');
try
    startEnd = cell2mat(data);
    frameNums = [];
    for ii = 1:size(startEnd,1)
        frameNums = [frameNums startEnd(ii,1):startEnd(ii,2)];
    end
catch
    msgbox('Missing epochs data');
end
