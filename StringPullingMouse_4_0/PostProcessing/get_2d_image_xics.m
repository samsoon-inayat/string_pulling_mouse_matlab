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
    [out.hfd(ii),out.pfd(ii),out.cifd,out.statsfd] = ttest2(fd_b,fd_w);
    [out.hent(ii),out.pent(ii),out.cient,out.statsent] = ttest2(ent_b,ent_w);
    [out.hsn(ii),out.psn(ii),out.cisn,out.statssn] = ttest2(sn_b,sn_w);
    [out.hsp(ii),out.psp(ii),out.cisp,out.statssp] = ttest2(sp_b,sp_w);
end

out.mean_fd_b = mean(out.all_fd_b); out.sem_fd_b = std(out.all_fd_b)/sqrt(5);
out.mean_fd_w = mean(out.all_fd_w); out.sem_fd_w = std(out.all_fd_w)/sqrt(5);
out.mean_ent_b = mean(out.all_ent_b); out.sem_ent_b = std(out.all_ent_b)/sqrt(5);
out.mean_ent_w = mean(out.all_ent_w); out.sem_ent_w = std(out.all_ent_w)/sqrt(5);
out.mean_sn_b = mean(out.all_sn_b); out.sem_sn_b = std(out.all_sn_b)/sqrt(5);
out.mean_sn_w = mean(out.all_sn_w); out.sem_sn_w = std(out.all_sn_w)/sqrt(5);
out.mean_sp_b = mean(out.all_sp_b); out.sem_sp_b = std(out.all_sp_b)/sqrt(5);
out.mean_sp_w = mean(out.all_sp_w); out.sem_sp_w = std(out.all_sp_w)/sqrt(5);