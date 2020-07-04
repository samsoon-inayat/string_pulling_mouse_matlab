function hc = putColorBar(hai,positionShift,minmax,fs)

pos = get(hai,'Position');
ha = axes('Position',pos,'Visible','off');
hc = colorbar('location','eastoutside');
set(hc,'EdgeColor','none');
changePosition(ha,positionShift);
colormap jet;
if any(isnan(minmax))
    return;
end
caxis(minmax);
xlims = xlim;
xincr = 0.3; yincr = 0.125;
if minmax(1) > 10
    minmax(1) = round(minmax(1));
end
if minmax(2) > 10
    minmax(2) = round(minmax(2));
end
if abs(minmax(1)) > 10
    if minmax(1) < 0
        text(xlims(2)+xincr,0-yincr,sprintf('-%d',-round(minmax(1))),'FontSize',fs);
    else
        text(xlims(2)+xincr,0-yincr,sprintf('%d',minmax(1)),'FontSize',fs);
    end
else
    text(xlims(2)+xincr,0-yincr,sprintf('%.1f',minmax(1)),'FontSize',fs);
end
if abs(minmax(2)) > 10
    if minmax(2) < 0
        text(xlims(2)+xincr,1+yincr,sprintf('-%d',-round(minmax(2))),'FontSize',fs);
    else
        text(xlims(2)+xincr,1+yincr,sprintf('%d',minmax(2)),'FontSize',fs);
    end
else
    text(xlims(2)+xincr,1+yincr,sprintf('%.1f',minmax(2)),'FontSize',fs);
end
axis off; box off;
set(hc,'Ticks',minmax,'TickLabels',{});
minmax;
% try
%     set(hc,'Ticks',[minpcs maxpcs],'TickLabels',{sprintf('%.1f',(minpcs)),sprintf('%.1f',(maxpcs))},'FontSize',7);
% catch
% end