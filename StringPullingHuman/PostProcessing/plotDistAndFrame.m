function plotDistAndFrame(fn,distL,pks,locs,npks,nlocs,thisFrame,sL)
figure(fn);clf;
plot(distL);hold on;
plot(nlocs,distL(nlocs),'b*');plot(locs,pks,'r*');
for ii = 1:length(pks)
%     txt = sprintf('%.1f',p(ii));
    txt = sprintf('%d',ii);
    text(locs(ii),pks(ii),txt,'FontSize',7);
end
for ii = 1:length(npks)
%     txt = sprintf('%.1f',p(ii));
    txt = sprintf('%d',ii);
    text(nlocs(ii),distL(nlocs(ii)),txt,'FontSize',7);
end
ylims = ylim;
plot([sL sL],ylims,'m');
% iha = axes('Position',[0.2 0.7 0.2 0.2]);
figure(fn+1);
imagesc(thisFrame);
axis off;
