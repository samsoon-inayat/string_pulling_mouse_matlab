function generateColorHistograms(handles)
% 1-hand, 2-Fur, 3-String, 4-Ear

types = {'Hands','Fur','String','Ears'};
colorString = {'r','g','b'};
bins = 0:4:255;
figure(2000);clf
for ii = 1:4
    temp = handles.md.resultsMF.colors(1,ii);
    theseColors = temp{1};
    theseColors = theseColors(:,4:6);
    subplot(2,3,ii);
    r = theseColors(:,1);
    g = theseColors(:,2);
    b = theseColors(:,3);
    [bar1 xs] = hist(r,bins);
    [bar2 xs] = hist(g,bins);
    [bar3 xs] = hist(b,bins);
    allBars = [100*bar1/sum(bar1);100*bar2/sum(bar2);100*bar3/sum(bar3)];
    hs = plot(xs,allBars','linewidth',1.25);
    xlim([bins(1) bins(end)]);
    ylim([0 60]);
    set(gca,'TickDir','out','FontSize',12,'FontWeight','Bold');
    xlabel('Color Vals');
    ylabel('Percentage');
    title(types{ii});
    for jj = 1:3
        hs(jj).Color = colorString{jj};
    end
    hold on;
    if ii == 1
        legendText = {'Red','Green','Blue'};
        thisCols = {'r','g','b'};
        x1 = 100; x2 = x1+10; y1 = (30:-5:0); y1 = y1(1:3); y2 = y1;
        legendFontSize = 9;
        for ii = 1:length(legendText)
            plot([x1 x2],[y1(ii) y2(ii)],'color',thisCols{ii},'linewidth',1.5);
            text(x2+5,y1(ii),sprintf('%s',legendText{ii}),'Color',thisCols{ii},'FontSize',legendFontSize);
        end
    end
end

subplot(2,3,6);
global frames;
frame1 = frames{1};
imagesc(frame1);
rect = floor(getrect(gca));
rows = rect(2):(rect(2)+rect(4));
cols = rect(1):(rect(1)+rect(3));
r = []; g = []; b = []; ind = 1;
for ii = 1:length(rows)
    for jj = 1:length(cols)
        r(ind) = frame1(rows(ii),cols(jj),1);
        g(ind) = frame1(rows(ii),cols(jj),2);
        b(ind) = frame1(rows(ii),cols(jj),3);
        ind = ind + 1;
    end
end
[bar1 xs] = hist(r,bins);
[bar2 xs] = hist(g,bins);
[bar3 xs] = hist(b,bins);
allBars = [100*bar1/sum(bar1);100*bar2/sum(bar2);100*bar3/sum(bar3)];
hs = plot(xs,allBars','linewidth',1.25);
xlim([bins(1) bins(end)]);
ylim([0 60]);
set(gca,'TickDir','out','FontSize',12,'FontWeight','Bold');
xlabel('Color Vals');
ylabel('Percentage');
title('Background');
for jj = 1:3
    hs(jj).Color = colorString{jj};
end
save2pdf('colorHist.pdf',gcf,600);
n = 0;