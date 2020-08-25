function [hf,ha] = param_figure(figNum,figPos,ds_types,fes,params)

param = params{1};
maxY = params{2};
ySpacing = params{3};
hf = figure(figNum);clf;set(gcf,'Units','Inches');set(gcf,'Position',figPos,'color','w');
hold on;
xs1 = 1:3:25; xs1 = xs1(1:length(ds_types)); xs2 = 2:3:25; xs2 = xs2(1:length(ds_types));
combs = [1 2];
% maxY = 10;
for ii = 1:length(ds_types)
    if strcmp(param,'ENT')
        means = [fes.mean_ent_b(ii) fes.mean_ent_w(ii)]; sems = [fes.sem_ent_b(ii) fes.sem_ent_w(ii)]; hp = [fes.hent(ii) fes.pent(ii)];
    elseif strcmp(param,'FD')
        means = [fes.mean_fd_b(ii) fes.mean_fd_w(ii)]; sems = [fes.sem_fd_b(ii) fes.sem_fd_w(ii)]; hp = [fes.hfd(ii) fes.pfd(ii)];
    elseif strcmp(param,'SN')
        means = [fes.mean_sn_b(ii) fes.mean_sn_w(ii)]; sems = [fes.sem_sn_b(ii) fes.sem_sn_w(ii)]; hp = [fes.hsn(ii) fes.psn(ii)];
    elseif strcmp(param,'SP')
        means = [fes.mean_sp_b(ii) fes.mean_sp_w(ii)]; sems = [fes.sem_sp_b(ii) fes.sem_sp_w(ii)]; hp = [fes.hsp(ii) fes.psp(ii)];
    end
    plotBarsWithSigLines(means,sems,combs,hp,'colors',{'b','c'},'sigColor','k',...
        'maxY',maxY,'ySpacing',ySpacing,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',[xs1(ii) xs2(ii)],'sigFontSize',8,'sigAsteriskFontSize',14,'barwidth',0.75);
end
xlim([(xs1(1)-1) (xs2(end)+1)]);
% ylim([min(means) max(means)]);
% xlh = xlabel(''); ylh = ylabel({'Entropy'});%changePosition(hy,[0.00 -0.82 0]);
xtl = ds_types;
set(gca,'XTick',[1.5:3:17],'XTickLabel',xtl); xtickangle(20);
ha = gca;