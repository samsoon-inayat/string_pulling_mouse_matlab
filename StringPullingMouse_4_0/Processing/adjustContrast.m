function [im] = adjustContrast(RGB)
RGB = imsharpen(RGB);
shadow_lab = rgb2lab(RGB);
max_luminosity = 100;
L = shadow_lab(:,:,1)/max_luminosity;

shadow_imadjust = shadow_lab;
shadow_imadjust(:,:,1) = imadjust(L)*max_luminosity;
im = lab2rgb(shadow_imadjust);

% shadow_histeq = shadow_lab;
% shadow_histeq(:,:,1) = histeq(L)*max_luminosity;
% im2 = lab2rgb(shadow_histeq);
% 
% shadow_adapthisteq = shadow_lab;
% shadow_adapthisteq(:,:,1) = adapthisteq(L)*max_luminosity;
% im3= lab2rgb(shadow_adapthisteq);
