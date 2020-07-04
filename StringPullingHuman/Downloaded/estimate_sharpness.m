% Estimate sharpness using the gradient magnitude.
% sum of all gradient norms / number of pixels give us the sharpness
% metric.
function [sharpness]=estimate_sharpness(G)
[Gx, Gy]=gradient(G);
S=sqrt(Gx.*Gx+Gy.*Gy);
sharpness=sum(sum(S))./(numel(Gx));
end