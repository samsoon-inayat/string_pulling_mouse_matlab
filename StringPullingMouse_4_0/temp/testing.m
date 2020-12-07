figure(1000);clf;
noseX = (dataT{:,23}- 230);
noseY = dataT{:,24};
noseY = (365-(noseY-55));
cmap = colormap(parula(length(noseX)));
hold on;
for ii = 2:length(noseX)
    plot([noseX(ii-1) noseX(ii)],[noseY(ii-1) noseY(ii)],'color',cmap(ii,:),'linewidth',3);
end
cbh = colorbar
cbh_title = get(cbh,'title');
set(cbh_title,'String','Frames');
set(cbh,'Xtick',[0 1],'XTickLabel',{'41','207'})
box on
axis equal
ylim([0 365])
xlim([0 200])

xlabel('pixels');
ylabel('pixels');
%%
nbinsX = 20;
nbinsY = 25;
binsX = linspace(0,200,nbinsX+1);
binsY = linspace(0,365,nbinsY+1);

pmap = zeros(nbinsY,nbinsX);
fnums = cell(nbinsY,nbinsX);
tmap = pmap;
n = 0;
%%
for xx = 1:nbinsX
    xstart = binsX(xx);
    xend = binsX(xx+1);
    xpoints = find(noseX >=xstart & noseX < xend);
    if isempty(xpoints)
        continue;
    end
    tnoseY = noseY(xpoints);
    for yy = 1:nbinsY
        ystart = binsY(yy);
        yend = binsY(yy+1);
        ypoints = find(tnoseY >=ystart & tnoseY < yend);
        if isempty(ypoints)
            continue;
        else
            pmap(yy,xx) = length(ypoints);
            fnums{yy,xx} = ypoints;
        end
    end
end
pmap1 = pmap/sum(pmap(:));
f_pmap = imgaussfilt(pmap1,1);
figure(2000);clf;imagesc(f_pmap);
set(gca,'Ydir','normal')
axis equal
axis off
cbh = colorbar
cbh_title = get(cbh,'title');
set(cbh_title,'String','Probability');
changePosition(gca,[0 0 0 0])
changePosition(cbh,[0.01 -0.001 0 0])
n = 0;
%%
[rr,cc] = find(f_pmap > 0.03);
frameNums = [];
for ii = 1:length(rr)
    frameNums = [frameNums;fnums{rr(ii),cc(ii)}];
end
frameNums = unique(frameNums);
%%
fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
handles = guidata(fh);
% [sfn,efn] = getFrameNums(handles);
% frameNums1 = sfn:efn;
% ds = descriptive_statistics(handles,frameNums1)
fn = get_zoomed_frames(handles,41:207,0);
fng = convertToGrayScale(handles,fn,0);
motion = load_motion(handles);
sicps = motion.speedInCmPerSec;
mspeed = mean(sicps(:,:,frameNums),3);
oframeNums = setdiff(1:size(sicps,3),frameNums);
omspeed = mean(sicps(:,:,oframeNums),3);
stdspeed = std(sicps(:,:,frameNums),[],3);
mframe = mean(fng(:,:,frameNums),3);
figure(3000);clf;
subplot(1,2,1);
imagesc(mspeed,[0,10]);
axis equal
axis off
cbh = colorbar
cbh_title = get(cbh,'title');
set(cbh_title,'String','Speed (mm/sec)');
changePosition(gca,[0 0 0 0])
changePosition(cbh,[0 0 0 0])
title('Mean Speed (sweet spot)');

subplot(1,2,2);
imagesc(omspeed,[0,10]);
axis equal
axis off
cbh = colorbar
cbh_title = get(cbh,'title');
set(cbh_title,'String','Speed (mm/sec)');
changePosition(gca,[0 0 0 0])
changePosition(cbh,[0 0 0 0])
title('Mean Speed (around sweet spot)');