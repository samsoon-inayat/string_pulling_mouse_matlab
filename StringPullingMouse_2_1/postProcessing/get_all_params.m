function out = get_all_params(handles,sfn,efn,adv)
if ~exist('adv','var')
    adv = 0;
end
out = [];
M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = handles.md.resultsMF.zoomWindow;
M.scale = handles.md.resultsMF.scale;
M.frameSize = handles.d.frameSize;
zw1 = M.zw;

% sfn = 1;
% efn = 477;


indexC = strfind(M.tags,'Right Ear');
tagR = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Left Ear');
tagL = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Subject Props');
tagSP = find(not(cellfun('isempty', indexC)));

indexC = strfind(M.tags,'Right Hand');
tagRH = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Left Hand');
tagLH = find(not(cellfun('isempty', indexC)));


% indL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
% indR = ismember(M.R(:,[1 2]),[fn tagR],'rows');

frameNums = sfn:efn;
global frames;
hWaitBar = waitbar(0,sprintf('Fetching parameters -'));
try
for ii = 1:length(frameNums)
    tic
    fn = frameNums(ii);
    try
        indL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
        indR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
        areasL(ii) = M.R(indL,5);
        areasR(ii) = M.R(indR,5);
        centroidL(ii,:) = M.R(indL,[3 4]);
        centroidR(ii,:) = M.R(indR,[3 4]);
        diffV = centroidL(ii,:) - centroidR(ii,:);
        angleV(ii) = rad2deg(atan2(diffV(2),diffV(1)));
    catch
        disp('No Ear Values found');
        areasL(ii) = NaN; areasR(ii) = NaN;
        angleV(ii) = NaN; centroidL(ii,:) = [NaN NaN];
        centroidR(ii,:) = [NaN NaN];
    end
    indSP = ismember(M.R(:,[1 2]),[fn tagSP],'rows');
    bodyLength(ii) = M.R(indSP,3);
    temp = M.R(indSP,5);
    if temp < 0
        temp = temp + 180;
    end
    bodyAngle(ii) = temp;
    try
        ind = ismember(M.R(:,[1 2]),[fn tagRH],'rows');
        xrs(ii) = M.R(ind,3);
        yrs(ii) = M.R(ind,4);
    catch
        disp('No Right Hand Values found');
        xrs(ii) = NaN;
        yrs(ii) = NaN;
    end
    try
        ind = ismember(M.R(:,[1 2]),[fn tagLH],'rows');
        xls(ii) = M.R(ind,3);
        yls(ii) = M.R(ind,4);
    catch
        disp('No Left Hand Values found');
        xls(ii) = NaN;
        yls(ii) = NaN;
    end
    if adv
        ind = ismember(M.P(:,[1 2]),[fn tagRH],'rows');
        boundaryPixelsRH(ii).ps = M.P(ind,3);

        ind = ismember(M.P(:,[1 2]),[fn tagLH],'rows');
        boundaryPixelsLH(ii).ps = M.P(ind,3);

        ind = ismember(M.P(:,[1 2]),[fn tagR],'rows');
        boundaryPixelsRE(ii).ps = M.P(ind,3);

        ind = ismember(M.P(:,[1 2]),[fn tagL],'rows');
        boundaryPixelsLE(ii).ps = M.P(ind,3);
    end
    
    iii = ismember(M.R(:,[1 2]),[fn 8],'rows');
    jj = ismember(M.R(:,[1 2]),[fn 7],'rows');
    bodyFit(ii) = getSubjectFit(M.R(jj,[3 4]),M.R(iii,3),M.R(iii,4),M.R(iii,5));
    
    t = toc;
    timeRemaining = ((length(frameNums)-ii)*t)/3600;
    if timeRemaining < 1
        timeRemaining = timeRemaining * 60;
        waitbar(ii/length(frameNums),hWaitBar,sprintf('Fetching parameters - %d/%d ... Time Remaining = %.2f mins',ii,length(frameNums),timeRemaining));
    else
        waitbar(ii/length(frameNums),hWaitBar,sprintf('Fetching parameters - %d/%d ... Time Remaining = %.2f hrs',ii,length(frameNums),timeRemaining));
    end
end
catch
    close(hWaitBar);
    props = {'FontSize',11,'ForegroundColor','r'};displayMessage(handles,sprintf('Error in fetching parameters from frame %d ... check frame',fn),props);
    return;
end
close(hWaitBar);
areaRatio_R2L = areasR./areasL;
out.head.head_yaw = areaRatio_R2L;
out.head.head_roll = angleV;
out.body.body_angle = bodyAngle;
out.body.body_length = bodyLength;
out.right_hand.centroid = [xrs' yrs'];
out.left_hand.centroid = [xls' yls'];
out.right_ear.centroid = centroidR;
out.left_ear.centroid = centroidL;
out.body.body_fit = bodyFit;
if adv
    out.right_hand.boundary_pixels = boundaryPixelsRH;
    out.left_hand.boundary_pixels = boundaryPixelsLH;
    out.right_ear.boundary_pixels = boundaryPixelsRE;
    out.left_ear.boundary_pixels = boundaryPixelsLE;
end

