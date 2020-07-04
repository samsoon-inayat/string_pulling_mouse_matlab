function figure_descriptive_statistics_masks

variablesToGetFromBase = {'fd_ent_b','fd_ent_w','pdfFolder','dsm_b','dsm_w','config_b','config_w'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',variablesToGetFromBase{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
n = 0;
%%
runthis = 0;
if runthis
an_b = 1; an_w = 1;
titlesvars{1} = {'Mean','Median','Mode'};%,'Standard Deviation','Skewness','Kurtosis'};
titlesvars{2} = {'mean','median','mode'};%,'standard_deviation','skewness','kurtosis'};
view_descriptive_statistics_masks(config_b{an_b},dsm_b{an_b},{pdfFolder,'ds_masks_b'});
view_descriptive_statistics_masks(config_w{an_w},dsm_w{an_w},{pdfFolder,'ds_masks_w'});
return;
end



%%
runthis = 1;
if runthis == 1
ds_types_vars  = {'mean','standard_deviation','skewness','kurtosis'};
ds_types = {'Mean','Std. Dev','Skewness','Kurtosis'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types_vars,{'Descriptive','Masks','Body'});
n = 0;

maxY = 9; ySpacing = 0.5; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[12 8 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});changePosition(ylh,[0.1 -0.5 0])
changePosition(ha,[0.08 -0.02 -0.01 -0.01]);
ylim([0 maxY]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[2.75 0.5 maxY 1.5]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',5);
save_pdf(hf,pdfFolder,'DS Ent CT',600);

maxY = 1.9; ySpacing = 0.1; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[12 5 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Hausdorff FD'});changePosition(ylh,[-0.4 0.75 0]);
changePosition(ha,[0.1 -0.02 -0.015 -0.01]);
ylim([1.5 maxY]);
save_pdf(hf,pdfFolder,'DS FD CT',600);

maxY = 0.04; ySpacing = 0.001; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[12 2 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Shaprness'});changePosition(ylh,[0.1 0.005 0])
changePosition(ha,[0.1 -0.02 -0.02 -0.01]);
ylim([0.01 maxY]);
save_pdf(hf,pdfFolder,'DS SN CT',600);
return;
end


ds_types = {'mean','median','mode','standard_deviation','skewness','kurtosis'};
% ds_types = {'mean','median','mode'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types,{'Descriptive','Masks','Body'});
n = 0;

maxY = 13; ySpacing = 1; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[10 8 2 1.5],ds_types,fes,params);
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});
changePosition(ha,[0.01 -0.02 0.08 -0.01]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[0.25 0.5 13 1.5]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',7},'lineWidth',5);
save_pdf(hf,pdfFolder,'DS_Masks Ent',600);

maxY = 2; ySpacing = 0.1; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[10 5 2 1.5],ds_types,fes,params);
xlh = xlabel(''); ylh = ylabel({'Haursdoff Fractal','Dimension'});
changePosition(ha,[0.01 -0.02 0.08 -0.01]);
save_pdf(hf,pdfFolder,'DS_Masks FD',600);

maxY = 0.2; ySpacing = 0.04; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[10 2 2 1.5],ds_types,fes,params);
xlh = xlabel(''); ylh = ylabel({'Shaprness'});
changePosition(ha,[0.01 -0.02 0.08 -0.01]);
save_pdf(hf,pdfFolder,'DS_Masks SN',600);

