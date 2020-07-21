function figure_descriptive_statistics

allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
ind1 = 1; ind2  = 2;
indCs = {1:16;1:8;1:16;1:8}; 
ds_bp = ds(ind1,indCs{ind1}); ds_wp = ds(ind2,indCs{ind2});
config_bp = configs(ind1,indCs{ind1}); config_wp = configs(ind2,indCs{ind2});
fd_ent_bp = fd_ent(ind1,indCs{ind1}); fd_ent_wp = fd_ent(ind2,indCs{ind2});
ind1 = 3; ind2  = 4;
ds_br = ds(ind1,indCs{ind1}); ds_wr = ds(ind2,indCs{ind2});
config_br = configs(ind1,indCs{ind1}); config_wr = configs(ind2,indCs{ind2});
fd_ent_br = fd_ent(ind1,indCs{ind1}); fd_ent_wr = fd_ent(ind2,indCs{ind2});
%%
runthis = 0;
if runthis
    for ii = 1:16
        an_b = ii; 
        view_descriptive_statistics_CT(config_bp{an_b},ds_bp{an_b},{pdfFolder,'Descriptive Statistics_b'});
    end
    return;
    an_w = an_b;
    view_descriptive_statistics_CT(config_wr{an_w},ds_wr{an_w},{pdfFolder,'Descriptive Statistics_w'});
return;
end

%%
runthis = 0;
if runthis
an_b = 6; an_w = an_b;
view_descriptive_statistics_V(config_b{an_b},ds_b{an_b},{pdfFolder,'Descriptive Statistics_b'});
view_descriptive_statistics_V(config_w{an_w},ds_w{an_w},{pdfFolder,'Descriptive Statistics_w'});
return;
end
%%
runthis = 0;
if runthis
ds_types = {'mean','median','mode'};%,'standard_deviation','skewness','kurtosis'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types,{'Img'});
n = 0;

maxY = 9; ySpacing = 0.5; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[12 8 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});changePosition(ylh,[0.1 2.5 0])
changePosition(ha,[0.08 -0.02 -0.01 -0.01]);
ylim([5.5 maxY]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[2.75 0.5 maxY 0.5]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',5);
save_pdf(hf,pdfFolder,'DS Ent CT',600);

maxY = 1.8; ySpacing = 0.1; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[12 5 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Hausdorff FD'});changePosition(ylh,[-0.4 0.75 0]);
changePosition(ha,[0.1 -0.02 -0.015 -0.01]);
ylim([1.5 maxY]);
save_pdf(hf,pdfFolder,'DS FD CT',600);

maxY = 0.03; ySpacing = 0.04; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[12 2 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Shaprness'});changePosition(ylh,[0.1 0.005 0])
changePosition(ha,[0.1 -0.02 -0.02 -0.01]);
ylim([0.01 maxY]);
save_pdf(hf,pdfFolder,'DS SN CT',600);
return;
end


%%
runthis = 1;
if runthis
ds_types = {'mean','median','mode'};%,'standard_deviation','skewness','kurtosis'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types,{'Motion'});
n = 0;

maxY = 9; ySpacing = 0.5; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[12 8 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});changePosition(ylh,[0.1 1.75 0])
changePosition(ha,[0.08 -0.02 -0.01 -0.01]);
ylim([4 maxY]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[0.75 0.5 maxY 0.75]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',5);
save_pdf(hf,pdfFolder,'DSm Ent CT',600);

maxY = 1.8; ySpacing = 0.1; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[12 5 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Hausdorff FD'});changePosition(ylh,[-0.4 0.75 0]);
changePosition(ha,[0.1 -0.02 -0.015 -0.01]);
ylim([1.5 maxY]);
save_pdf(hf,pdfFolder,'DSm FD CT',600);

maxY = 0.03; ySpacing = 0.04; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[12 2 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Shaprness'});changePosition(ylh,[0.1 0.0 0])
changePosition(ha,[0.1 -0.02 -0.02 -0.01]);
ylim([0.001 maxY]);
save_pdf(hf,pdfFolder,'DSm SN CT',600);
return;
end

%%
runthis = 0;
if runthis
ds_types_vars = {'standard_deviation','skewness','kurtosis'};
ds_types = {'Std. Dev.','Skewness','Kurtosis'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types_vars,{'Img'});
n = 0;

maxY = 9; ySpacing = 0.5; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[12 8 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});changePosition(ylh,[0.1 1.75 0])
changePosition(ha,[0.08 -0.02 -0.01 -0.01]);
ylim([4.5 maxY]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[2.75 0.5 maxY 0.75]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',5);
save_pdf(hf,pdfFolder,'DS Ent V',600);

maxY = 1.8; ySpacing = 0.05; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[12 5 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Hausdorff FD'});changePosition(ylh,[-0.4 0.65 0]);
changePosition(ha,[0.1 -0.02 -0.015 -0.01]);
ylim([1.4 maxY]);
save_pdf(hf,pdfFolder,'DS FD V',600);

maxY = 0.045; ySpacing = 0.005; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[12 2 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Shaprness'});changePosition(ylh,[0.1 0.001 0])
changePosition(ha,[0.1 -0.02 -0.02 -0.01]);
ylim([0.01 maxY]);
save_pdf(hf,pdfFolder,'DS SN V',600);
return;
end

%%
runthis = 0;
if runthis
ds_types_vars = {'standard_deviation','skewness','kurtosis'};
ds_types = {'Std. Dev.','Skewness','Kurtosis'};
fes = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types_vars,{'Descriptive','Motion'});
n = 0;

maxY = 9; ySpacing = 0.5; params = {'ENT',maxY ySpacing};
[hf,ha] = param_figure(1000,[12 8 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Spatial Entropy'});changePosition(ylh,[0.1 1.75 0])
changePosition(ha,[0.08 -0.02 -0.01 -0.01]);
ylim([4.5 maxY]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[2.75 0.5 maxY 0.75]};
putLegend(ha,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',5);
save_pdf(hf,pdfFolder,'DSm Ent V',600);

maxY = 1.8; ySpacing = 0.1; params = {'FD',maxY ySpacing};
[hf,ha] = param_figure(1001,[12 5 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Hausdorff FD'});changePosition(ylh,[-0.4 0.75 0]);
changePosition(ha,[0.1 -0.02 -0.015 -0.01]);
ylim([1.5 maxY]);
save_pdf(hf,pdfFolder,'DSm FD V',600);

maxY = 0.045; ySpacing = 0.005; params = {'SN',maxY ySpacing};
[hf,ha] = param_figure(1002,[12 2 1.5 1],ds_types,fes,params);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
xlh = xlabel(''); ylh = ylabel({'Shaprness'});changePosition(ylh,[0.1 0.001 0])
changePosition(ha,[0.1 -0.02 -0.02 -0.01]);
ylim([0.01 maxY]);
save_pdf(hf,pdfFolder,'DSm SN V',600);

% maxY = 0.7; ySpacing = 0.005; params = {'SP',maxY ySpacing};
% [hf,ha] = param_figure(1003,[14 2 1.5 1],ds_types,fes,params);
% set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
% xlh = xlabel(''); ylh = ylabel({'Spread'});changePosition(ylh,[0.1 0.001 0])
% changePosition(ha,[0.1 -0.02 -0.02 -0.01]);
% ylim([0 maxY]);
% save_pdf(hf,pdfFolder,'DSm SP V',600);
return;
end

