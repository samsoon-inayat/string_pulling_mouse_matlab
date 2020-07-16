function figure_pcs

allVarNames = {'motion','ds','ent','pcs','ics','fd_ent','pdfFolder','configs','N'};
variablesToGetFromBase = {'motion_b','ds_b','ent_b','pcs_b','ics_b','fd_ent_b','pdfFolder','configs','N_frames'};
for ii = 1:length(variablesToGetFromBase)
    cmdTxt = sprintf('%s = evalin(''base'',''%s'');',allVarNames{ii},variablesToGetFromBase{ii});
    eval(cmdTxt);
end
ind1 = 1; ind2  = 2;
indCs = {1:16;1:8;1:16;1:8}; 
pcs_bp = pcs(ind1,indCs{ind1}); pcs_wp = pcs(ind2,indCs{ind2});
N_b = N(ind1,indCs{ind1}); N_w = N(ind2,indCs{ind2});
ind1 = 3; ind2  = 4;
pcs_br = pcs(ind1,indCs{ind1}); pcs_wr = pcs(ind2,indCs{ind2});

%%
% runthis = 0;
% if runthis
% an_b = 2; an_w = an_b;
% % viewPCs(config_b{an_b},pcs_b{an_b},{pdfFolder,'pcs_b'},[101 102]);
% viewPCs(config_w{an_w},pcs_w{an_w},{pdfFolder,'pcs_w'},[103 104]);
% return;
% end

ev_threshold = 0:0.1:1;
for ee = 1:length(ev_threshold)
    for ii = 1:16
        evm_bp(ii,:) = pcs_bp{ii}.motion.explained(1);  evm_br(ii,:) = pcs_br{ii}.motion.explained(1); 
        aevm_bp(ii,:) = pcs_bp{ii}.motion.explained(1:10); aevm_br(ii,:) = pcs_br{ii}.motion.explained(1:10);
        count_pcsm_bp(ee,ii) = sum(pcs_bp{ii}.motion.explained > ev_threshold(ee))/N_b(ii);
        count_pcsm_br(ee,ii) = sum(pcs_br{ii}.motion.explained > ev_threshold(ee))/N_b(ii);
    end
    for ii = 1:8
        evm_wp(ii,:) = pcs_wp{ii}.motion.explained(1);  evm_wr(ii,:) = pcs_wr{ii}.motion.explained(1); 
        aevm_wp(ii,:) = pcs_wp{ii}.motion.explained(1:10); aevm_wr(ii,:) = pcs_wr{ii}.motion.explained(1:10);
        count_pcsm_wp(ee,ii) = sum(pcs_wp{ii}.motion.explained > ev_threshold(ee))/N_w(ii);
        count_pcsm_wr(ee,ii) = sum(pcs_wr{ii}.motion.explained > ev_threshold(ee))/N_w(ii);
    end
end

colVar1 = [ones(1,16) 2*ones(1,8)];
betweenTableCtrlp = array2table(aevm_bp); betweenTableCtrlr = array2table(aevm_br);
betweenTableCtrl = [betweenTableCtrlp betweenTableCtrlr];
betweenTablePrknp = array2table(aevm_wp); betweenTablePrknr = array2table(aevm_wr);
betweenTablePrkn = [betweenTablePrknp betweenTablePrknr];
for ii = 1:10
    varNames{ii} = sprintf('P%d',ii);
end
for ii = 11:20
    varNames{ii} = sprintf('R%d',ii-10);
end
betweenTableCtrl.Properties.VariableNames = varNames; betweenTablePrkn.Properties.VariableNames = varNames;
betweenTable = [table(colVar1','VariableNames',{'Group'}) [betweenTableCtrl;betweenTablePrkn]];
betweenTable.Group = categorical(betweenTable.Group);
withinTable = table([ones(1,10) 2*ones(1,10)]','VariableNames',{'Type'});
withinTable.Type = categorical(withinTable.Type);
rm = fitrm(betweenTable,'P1-P10,R1-R10~Group');
rm.WithinDesign = withinTable;
mc1 = find_sig_mctbl(multcompare(rm,'Group','By','Type','ComparisonType','bonferroni'),6);
mc2 = find_sig_mctbl(multcompare(rm,'Type','By','Group','ComparisonType','bonferroni'),6);
mc3 = multcompare(rm,'Group','ComparisonType','bonferroni')
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

function order = find_order_based_on_mean(allData)
md = mean(allData,2);
[mds,order] = sort(md);