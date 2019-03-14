function out = get_all_params(handles,sfn,efn,adv)
if ~exist('adv','var')
    adv = 0;
end
out = [];
M.R = handles.md.resultsMF.R;
M.P = handles.md.resultsMF.P;
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
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

indexC = strfind(M.tags,'Nose');
tagN = find(not(cellfun('isempty', indexC)));

% indL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
% indR = ismember(M.R(:,[1 2]),[fn tagR],'rows');

frameNums = sfn:efn;
global frames;
hWaitBar = waitbar(0,sprintf('Fetching parameters -'));
manualH = [];
try
for ii = 1:length(frameNums)
    tic
    fn = frameNums(ii);
    try
        indL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
        areasL(ii) = M.R(indL,5);
        centroidL(ii,:) = M.R(indL,[3 4]);
    catch
        disp('No Left Ear Values found');
        areasL(ii) = NaN; 
        centroidL(ii,:) = [NaN NaN];
    end
    try
        indR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
        areasR(ii) = M.R(indR,5);
        centroidR(ii,:) = M.R(indR,[3 4]);
    catch
        disp('No Right Ear Values found');
        areasR(ii) = NaN;
        centroidR(ii,:) = [NaN NaN];
    end
    if ~isnan(centroidL(ii,:)) & ~isnan(centroidR(ii,:))
        diffV = centroidL(ii,:) - centroidR(ii,:);
        angleV(ii) = -rad2deg(atan2(diffV(2),diffV(1)));
    else
        angleV(ii) = NaN;
    end
    try
        indSP = ismember(M.R(:,[1 2]),[fn tagSP],'rows');
        bodyLength(ii) = M.R(indSP,3);
        temp = M.R(indSP,5);
        if temp < 0
            temp = temp + 180;
        end
        bodyAngle(ii) = temp;
    catch
        disp('No Fur Values found');
        bodyLength(ii) = NaN; bodyAngle(ii) = NaN;
    end
    try
        ind = ismember(M.R(:,[1 2]),[fn tagRH],'rows');
        xrs(ii) = M.R(ind,3);
        yrs(ii) = M.R(ind,4);
        manualH(ii) = M.R(ind,5);
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
    
    try
        ind = ismember(M.R(:,[1 2]),[fn tagN],'rows');
        xns(ii) = M.R(ind,3);
        yns(ii) = M.R(ind,4);
    catch
        disp('No Nose Values found');
        xns(ii) = NaN;
        yns(ii) = NaN;
    end
    
    if adv
        ind = ismember(M.P(:,[1 2]),[fn tagRH],'rows');
        boundaryPixelsRH(ii).ps = M.P(ind,3);

        ind = ismember(M.P(:,[1 2]),[fn tagLH],'rows');
        boundaryPixelsLH(ii).ps = M.P(ind,3);
        
        indR = ismember(M.R(:,[1 2]),[fn tagR],'rows');
        if any(indR)
            ind = ismember(M.P(:,[1 2]),[fn tagR],'rows');
            boundaryPixelsRE(ii).ps = M.P(ind,3);
        end
        
        indL = ismember(M.R(:,[1 2]),[fn tagL],'rows');
        if any(indL)
            ind = ismember(M.P(:,[1 2]),[fn tagL],'rows');
            boundaryPixelsLE(ii).ps = M.P(ind,3);
        end
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
indsE = find(diff(isnan(areaRatio_R2L)) == -1);
indsS = find(diff(isnan(areaRatio_R2L)) == 1)+1;
for ii = 1:length(indsS)
    st = indsS(ii);
    se = indsE(ii);
    val = areaRatio_R2L(st-1);
    areaRatio_R2L(st:se) = val;
end
areaRatio_R2L = log(areaRatio_R2L);

indsE = find(diff(isnan(angleV)) == -1);
indsS = find(diff(isnan(angleV)) == 1)+1;
for ii = 1:length(indsS)
    st = indsS(ii);
    se = indsE(ii);
    val = angleV(st-1);
    angleV(st:se) = val;
end

out.head.head_yaw = areaRatio_R2L;
out.head.head_roll = angleV;
out.body.body_angle = bodyAngle;
out.body.body_length = bodyLength;
out.right_hand.centroid = [xrs' yrs'];
out.right_hand.manual = manualH;
out.left_hand.centroid = [xls' yls'];
out.right_ear.centroid = centroidR;
out.left_ear.centroid = centroidL;
out.body.body_fit = bodyFit;
out.nose.centroid = [xns' yns'];
if adv
    out.right_hand.boundary_pixels = boundaryPixelsRH;
    out.left_hand.boundary_pixels = boundaryPixelsLH;
    out.right_ear.boundary_pixels = boundaryPixelsRE;
    out.left_ear.boundary_pixels = boundaryPixelsLE;
end

