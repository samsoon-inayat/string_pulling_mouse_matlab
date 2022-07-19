% Code to plot individual mouse reaches (full up-down cycle )
% (C) Copyright 2022, All rights reserved.
% Surjeet Singh, The Jackson Laboratory, 18th July 2022.
% make sure you have crossings function added to the path
% clear all
clc
close all
load('NEW_all_params.mat') % this is the output file from MATLAB string pulling toolbox Inayat et. al Elife 2020 Jun 26;9:e54540. 
                            % doi: 10.7554/eLife.54540.
                            
animal_no = 2; % second black animal from all_params_b as shown in given matfiles NEW_all_params.mat and scales.mat
load('scales.mat') % this is to load the scales
RightHandY = all_params_b{1, animal_no}.right_hand.centroid;  % load right hand centeroid
LeftHandY = all_params_b{1, animal_no}.left_hand.centroid;  % % load left hand centeroid
yR = RightHandY(:,2);  % select Y motion
yL = LeftHandY(:,2);    % select Y motion
figure; plot(yL)
hold on
plot(yR)

%%
% define the frames where the animal is doing actual pulling bacause
% hilbert transform might will work for extreme uneven pulls or no pull
bout= {15:130};%2nd animal
f_rate = 59.94; % fps
scale_dist = scale_b(animal_no); %mm
RT_R = [];
FT_R = [];
H_R = [];
RT_L = [];
FT_L = [];
H_L = [];
CD = [];
figure;

for bt = 1:length(bout)
    
    sig_len = cell2mat(bout(1,bt));
    nyR = abs(yR(sig_len)-1920); % inverted with respect to the image height
    nyL = abs(yL(sig_len)-1920);
    zs_nyR = angle(hilbert(zscore(nyR))); % find hilbert transform of zscored Y movement
    zs_nyL = angle(hilbert(zscore(nyL)));
    % figure; plot(zs_nyR); hold on ; plot(zs_nyL)
    
    % find peak to detect changes in one complete cycle
    [aL, locL] = findpeaks(zs_nyL, 'MinPeakHeight',2); %, 'MinPeakDistance',20
    indL = crossing(zs_nyL);
    [aR, locR] = findpeaks(zs_nyR, 'MinPeakHeight',2);%, 'MinPeakDistance',10
    indR = crossing(zs_nyR);
    
    % use the following lines if you want to investigate combined pull
    % time
    %     if locR(1)>locL(1)
    %         cR = ismember(indR, locR(2:end-1));%%2+length(locL(2:end-1))
    %         indexesR = find(cR);
    %         indR_N = indR((indexesR(1)-1):indexesR(end));
    %
    %         cL = ismember(indL, locL(2:length(locR(1:end-1)-1)));
    %         indexesL = find(cL);
    %         indL_N = indL((indexesL(1)):indexesL(end)+1);
    %
    %         comb_down = abs(indR_N-indL_N);
    %         %         avg_comb = median(comb_down)
    %         avg_comb = floor(mean(comb_down));
    %     else
    %         cL = ismember(indL, locL(2:end-1));%%2+length(locL(2:end-1))
    %         indexesL = find(cL);
    %         indL_N = indL((indexesL(1)-1):indexesL(end));
    %
    %         cR = ismember(indR, locR(2:length(locL(1:end-1)-1)));
    %         indexesR = find(cR);
    %         indR_N = indR((indexesR(1)):indexesR(end)+1);
    %
    %         comb_down = abs(indL_N-indR_N);
    %         avg_comb = floor(mean(comb_down));
    %     end
    %     CD = [CD comb_down]; % combined motion frames
    
    % select left hand frames for each cycle
    for tt = 1:length(locL)-1
        x = nyL(locL(tt):locL(tt+1)+1);
        
        mi = find(x==max(x));
        rise_Lmin = find(x==min(x(1:mi)));
        fall_Lmin = find(x==min(x(mi:end)));
        hold on; plot(x-x(rise_Lmin),'r') % plot left hand in red color
        L_rise_t = risetime(x,f_rate,'StateLevels',[x(rise_Lmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     figure;
        L_fall_t = falltime(x,f_rate,'StateLevels',[x(fall_Lmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     L_rise_t = sum(ones(1, length(x(rise_Lmin:mi)))).*(1/f_rate);
        %     L_fall_t = sum(ones(1, length(mi:length(x(mi:fall_Lmin))))).*(1/f_rate);
        %                 height_L = mean([(x(mi)-x(rise_Lmin)) (x(mi)-x(fall_Lmin))] ).*scale_dist;
        height_L = max(x-x(rise_Lmin))*scale_dist;
        RT_L = [RT_L L_rise_t];
        FT_L = [FT_L L_fall_t];
        H_L = [H_L height_L];
        Cycle(tt).B5 = (x-x(rise_Lmin)).*scale_dist; % Cycle has the information on individual cycles.
    end
    % select right hand frames for each cycle
    for tt = 1:length(locR)-1
        x = nyR(locR(tt):locR(tt+1)+1);
        
        mi = find(x==max(x));
        rise_Rmin = find(x==min(x(1:mi)));
        fall_Rmin = find(x==min(x(mi:end)));
        hold on; plot(x-x(rise_Rmin),'k') % plot right hand in black color
        R_rise_t = risetime(x,f_rate,'StateLevels',[x(rise_Rmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     figure;
        R_fall_t = falltime(x,f_rate,'StateLevels',[x(fall_Rmin) max(x)], 'PercentReferenceLevels', [ 1.5 99.5], 'Tolerance', 0.1);
        %     R_rise_t = sum(ones(1, length(x(rise_Rmin:mi)))).*(1/f_rate);
        %     R_fall_t = sum(ones(1, length(mi:length(x(mi:fall_Rmin))))).*(1/f_rate);
        %                 height_R = mean([(x(mi)-x(rise_Rmin)) (x(mi)-x(fall_Rmin))] ).*scale_dist;
        height_R = max(x-x(rise_Rmin))*scale_dist;
        RT_R = [RT_R R_rise_t];
        FT_R = [FT_R R_fall_t];
        H_R = [H_R height_R];
        Cycle(tt).B5 = (x-x(rise_Rmin)).*scale_dist;
    end
end
title ('individual reaches and pulls')
%% plot results for just right hand similarly you can plot for left hand as well 
asym_t = (RT_R - FT_R)./((RT_R + FT_R)); % asymmetry index
comb_pull = mean(CD).*(1/f_rate); % pull time with both hands
figure; bar([mean(RT_R) mean(FT_R)])
hold on; errorbar([mean(RT_R) mean(FT_R)], [std(RT_R) std(FT_R)], '.')
title('rise time/fall time (s)')
figure; bar(mean(asym_t))
hold on ; errorbar(mean(asym_t), std(asym_t))
title('asymmetry index (AI)')
figure; bar(mean(H_R))
hold on ; errorbar(mean(H_R), std(H_R))
title('average height (cm/mm/change scale factor')

% figure; bar(mean(CD.*(1/f_rate)))
% hold on ; errorbar(mean(CD.*(1/f_rate)), std(CD.*(1/f_rate)))
% title('combined pull time (s)')
%% RANDOM CODE
%  temp = string_masks(:,:,100);
% temp = imfill(temp,'holes');
% temp = bwareaopen(temp,100);
% ceil(nose_centroids(100,:))% temp = bwconvhull(temp,'objects');
% figure; imagesc(temp)
% clear temp
%
% A = string_masks(ceil(nose_centroids(:,1)),:,:);

% mean(H_R)


