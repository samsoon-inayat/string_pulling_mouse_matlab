function out = get_all_params_DLC(handles,sfn,efn,adv)
if ~exist('adv','var')
    adv = 0;
end
if adv == 10
    fileName = fullfile(handles.md.processed_data_folder,'all_parameters_DLC.mat');
    if exist(fileName,'file')
        out = load(fileName);
        return;
    end
end
handles.d = get_data(handles);
out = [];
[~,~,M.R] = get_R_P_RDLC(handles);
M.tags = handles.md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
M.scale = getParameter(handles,'Scale');
M.frameSize = handles.d.frame_size;
zw1 = M.zw;

% sfn = 1;
% efn = 477;


indexC = strfind(M.tags,'Right Ear');
tagRE = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Left Ear');
tagLE = find(not(cellfun('isempty', indexC)));

indexC = strfind(M.tags,'Right Hand');
tagRH = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Left Hand');
tagLH = find(not(cellfun('isempty', indexC)));

indexC = strfind(M.tags,'Nose');
tagN = find(not(cellfun('isempty', indexC)));

frameNums = sfn:efn;
frames = get_frames(handles);
hWaitBar = waitbar(0,sprintf('Fetching parameters -'));
manualH = [];
try
for ii = 1:length(frameNums)
    tic
    fn = frameNums(ii);
    try
        indL = ismember(M.R(:,[1 2]),[fn tagLE],'rows');
        probLE(ii) = M.R(indL,5);
        centroidLE(ii,:) = M.R(indL,[3 4]);
    catch
        disp('No Left Ear Values found');
        probLE(ii) = NaN; 
        centroidLE(ii,:) = [NaN NaN];
    end
    try
        indR = ismember(M.R(:,[1 2]),[fn tagRE],'rows');
        probRE(ii) = M.R(indR,5);
        centroidRE(ii,:) = M.R(indR,[3 4]);
    catch
        disp('No Right Ear Values found');
        probRE(ii) = NaN;
        centroidRE(ii,:) = [NaN NaN];
    end
    if ~isnan(centroidLE(ii,:)) & ~isnan(centroidRE(ii,:))
        diffV = centroidLE(ii,:) - centroidRE(ii,:);
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
        
        indS = ismember(M.R(:,[1 2]),[fn (tagSP-1)],'rows');
        C = getSubjectFit(M.R(indS,[3 4]),M.R(indSP,3),M.R(indSP,4),M.R(indSP,5));
        [body_ellipse_y(ii),ti] = min(C.Major_axis_ys);
        body_ellipse_x(ii) = C.Major_axis_xs(ti);
    catch
        disp('No Fur Values found');
        bodyLength(ii) = NaN; bodyAngle(ii) = NaN;
        body_ellipse_x(ii) = NaN; body_ellipse_y(ii) = NaN;
    end
    try
        ind = ismember(M.R(:,[1 2]),[fn tagRH],'rows');
        xrs(ii) = M.R(ind,3);
        yrs(ii) = M.R(ind,4);
        probRH(ii) = M.R(ind,5);
    catch
        disp('No Right Hand Values found');
        xrs(ii) = NaN;
        yrs(ii) = NaN;
        probRH(ii) = NaN;
    end
    try
        ind = ismember(M.R(:,[1 2]),[fn tagLH],'rows');
        xls(ii) = M.R(ind,3);
        yls(ii) = M.R(ind,4);
        probLH(ii) = M.R(ind,5);
    catch
        disp('No Left Hand Values found');
        xls(ii) = NaN;
        yls(ii) = NaN;
        probLH(ii) = NaN;
    end
    
    try
        ind = ismember(M.R(:,[1 2]),[fn tagN],'rows');
        xns(ii) = M.R(ind,3);
        yns(ii) = M.R(ind,4);
        probN(ii) = M.R(ind,5);
    catch
        disp('No Nose Values found');
        xns(ii) = NaN;
        yns(ii) = NaN;
        probN(ii) = NaN;
    end
  
%     iii = ismember(M.R(:,[1 2]),[fn 8],'rows');
%     jj = ismember(M.R(:,[1 2]),[fn 7],'rows');
%     bodyFit(ii) = getSubjectFit(M.R(jj,[3 4]),M.R(iii,3),M.R(iii,4),M.R(iii,5));
   
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
dist_nose_LE = sqrt(sum((centroidLE - [xns' yns']).^2,2));
dist_nose_RE = sqrt(sum((centroidRE - [xns' yns']).^2,2));

m = ((centroidLE(:,2) - centroidRE(:,2))./(centroidLE(:,1) - centroidRE(:,1)));
b1 = centroidRE(:,2) - m.*centroidRE(:,1);
b2 = m.*yns' + xns';
for ii = 1:size(m,1)
    A = [1 -m(ii);
        m(ii) 1];
    b = [b1(ii);b2(ii)];
    yxi = linsolve(A,b);
    yi = yxi(1);
    xi = yxi(2);
    if yi < yns(ii)
        dist_nose_B(ii) = -(sqrt(sum(([xi yi] - [xns(ii) yns(ii)]).^2,2)));
    else
        dist_nose_B(ii) = (sqrt(sum(([xi yi] - [xns(ii) yns(ii)]).^2,2)));
    end
end

% areaRatio_R2L = probRE./probLE;
head_yaw = dist_nose_RE./dist_nose_LE;
head_yaw = fillInNaNs(head_yaw);

indsE = find(diff(isnan(head_yaw)) == -1);
indsS = find(diff(isnan(head_yaw)) == 1)+1;
for ii = 1:length(indsS)
    st = indsS(ii);
    se = indsE(ii);
    val = head_yaw(st-1);
    head_yaw(st:se) = val;
end
head_yaw = log(head_yaw);

indsE = find(diff(isnan(angleV)) == -1);
indsS = find(diff(isnan(angleV)) == 1)+1;
for ii = 1:length(indsS)
    st = indsS(ii);
    se = indsE(ii);
    val = angleV(st-1);
    angleV(st:se) = val;
end

indsE = find(diff(isnan(dist_nose_B)) == -1);
indsS = find(diff(isnan(dist_nose_B)) == 1)+1;
for ii = 1:length(indsS)
    st = indsS(ii);
    se = indsE(ii);
    val = dist_nose_B(st-1);
    dist_nose_B(st:se) = val;
end

dist_nose_B = dist_nose_B * M.scale;

fileName = fullfile(handles.md.processed_data_folder,'nose_string_distance_DLC.mat');
if exist(fileName,'file')
    temp = load(fileName);
    nose_string_distance = temp.d * M.scale;
else
    nose_string_distance = NaN(size(head_yaw));
end

out.head.head_yaw = head_yaw;
out.head.head_roll = angleV;
out.head.head_pitch = dist_nose_B;
out.body.body_angle = bodyAngle;
out.body.body_length = bodyLength;
out.body.ellipse_top = [body_ellipse_x' body_ellipse_y'];
out.right_hand.centroid = [xrs' yrs'];
out.right_hand.prob = probRH;
out.left_hand.centroid = [xls' yls'];
out.left_hand.prob = probLH;
out.right_ear.centroid = centroidRE;
out.left_ear.centroid = centroidLE;
out.right_ear.prob = probRE;
out.left_ear.prob = probLE;
% out.body.body_fit = bodyFit;
out.nose.centroid = [xns' yns'];
out.nose.nose_string_distance = nose_string_distance;
out.times = handles.d.frame_times;


fileName = fullfile(handles.md.processed_data_folder,'all_parameters_DLC.mat');
save(fileName,'-struct','out');

function signal = fillInNaNs(signal)

indsE = find(diff(isnan(signal)) == -1);
indsS = find(diff(isnan(signal)) == 1)+1;
for ii = 1:length(indsS)
    st = indsS(ii);
    se = indsE(ii);
    val = signal(st-1);
    signal(st:se) = val;
end
