function [NSdist, STR_CENT] = NoseStrDist(N_CENT,MSK)
% function to find the distance of rodent nose from the string
%   If nose not found return NaN

NSdist = NaN;
STR_CENT = [NaN NaN];
if isempty(N_CENT)
    return;
end
if sum(isnan(N_CENT))>0 || sum(N_CENT<0) > 0
    return;
end

M_ROW = ceil(N_CENT(2));
M_COL = ceil(N_CENT(1));
if M_ROW <6
    M_CROP = MSK(M_ROW : M_ROW+10, :);
    % find the ROI
    [STR_ind_X, STR_ind_Y] = find(M_CROP);
    SRT_IND = [STR_ind_Y , STR_ind_X];
    
%     If no string in the cropped mask
    if isempty(SRT_IND)
        clear M_CROP
        M_CROP = MSK(:,M_COL-5 : M_COL+5 );
        [STR_ind_X, STR_ind_Y] = find(M_CROP);
        SRT_IND = [STR_ind_Y , STR_ind_X ];
    end
    
    % string center
    %     STR_CENT = [ceil(mean(STR_ind_Y)) M_ROW+ceil(mean(STR_ind_X))];
    %     STR_CENT = [ceil(mean(STR_ind_Y)) M_ROW+ceil((STR_ind_X(1)))];
    % Find euclidean distance
    %     NSdist = pdist([STR_CENT; N_CENT] ,'euclidean');
    
    for tt = 1:length(STR_ind_Y)
        Y_DIST(tt) = pdist([SRT_IND(tt,:); N_CENT] ,'euclidean');
    end
    
    NSdist = min(Y_DIST);
    
    
else
    M_CROP = MSK(M_ROW-5 : M_ROW+5, :);
    % find the ROI
    [STR_ind_X, STR_ind_Y] = find(M_CROP);
    SRT_IND = [STR_ind_Y , STR_ind_X+M_ROW-5];
    %     If no string in the cropped mask

    if isempty(SRT_IND)
        clear M_CROP
        M_CROP = MSK(:,M_COL-5 : M_COL+5 );
        [STR_ind_X, STR_ind_Y] = find(M_CROP);
        SRT_IND = [ STR_ind_Y+M_COL-5 , STR_ind_X];
    end
    % string center
    %     STR_CENT = [ceil(mean(STR_ind_Y)) M_ROW-5+ceil(mean(STR_ind_X))];
    %     STR_CENT = [ceil(mean(STR_ind_Y)) M_ROW-5+ceil((STR_ind_X(1)))];
    % Find euclidean distance
    %     NSdist = pdist([STR_CENT; N_CENT] ,'euclidean');
    for tt = 1:length(STR_ind_Y)
        Y_DIST(tt) = pdist([SRT_IND(tt,:); N_CENT] ,'euclidean');
    end
    
    [NSdist, IND] = min(Y_DIST);
    STR_CENT = SRT_IND(IND,:);
    n = 0;
end


