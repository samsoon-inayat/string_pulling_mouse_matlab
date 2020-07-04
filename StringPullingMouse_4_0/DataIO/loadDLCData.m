function globalRDLCS = loadDLCData(handles,fileName,object)
% [~,~,globalRDLCS] = get_R_P_RDLC(handles);
globalRDLCS = [];
M = populateM(handles,[],[]);
if strcmp(object,'Hands')
    NN = xlsread(fileName);
    indexC = strfind(M.tags,'Right Hand'); tagR = find(not(cellfun('isempty', indexC)));
    indexC = strfind(M.tags,'Left Hand'); tagL = find(not(cellfun('isempty', indexC)));
    allRows = [NN(:,1) ones(size(NN(:,1)))*tagR NN(:,2) NN(:,3) NN(:,4)];
    globalRDLCS = [globalRDLCS;allRows];
    allRows = [NN(:,1) ones(size(NN(:,1)))*tagL NN(:,5) NN(:,6) NN(:,7)];
    globalRDLCS = [globalRDLCS;allRows];
end

if strcmp(object,'Ears')
    NN = xlsread(fileName);
    xrsn = NN(:,2)'; yrsn = NN(:,3)'; xlsn = NN(:,5)'; ylsn = NN(:,6)';
    pr = NN(:,4)'; pl = NN(:,7); 
    indexC = strfind(M.tags,'Right Ear'); tagR = find(not(cellfun('isempty', indexC)));
    indexC = strfind(M.tags,'Left Ear'); tagL = find(not(cellfun('isempty', indexC)));
    allRows = [NN(:,1) ones(size(NN(:,1)))*tagR NN(:,2) NN(:,3) NN(:,4)];
    globalRDLCS = [globalRDLCS;allRows];
    allRows = [NN(:,1) ones(size(NN(:,1)))*tagL NN(:,5) NN(:,6) NN(:,7)];
    globalRDLCS = [globalRDLCS;allRows];
end


if strcmp(object,'Nose')
    NN = xlsread(fileName);
    indexC = strfind(M.tags,'Nose'); tagR = find(not(cellfun('isempty', indexC)));
    allRows = [NN(:,1) ones(size(NN(:,1)))*tagR NN(:,2) NN(:,3) NN(:,4)];
    globalRDLCS = [globalRDLCS;allRows];
end

if strcmp(object,'All')
    alphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    NN = xlsread(fileName);
    [num,headers,raw] = xlsread(fileName,1,sprintf('A2:%s2',alphabets(size(NN,2))));
    indexC = strfind(M.tags,'Right Hand'); tagRH = find(not(cellfun('isempty', indexC)));
    indexC = strfind(M.tags,'Left Hand'); tagLH = find(not(cellfun('isempty', indexC)));
    indexC = strfind(M.tags,'Right Ear'); tagRE = find(not(cellfun('isempty', indexC)));
    indexC = strfind(M.tags,'Left Ear'); tagLE = find(not(cellfun('isempty', indexC)));
    indexC = strfind(M.tags,'Nose'); tagN = find(not(cellfun('isempty', indexC)));
    objects = {'right hand','left hand','right ear','left ear','nose'};
    tags = [tagRH,tagLH,tagRE,tagLE,tagN];
    for ii = 1:length(objects)
        indexC = strfind(headers,objects{ii}); cols = find(not(cellfun('isempty', indexC)));
        allRows = [NN(:,1) ones(size(NN(:,1)))*tags(ii) NN(:,cols(1)) NN(:,cols(2)) NN(:,cols(3))];
        globalRDLCS = [globalRDLCS;allRows];
    end
end