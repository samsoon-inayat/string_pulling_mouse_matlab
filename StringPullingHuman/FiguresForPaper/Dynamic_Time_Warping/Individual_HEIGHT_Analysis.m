clear all
clc
load('ALL_Reaches.mat')
A = struct2cell(Cycle);
A = squeeze(A)';

% timeWarpOneAnimal(A(:,1));
% return;

Len = cellfun(@length, A);
ALL_Time_height = [];
n = max(Len(:));
ALL_Reach = [];
Ani_E = [];
ap = 0;
for tt = 1:10
    T_pulls = find(Len(:,tt));
    M_Time(tt)= mean(Len(T_pulls,tt))./60;
    ap = ap+length(T_pulls);
    Ani_E = [Ani_E; ap];
    
    
    B = num2cell(A(T_pulls,tt));
    HEIGHT_all=cellfun(@(x) max(cell2mat(x)),B);
    
    HEIGHT_avg(tt) = mean(HEIGHT_all);
    Ani = ones(1,length(T_pulls))'.*tt;
    Val = Len(T_pulls,tt);
    
    RES = [Ani Val HEIGHT_all];
    ALL_Time_height = [ALL_Time_height; RES];
        
    %     n = max(max(cellfun(@(x)size(cell2mat(x),1),B)));
    
    CAT_MAT = cellfun(@(x)[cell2mat(x); zeros(1,n-numel(cell2mat(x)))']', B, 'uni', 0);
    ALL_Reach = [ALL_Reach; cell2mat(CAT_MAT)];
    
    
    
end


% figure; dtw(ALL_Reach(20,:),ALL_Reach(28,:) )



Ani_S = [1 ; Ani_E(1:end-1)+1];
%% The following section is average of averages

M_DTW_ALL_INDIV = [];
for uu = 1:10

WT_ALL = ALL_Reach(Ani_S(uu):Ani_E(uu),:);
mean_INDIV = mean(ALL_Reach(Ani_S(uu):Ani_E(uu),:));
DTW_ALL_INDIV = [];
for yy = Ani_S(uu):Ani_E(uu)
    SIG_W = ALL_Reach(yy,:);
    [ds,ix,iy] = dtw(mean_INDIV,SIG_W);
    %     VAL(yy).xval = ix;
    %     VAL(yy).yval = iy;
    DTW_ALL_INDIV = [DTW_ALL_INDIV; SIG_W(iy(1:23))];
end
M_DTW_ALL_INDIV = [M_DTW_ALL_INDIV; mean(DTW_ALL_INDIV)];

end


n = 0;
%% AVG-AVG Time warp
hf = figure(10000);clf;set(gcf,'Units','Inches');set(gcf,'Position',[15 7 3 2],'color','w');
hold on;
AN_Each_S = [1 6];
AN_Each_E = [5 10];
M_ANI = [];
tme = (0:22)./60;


for ee = 1

WT_ANI = M_DTW_ALL_INDIV(AN_Each_S(ee):AN_Each_E(ee),:);
mean_INDIV = mean(M_DTW_ALL_INDIV(AN_Each_S(ee):AN_Each_E(ee),:));
DTW_ANI_INDIV = [];
for yy = AN_Each_S(ee):AN_Each_E(ee)
    SIG_W = M_DTW_ALL_INDIV(yy,:);
    [ds,ix,iy] = dtw(mean_INDIV,SIG_W);
    %     VAL(yy).xval = ix;
    %     VAL(yy).yval = iy;
    DTW_ANI_INDIV = [DTW_ANI_INDIV; SIG_W(iy(1:23))];
end
M_ANI = [M_ANI; mean(DTW_ANI_INDIV)];
% fgg = figure; hold on; 
plot(tme(1:19), DTW_ANI_INDIV(:,1:19)','color','c')
hold on; plot(tme(1:19), M_ANI(1:19), 'LineWidth',4,'color', 'b')

% hold on; plot(tme, DTW_ANI_INDIV','color',[0.75 0.75 0.75])
% hold on; plot(tme, M_ANI, 'LineWidth',4,'color', 'k')
end


M_ANI = [];


for ee = 2

WT_ANI = M_DTW_ALL_INDIV(AN_Each_S(ee):AN_Each_E(ee),:);
mean_INDIV = mean(M_DTW_ALL_INDIV(AN_Each_S(ee):AN_Each_E(ee),:));
DTW_ANI_INDIV = [];
for yy = AN_Each_S(ee):AN_Each_E(ee)
    SIG_W = M_DTW_ALL_INDIV(yy,:);
    [ds,ix,iy] = dtw(mean_INDIV,SIG_W);
    %     VAL(yy).xval = ix;
    %     VAL(yy).yval = iy;
    DTW_ANI_INDIV = [DTW_ANI_INDIV; SIG_W(iy(1:23))];
end
M_ANI = [M_ANI; mean(DTW_ANI_INDIV)];
% fgg = figure; hold on; plot(tme(1:19), DTW_ANI_INDIV(:,1:19)','color','c')
% hold on; plot(tme(1:19), M_ANI(1:19), 'LineWidth',4,'color', 'b')

hold on; plot(tme, DTW_ANI_INDIV','color',[0.75 0.75 0.75])
hold on; plot(tme, M_ANI, 'LineWidth',4,'color', 'k')
end

% title('Reaches per animal with dynamic time warping')
xlabel('Time (s)')
ylabel('Amplitude (mm)')
% set(gca,'FontSize',13, 'fontWeight','bold')
set(gca,'FontSize',7,'FontWeight','Bold','TickDir','out');
changePosition(gca,[-0.01 -0.01 0.03 0]);
legs = {'Black (N=5)','White (N=5)'};
legs{3} = [0.25 0.01 20 3];
putLegend(gca,legs,'colors',{'k','b'},'sigR',{[],'','k',6},'lineWidth',1);
save_pdf(hf,pwd,sprintf('DTW.pdf'),600);
%%
fgg.Renderer='Painters';

set(fgg, 'Position',  [50, 50, 400, 350])
saveas(fgg, 'Reaches per animal DTW NEW1', 'pdf')
saveas(fgg, 'Reaches per animal DTW NEW1', 'tif')


%% For each reach 
% % % % White 13  (1:35) and Black 17 (36:end)
% % % % mean(ALL_Time(1:35,2))
% % % % mean(ALL_Time(36:end,2))
% % % WT_ALL = ALL_Reach(1:35,:);
% % % mean_White = mean(ALL_Reach(1:35,:));
% % % DTW_ALL_white = [];
% % % for yy = 1:35
% % %     SIG_W = ALL_Reach(yy,:);
% % %     [ds,ix,iy] = dtw(mean_White,SIG_W);
% % %     %     VAL(yy).xval = ix;
% % %     %     VAL(yy).yval = iy;
% % %     DTW_ALL_white = [DTW_ALL_white; SIG_W(iy(1:23))];
% % % end
% % % M_DTW_ALL_white = mean(DTW_ALL_white);
% % % 
% % % % AS = squeeze(struct2cell(VAL));
% % % % LenAS = cellfun(@length, AS);
% % % % min(LenAS(:))
% % % BK_ALL = ALL_Reach(36:end,:);
% % % mean_Black = mean(ALL_Reach(36:end,:));
% % % DTW_ALL_black = [];
% % % for yy = 36:length(ALL_Reach)
% % %     SIG_B = ALL_Reach(yy,:);
% % %     [ds,ix,iy] = dtw(mean_Black,SIG_B);
% % %     %     VAL(yy).xval = ix;
% % %     %     VAL(yy).yval = iy;
% % %     DTW_ALL_black = [DTW_ALL_black; SIG_B(iy(1:23))];
% % % end
% % % M_DTW_ALL_black = mean(DTW_ALL_black);
% % % %%
% % % tme = (0:22)./60;
% % % 
% % % fg1 = figure; plot(tme(1:15),DTW_ALL_white(:,1:15)','color','c'	)
% % % hold on; plot(tme(1:20),DTW_ALL_black(:,1:20)','color',[0.75 0.75 0.75])
% % % hold on; plot(tme, M_DTW_ALL_white,'LineWidth',4,'color', 'b')
% % % hold on; plot(tme, M_DTW_ALL_black,'LineWidth',4,'color', 'k')
% % % set(gca,'FontSize',13, 'fontWeight','bold')
% % % title('Reaches with dynamic time warping')
% % % xlabel('Time (s)')
% % % ylabel('height (mm)')
% % % fg1.Renderer='Painters';
% % % 
% % % set(gcf, 'Position',  [50, 50, 400, 350])
% % % saveas(fg1, 'Reaches with dynamic time warping', 'tif')
% % % saveas(fg1, 'Reaches with dynamic time warping', 'pdf')
% % % 
% % % fg2 = figure; plot(tme(1:15), WT_ALL(:,1:15)','color','c'	)
% % % hold on; plot(tme(1:20), BK_ALL(:,1:20)','color',[0.75 0.75 0.75])
% % % hold on; plot(tme, mean_White,'LineWidth',4,'color', 'b')
% % % hold on; plot(tme, mean_Black,'LineWidth',4,'color', 'k')
% % % set(gca,'FontSize',13, 'fontWeight','bold')
% % % title('Reaches NO DTW')
% % % xlabel('Time (s)')
% % % ylabel('height (mm)')
% % % fg2.Renderer='Painters';
% % % 
% % % set(gcf, 'Position',  [50, 50, 400, 350])
% % % saveas(fg2, 'Reaches NO DTW', 'tif')
% % % saveas(fg2, 'Reaches NO DTW', 'pdf')
% % % 
% % % 
% % % 
