function hsvMean = selectPixelsAndGetHSV(RGB, Area,handles,type)

%
% function hsvMean = selectPixelsAndGetHSV(RGB, Area)
%
% Use this function in order to select multiple points from an image (use
% right click to stop process). The selected points are used to calculate
% the average HSV values.

% ARGUMENTS:
% RGB: the RGB image
% Area: the area size used to calulate the HSV values of each point
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Theodoros Giannakopoulos - January 2008
% www.di.uoa.gr/~tyiannak
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zw = getParameter(handles,'Zoom Window');
warning off;
imshow(RGB); hold on;
% if get(handles.checkbox_rotateLeft,'Value')
%     view(gca,-90,90);
% else
%     view(gca,0,90);
% end

if ~exist('zw','var')
    zw = [];
end
if ~isempty(zw)
    xlim([zw(1) zw(3)]);
    ylim([zw(2) zw(4)]);
end
tdx = zw(1)+20;
tdy = zw(2)+20;
text(tdx,tdy,sprintf('Left click to select areas in the %s region',type));
text(tdx,tdy+20,'Right click to exit');
hold on;

HSV = rgb2hsv(RGB);
HSV = rgb2hsv(HSV);
RGB1 = double(RGB);
% HSV2 = HSV;
numOfSelectedPixels = 0;
right_not_pressed = 1;
BUTTON = 1;
while (BUTTON~=3)
    numOfSelectedPixels = numOfSelectedPixels + 1;
    [X,Y,BUTTON] = ginput(1);    
    
    hsvTemp2 = HSV(Y-(Area-1)/2:Y+(Area-1)/2, X-(Area-1)/2:X+(Area-1)/2, :);    
%     rgbTemp2 = RGB1(Y-(Area-1)/2:Y+(Area-1)/2, X-(Area-1)/2:X+(Area-1)/2, :);    
    
    hsvTemp = zeros(3,1);
    [K,L,M] = size(hsvTemp2);
    for (i=1:K)
        for (j=1:L)
            hsvTemp(1) = hsvTemp(1) + hsvTemp2(i,j,1);
            hsvTemp(2) = hsvTemp(2) + hsvTemp2(i,j,2);
            hsvTemp(3) = hsvTemp(3) + hsvTemp2(i,j,3);
        end
    end
    
    hsvTemp = hsvTemp / (K*L);
    
    hsv(numOfSelectedPixels,:) = hsvTemp;
    
    
    hsvTemp2 = RGB1(Y-(Area-1)/2:Y+(Area-1)/2, X-(Area-1)/2:X+(Area-1)/2, :);    
%     rgbTemp2 = RGB1(Y-(Area-1)/2:Y+(Area-1)/2, X-(Area-1)/2:X+(Area-1)/2, :);    
    
    hsvTemp = zeros(3,1);
    [K,L,M] = size(hsvTemp2);
    for (i=1:K)
        for (j=1:L)
            hsvTemp(1) = hsvTemp(1) + hsvTemp2(i,j,1);
            hsvTemp(2) = hsvTemp(2) + hsvTemp2(i,j,2);
            hsvTemp(3) = hsvTemp(3) + hsvTemp2(i,j,3);
        end
    end
    
    hsvTemp = hsvTemp / (K*L);
    
    rgb(numOfSelectedPixels,:) = hsvTemp;
    
%     hsvMean = median(hsv,1);
    
    line([X-(Area-1)/2 X+(Area-1)/2] , [Y-(Area-1)/2 Y-(Area-1)/2]);
    line([X+(Area-1)/2 X+(Area-1)/2] , [Y-(Area-1)/2 Y+(Area-1)/2]);
    line([X+(Area-1)/2 X-(Area-1)/2] , [Y+(Area-1)/2 Y+(Area-1)/2]);
    line([X-(Area-1)/2 X-(Area-1)/2] , [Y+(Area-1)/2 Y-(Area-1)/2]);
    
    
    %rgbTemp = hsv2rgb(hsvTemp);
    %fprintf('Cur RGV Values:  %.3f %.3f %.3f\n', rgbTemp(1), rgbTemp(2), rgbTemp(3));
    %fprintf('Cur HSV Values:  %.3f %.3f %.3f\n', hsvTemp(1), hsvTemp(2), hsvTemp(3));
    %fprintf('Mean HSV Values: %.3f %.3f %.3f\n', hsvMean(1), hsvMean(2), hsvMean(3));
end

% [N, t] = size(hsv);

% for (i=1:N) hsvM1(i) = median(hsv(1:i,1)); end    
% for (i=1:N) hsvM2(i) = median(hsv(1:i,2)); end    
% for (i=1:N) hsvM3(i) = median(hsv(1:i,3)); end    

hsvMean(1,:) = mean(hsv);
hsvMean(2,:) = std(hsv)/sqrt(size(hsv,1));
hsvMean(3,:) = mean(rgb);
hsvMean(4,:) = std(rgb)/sqrt(size(rgb,1));

% figure;
% subplot(3,1,1); plot(hsvM1); title(sprintf('H-->%.4f',hsvM1(end)));
% subplot(3,1,2); plot(hsvM2); title(sprintf('S-->%.4f',hsvM2(end)));
% subplot(3,1,3); plot(hsvM3); title(sprintf('V-->%.4f',hsvM3(end)));
% 
% figure;
% RGB2 = hsv2rgb(HSV2);
% imshow(RGB2);