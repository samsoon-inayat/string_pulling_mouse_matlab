function out = get_all_params(handles,sfn,efn,adv)
md = get_meta_data(handles);
if isfield(handles,'figure1')
    if ~exist('adv','var')
        adv = 0;
    end
    if adv == 10
        fileName = fullfile(md.processed_data_folder,'all_parameters.mat');
        if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
            out = load(fileName);
            return;
        else
            adv = 0;
        end
    end
else
    adv = 0;
end

if adv == 2
    fileName = fullfile(md.processed_data_folder,'all_parameters_adv.mat');
    if exist(fileName,'file') && ~get(handles.checkbox_over_write,'Value')
        out = load(fileName);
        return;
    else
        adv = 1;
    end
end


md = get_meta_data(handles);
[R,P,~] = get_R_P_RDLC(handles);
if isfield(handles,'figure1')
    d = get_data(handles);
else
    [sfn,efn] = getFrameNums(handles);
    fr = getParameter(handles,'Frame Rate');
    d.frame_times = ((sfn:efn) - sfn) / fr;
end

    
out = [];
M.R = R;
M.P = P;
M.tags = md.tags;
M.zw = getParameter(handles,'Auto Zoom Window');
% M.scale = getParameter(handles,'Scale');
if isfield(handles,'figure1')
    M.frameSize = md.frame_size;
end
zw1 = M.zw;

% sfn = 1;
% efn = 477;


indexC = strfind(M.tags,'Right Ear');
tagRE = find(not(cellfun('isempty', indexC)));
indexC = strfind(M.tags,'Left Ear');
tagLE = find(not(cellfun('isempty', indexC)));
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
frames = get_frames(handles);
hWaitBar = waitbar(0,sprintf('Fetching parameters -'));
add_window_handle(handles,hWaitBar);
manualH = [];
try
for ii = 1:length(frameNums)
    tic
    fn = frameNums(ii);
    try
        indL = ismember(M.R(:,[1 2]),[fn tagLE],'rows');
        areasL(ii) = M.R(indL,5);
        centroidLE(ii,:) = M.R(indL,[3 4]);
        mLE(ii) = M.R(indL,5);
    catch
        disp(sprintf('No Left Ear Values found for %d',fn));
        areasL(ii) = NaN; 
        centroidLE(ii,:) = [NaN NaN];
        mLE(ii) = NaN;
    end
    try
        indR = ismember(M.R(:,[1 2]),[fn tagRE],'rows');
        areasR(ii) = M.R(indR,5);
        centroidRE(ii,:) = M.R(indR,[3 4]);
        mRE(ii) = M.R(indR,5);
    catch
        disp(sprintf('No Right Ear Values found for %d',fn));
        areasR(ii) = NaN;
        centroidRE(ii,:) = [NaN NaN];
        mRE(ii) = NaN;
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
        disp(sprintf('No Fur Values found for %d',fn));
        bodyLength(ii) = NaN; bodyAngle(ii) = NaN;
        body_ellipse_x(ii) = NaN; body_ellipse_y(ii) = NaN;
    end
    try
        ind = ismember(M.R(:,[1 2]),[fn tagRH],'rows');
        xrs(ii) = M.R(ind,3);
        yrs(ii) = M.R(ind,4);
        mRH(ii) = M.R(ind,5);
    catch
        disp(sprintf('No Right Hand Values found for %d',fn));
        xrs(ii) = NaN;
        yrs(ii) = NaN;
        mRH(ii) = NaN;
    end
    try
        ind = ismember(M.R(:,[1 2]),[fn tagLH],'rows');
        xls(ii) = M.R(ind,3);
        yls(ii) = M.R(ind,4);
        mLH(ii) = M.R(ind,5);
    catch
        disp(sprintf('No Left Hand Values found for %d',fn));
        xls(ii) = NaN;
        yls(ii) = NaN;
        mLH(ii) = NaN;
    end
    
    try
        ind = ismember(M.R(:,[1 2]),[fn tagN],'rows');
        xns(ii) = M.R(ind,3);
        yns(ii) = M.R(ind,4);
        mN(ii) = M.R(ind,5);
    catch
        disp(sprintf('No Nose Values found for %d',fn));
        xns(ii) = NaN;
        yns(ii) = NaN;
        mN(ii) = NaN;
    end
    
    if adv == 1
        indR = ismember(M.R(:,[1 2]),[fn tagRH],'rows');
        if any(indR)
            ind = ismember(M.P(:,[1 2]),[fn tagRH],'rows');
            boundaryPixelsRH(ii).ps = M.P(ind,3);
        else
            boundaryPixelsRH(ii).ps = NaN;
        end
        
        indR = ismember(M.R(:,[1 2]),[fn tagLH],'rows');
        if any(indR)
            ind = ismember(M.P(:,[1 2]),[fn tagLH],'rows');
            boundaryPixelsLH(ii).ps = M.P(ind,3);
        else
            boundaryPixelsLH(ii).ps = NaN;
        end
        
        indR = ismember(M.R(:,[1 2]),[fn tagRE],'rows');
        if any(indR)
            ind = ismember(M.P(:,[1 2]),[fn tagRE],'rows');
            boundaryPixelsRE(ii).ps = M.P(ind,3);
        else
            boundaryPixelsRE(ii).ps = NaN;
        end
        
        indL = ismember(M.R(:,[1 2]),[fn tagLE],'rows');
        if any(indL)
            ind = ismember(M.P(:,[1 2]),[fn tagLE],'rows');
            boundaryPixelsLE(ii).ps = M.P(ind,3);
        else
            boundaryPixelsLE(ii).ps = NaN;
        end
    end
    
    iii = ismember(M.R(:,[1 2]),[fn 8],'rows');
    jj = ismember(M.R(:,[1 2]),[fn 7],'rows');
    bodyFit(ii) = getSubjectFit(M.R(jj,[3 4]),M.R(iii,3),M.R(iii,4),M.R(iii,5));
    try
        mB(ii) = M.R(jj,5);
    catch
        mB(ii) = NaN;
    end
   
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
    if ~isnan(m(ii,1))
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
    else
        if ~isnan(centroidLE(ii,1)) || ~isnan(centroidRE(ii,1))
            if ~isnan(centroidLE(ii,1))
                yi = centroidLE(ii,2);
                dist_nose_B(ii) = yi - yns(ii);
            end
            if ~isnan(centroidRE(ii,1))
                yi = centroidRE(ii,2);
                dist_nose_B(ii) = yi - yns(ii);
            end
        else
            dist_nose_B(ii) = NaN;
        end
            
    end
end

% areaRatio_R2L = areasR./areasL;
dist_nose_RE(isnan(dist_nose_RE)) = 0;
dist_nose_LE(isnan(dist_nose_LE)) = 0;
head_yaw = (dist_nose_RE-dist_nose_LE)./(dist_nose_RE+dist_nose_LE);
% head_yaw = log(head_yaw);
head_yaw = fillInNaNs(head_yaw);

angleV = fillInNaNs(angleV);
if ~exist('dist_nose_B','var')
    dist_nose_B = NaN(size(dist_nose_RE));
end
dist_nose_B = fillInNaNs(dist_nose_B);
dist_nose_B = dist_nose_B;% * M.scale;

fileName = fullfile(md.processed_data_folder,'nose_string_distance.mat');
if exist(fileName,'file')
    temp = load(fileName);
    nose_string_distance = temp.d;% * M.scale;
    nose_string_distance = fillInNaNs(nose_string_distance);
else
    nose_string_distance = NaN(size(head_yaw));
end

for ii = 1:length(mRE)
    if isnan(mRE(ii))
        if isnan(mLE(ii))
            mE(ii) = NaN;
        else
            mE(ii) = mLE(ii);
        end
    else
        mE(ii) = mRE(ii);
    end
end
out.fns = (sfn:efn)';
if isfield(handles,'figure1')
    out.times = (d.frame_times(sfn:efn))';
else
    out.times = d.frame_times';
end
out.body.angle = bodyAngle';
out.body.length = bodyLength';
out.body.ellipse_top = [body_ellipse_x' body_ellipse_y'];
out.body.fit = bodyFit';
out.body.manual = mB';
out.head.yaw = head_yaw;
out.head.roll = angleV';
out.head.pitch = dist_nose_B';
out.right_hand.centroid = [xrs' yrs'];
out.right_hand.manual = mRH';
out.left_hand.centroid = [xls' yls'];
out.left_hand.manual = mLH';
out.right_ear.centroid = centroidRE;
out.right_ear.manual = mE';
out.left_ear.centroid = centroidLE;
out.left_ear.manual = mE';
out.nose.centroid = [xns' yns'];
out.nose.string_distance = nose_string_distance';
out.nose.manual = mN';
if adv == 1
    out.right_hand.boundary_pixels = boundaryPixelsRH;
    out.left_hand.boundary_pixels = boundaryPixelsLH;
    out.right_ear.boundary_pixels = boundaryPixelsRE;
    out.left_ear.boundary_pixels = boundaryPixelsLE;
end
if adv == 1
    fileName = fullfile(md.processed_data_folder,'all_parameters_adv.mat');
else
    fileName = fullfile(md.processed_data_folder,'all_parameters.mat');
end
save(fileName,'-struct','out');

function signal = fillInNaNs(signal)
if sum(isnan(signal)) == length(signal)
    return;
end
indsS = [];
indsE = [];
nanStarted = 0;
for ii = 1:length(signal)
    thisVal = signal(ii);
    if isnan(thisVal) && nanStarted == 0
        indsS = [indsS ii];
        nanStarted = 1;
        continue;
    end
    if nanStarted == 1 && ~isnan(thisVal)
        indsE = [indsE (ii-1)];
        nanStarted = 0;
    end
end
if nanStarted == 1
    indsE = [indsE ii];
end
for ii = 1:length(indsS)
    st = indsS(ii); se = indsE(ii);
    if  st == 1
        val = signal(se+1);
    else
        if se < length(signal)
            val = mean([signal(st-1) signal(se+1)]);
        else
            val = signal(st-1);
        end
    end
    signal(st:se) = val;
end
