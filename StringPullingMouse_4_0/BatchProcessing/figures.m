function figures
allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs'};
variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
n = 0; ind1 = 2; ind2  = ind1 + 2;
indCs = {1:16;1:8}; 
ds_b = ds(ind1,indCs{ind1}); ds_w = ds(ind2,indCs{ind1});
motion_b = motion(ind1,indCs{ind1}); motion_w = motion(ind2,indCs{ind1});
fd_ent_b = fd_ent(ind1,indCs{ind1}); fd_ent_w = fd_ent(ind2,indCs{ind1});
pcs_b = pcs(ind1,indCs{ind1}); pcs_w = pcs(ind2,indCs{ind1});
config_b = configs(ind1,indCs{ind1}); config_w = configs(ind2,indCs{ind1});

%%
if 1
an_b = 1; an_w = 1;
view_descriptive_statistics_CT(config_b{an_b},ds_b{an_b},{pdfFolder,'Descriptive Statistics_b'});
view_descriptive_statistics_CT(config_w{an_w},ds_w{an_w},{pdfFolder,'Descriptive Statistics_w'});
return
end
%%
an_b = 1;
viewPCs(configs{1,an_b},pcs_b{an_b},{pdfFolder,'pcs_b'});

%%
for ii = 1:length(pcs_b)
    [sfn_b,efn_b] = getFrameNums(config_b{ii}); N_b(ii) = efn_b - sfn_b + 1;
    [sfn_w,efn_w] = getFrameNums(config_w{ii}); N_w(ii) = efn_w - sfn_w + 1;
end

ev_threshold = 0:0.1:1;
for ee = 1:length(ev_threshold)
for ii = 1:length(pcs_b)
    ev_b(ii,:) = pcs_b{ii}.explained(1);    ev_w(ii,:) = pcs_w{ii}.explained(1);
    aev_b(ii,:) = pcs_b{ii}.explained(1:10);    aev_w(ii,:) = pcs_w{ii}.explained(1:10);
    count_pcs_b(ee,ii) = sum(pcs_b{ii}.explained > ev_threshold(ee))/N_b(ii);
    count_pcs_w(ee,ii) = sum(pcs_w{ii}.explained > ev_threshold(ee))/N_w(ii);
end
[hcntpcs(ee),pcntpcs(ee),ci,stats] = ttest2(count_pcs_b(ee,:),count_pcs_w(ee,:));
end

ev_threshold = 0:0.01:1;
for ee = 1:length(ev_threshold)
for ii = 1:5
    evm_b(ii,:) = pcs_b{ii}.motion.explained(1);    evm_w(ii,:) = pcs_w{ii}.motion.explained(1);
    aevm_b(ii,:) = pcs_b{ii}.motion.explained(1:10);    aevm_w(ii,:) = pcs_w{ii}.motion.explained(1:10);
    count_pcsm_b(ee,ii) = sum(pcs_b{ii}.motion.explained > ev_threshold(ee))/N_b(ii);
    count_pcsm_w(ee,ii) = sum(pcs_w{ii}.motion.explained > ev_threshold(ee))/N_w(ii);
end
[hcntpcsm(ee),pcntpcsm(ee),ci,stats] = ttest2(count_pcsm_b(ee,:),count_pcsm_w(ee,:));
end
[paev,tblaev,statsaev] = anova1([aevm_b' aevm_w'],[ones(1,5) 2*ones(1,5)],'off');
n = 0;
%%
runthis = 1;
if runthis
mean_ev_b = [mean(ev_b) mean(evm_b)]; sem_ev_b = [std(ev_b)/sqrt(5) std(evm_b)/sqrt(5)];
mean_ev_w = [mean(ev_w) mean(evm_w)]; sem_ev_w = [std(ev_w)/sqrt(5) std(evm_w)/sqrt(5)];
[hev(1),pev(1),ci,stats] = ttest2(ev_b,ev_w);[hev(2),pev(2),ci,stats] = ttest2(evm_b,evm_w);
effect_size = computeCohen_d(ev_b,ev_w)
effect_sizeM = computeCohen_d(evm_b,evm_w)
hf = figure(1000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[10 7 1.5 1],'color','w');
hold on;
xs1 = 1:3:35; xs1 = xs1(1:length([1 2])); xs2 = 2:3:35; xs2 = xs2(1:length([1 2]));
combs = [1 2];
maxY = 180;
for ii = 1:2
    means = [mean_ev_b(ii) mean_ev_w(ii)]; sems = [sem_ev_b(ii) sem_ev_w(ii)];
    plotBarsWithSigLines(means,sems,combs,[hev(ii) pev(ii)],'colors',{'k','b'},'sigColor','k',...
        'maxY',maxY,'ySpacing',20,'sigTestName','','sigLineWidth',0.25,'BaseValue',0.001,...
        'xdata',[xs1(ii) xs2(ii)],'sigFontSize',7,'sigAsteriskFontSize',12);
end
xlim([(xs1(1)-1) (xs2(end)+1)]);
hy = ylabel({'Explained Var.'});changePosition(hy,[0.5 -6 0]);
xtl = {'PC1-Position','PC1-Speed'};
set(gca,'XTick',[1.5:3:6],'XTickLabel',xtl); xtickangle(20);
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[0.05 -0.01 -0.01 -0.01]);
legs = {'Black mice (N = 5)','White mice (N = 5)',[0.5 0.5 maxY 35]};
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',7},'lineWidth',5);
save_pdf(hf,pdfFolder,'PC Explaind Variance Bar Graph',600);
return;
end


