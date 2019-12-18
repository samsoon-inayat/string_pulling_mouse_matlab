function out = find_entropy(f)
fr = reshape(f,size(f,1) * size(f,2),size(f,3));
sentropy = zeros(1,size(fr,1));
for ii = 1:size(fr,1)
    thisRow = mat2gray(fr(ii,:));
    sentropy(ii) = entropy(thisRow);
end
out.ent = reshape(sentropy,size(f,1),size(f,2));
