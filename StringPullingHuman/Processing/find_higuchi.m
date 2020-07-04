function out = find_higuchi(f)
fr = reshape(f,size(f,1) * size(f,2),size(f,3));
fr01 = zeros(size(fr));
for ii = 1:size(fr,1)
    fr01(ii,:) = mat2gray(fr(ii,:));
end
sentropy = zeros(1,size(fr,1));
for ii = 1:size(fr,1)
    sentropy(ii) = Higuchi_FD(fr01(ii,:),20);
end
out.ent = reshape(sentropy,size(f,1),size(f,2));
