function out = get_2d_image_xics(fd_ent_b,fd_ent_w,ds_types,str2)

%%
% str1 = {'Descriptive';'Motion';'mean'};
% ds_types = {'mean','median','mode','standard_deviation','skewness','kurtosis'};
% ds_types = {'standard_deviation'};
% ds_types = {'Img','Motion'};

for ii = 1:length(ds_types)
    str1 = ds_types(ii);
    for ss = 1:length(str2)
        str1{(length(str1)+1)} = str2{ss};
    end
    [fd_b,ent_b,fd_w,ent_w,sn_b,sn_w,sp_b,sp_w] =  get_fd_ent (str1,fd_ent_b,fd_ent_w);
    out.all_fd_b(:,ii) = fd_b';
    out.all_fd_w(:,ii) = fd_w';
    out.all_ent_b(:,ii) = ent_b';
    out.all_ent_w(:,ii) = ent_w';
    out.all_sn_b(:,ii) = sn_b';
    out.all_sn_w(:,ii) = sn_w';
    out.all_sp_b(:,ii) = sp_b';
    out.all_sp_w(:,ii) = sp_w';
    [out.hfd(ii),out.pfd(ii),out.cifd{ii},out.statsfd{ii}] = ttest2(fd_b,fd_w);
    [out.hent(ii),out.pent(ii),out.cient{ii},out.statsent{ii}] = ttest2(ent_b,ent_w);
    [out.hsn(ii),out.psn(ii),out.cisn{ii},out.statssn{ii}] = ttest2(sn_b,sn_w);
    [out.hsp(ii),out.psp(ii),out.cisp{ii},out.statssp{ii}] = ttest2(sp_b,sp_w);
    
    out.effect_size_fd(ii) = computeCohen_d(fd_b,fd_w);
    out.effect_size_ent(ii) = computeCohen_d(ent_b,ent_w);
    out.effect_size_sn(ii) = computeCohen_d(sn_b,sn_w);

%     out.power_fd(ii) = sampsizepwr('t2',[mean(fd_b) std(fd_b)],mean(fd_w),[],5,'Ratio',1);
%     out.power_ent(ii) = sampsizepwr('t2',[mean(ent_b) std(ent_b)],mean(ent_w),[],5,'Ratio',1);
%     out.power_sn(ii) = sampsizepwr('t2',[mean(sn_b) std(sn_b)],mean(sn_w),[],5,'Ratio',1);
end

out.mean_fd_b = mean(out.all_fd_b); out.sem_fd_b = std(out.all_fd_b)/sqrt(5);
out.mean_fd_w = mean(out.all_fd_w); out.sem_fd_w = std(out.all_fd_w)/sqrt(5);
out.mean_ent_b = mean(out.all_ent_b); out.sem_ent_b = std(out.all_ent_b)/sqrt(5);
out.mean_ent_w = mean(out.all_ent_w); out.sem_ent_w = std(out.all_ent_w)/sqrt(5);
out.mean_sn_b = mean(out.all_sn_b); out.sem_sn_b = std(out.all_sn_b)/sqrt(5);
out.mean_sn_w = mean(out.all_sn_w); out.sem_sn_w = std(out.all_sn_w)/sqrt(5);
out.mean_sp_b = mean(out.all_sp_b); out.sem_sp_b = std(out.all_sp_b)/sqrt(5);
out.mean_sp_w = mean(out.all_sp_w); out.sem_sp_w = std(out.all_sp_w)/sqrt(5);

out.std_fd_b = std(out.all_fd_b);
out.std_fd_w = std(out.all_fd_w);
out.std_ent_b = std(out.all_ent_b);
out.std_ent_w = std(out.all_ent_w);
out.std_sn_b = std(out.all_sn_b);
out.std_sn_w = std(out.all_sn_w);
out.std_sp_b = std(out.all_sp_b);
out.std_sp_w = std(out.all_sp_w);




