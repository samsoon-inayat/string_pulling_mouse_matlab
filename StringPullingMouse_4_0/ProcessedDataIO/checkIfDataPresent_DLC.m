function [present,LiaR] = checkIfDataPresent_DLC(handles,frameNums,object)

[~,~,globalRDLCS] = get_R_P_RDLC(handles);
md = get_meta_data(handles);
M.tags = md.tags;

if isempty(globalRDLCS)
    present = 0;
    LiaR = NaN;
    return;
end

if strcmp(lower(object),'body')
    indexC = strfind(M.tags,'Subject');
    tag = find(not(cellfun('isempty', indexC)));
end

if strcmp(lower(object),'ears')
    indexC = strfind(M.tags,'Ear');
    tag = find(not(cellfun('isempty', indexC)));
end

if strcmp(lower(object),'right ear')
    indexC = strfind(M.tags,'Right Ear');
    tag = find(not(cellfun('isempty', indexC)));
end

if strcmp(lower(object),'left ear')
    indexC = strfind(M.tags,'Left Ear');
    tag = find(not(cellfun('isempty', indexC)));
end

if strcmp(lower(object),'hands')
    indexC = strfind(M.tags,'Hand');
    tag = find(not(cellfun('isempty', indexC)));
end

if strcmp(lower(object),'right hand')
    indexC = strfind(M.tags,'Right Hand');
    tag = find(not(cellfun('isempty', indexC)));
end

if strcmp(lower(object),'left hand')
    indexC = strfind(M.tags,'Left Hand');
    tag = find(not(cellfun('isempty', indexC)));
end


if strcmp(lower(object),'nose')
    indexC = strfind(M.tags,'Nose');
    tag = find(not(cellfun('isempty', indexC)));
end

if strcmp(lower(object),'string')
    present = 0;
    return;
end


if isempty(frameNums)
    tic
    for ii = 1:length(tag)
        if ii == 1
            LiaR = ismember(globalRDLCS(:,2),tag(ii),'rows');
        else
            LiaR = LiaR | ismember(globalRDLCS(:,2),tag(ii),'rows');
        end
    end
    if any(LiaR)
        present = 1;
    else
        present = 0;
    end
else
    LiaR = zeros(size(globalRDLCS,1),1);
    for ff = 1:length(frameNums)
        tic
        fn = frameNums(ff);
        for ii = 1:length(tag)
            LiaR = LiaR | ismember(globalRDLCS(:,[1 2]),[fn tag(ii)],'rows');
        end
        if length(frameNums) > 1
            displayMessage(handles,sprintf('Processing frame %d - %d/%d ... time remaining %s',fn,ff,length(frameNums),getTimeRemaining(length(frameNums),ff)));
        end
    end

    if any(LiaR)
        present = 1;
    else
        present = 0;
    end
end