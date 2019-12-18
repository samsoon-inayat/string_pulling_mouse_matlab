function [fd_b,ent_b,fd_w,ent_w,sn_b,sn_w,sp_b,sp_w] =  get_fd_ent (str1,fd_ent_b,fd_ent_w)
% str1 = {'Descriptive';'Motion';'mean'};
% str1 = {'Descriptive';'Masks';'standard_deviation';'Hands'};
% str1 = {'Entropy';'Motion'};
% str1 = {'Descriptive';'Motion';'mean'};
% str1 = {'PC1';'Motion'};
% str1 = {'Max IC';'Motion'};
for ii = 1:5
    thisVal = fd_ent_b{ii}.fd_ent;
    C = thisVal(:,1);
    inds = logical(ones(size(C)));
    for jj = 1:length(str1)
        inds = inds & contains(C,str1{jj});
    end
    fd_b(ii) = thisVal{inds,2};
    ent_b(ii) = thisVal{inds,3};
    sn_b(ii) = thisVal{inds,4};
    sp_b(ii) = thisVal{inds,5};
    
    thisVal = fd_ent_w{ii}.fd_ent;
    C = thisVal(:,1);
    inds = logical(ones(size(C)));
    for jj = 1:length(str1)
        inds = inds & contains(C,str1{jj});
    end
    fd_w(ii) = thisVal{inds,2};
    ent_w(ii) = thisVal{inds,3};
    sn_w(ii) = thisVal{inds,4};
    sp_w(ii) = thisVal{inds,5};
end