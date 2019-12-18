function find_spatiotemporal_color_diversity(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
end

frames = get_frames(handles);
zw = getParameter(handles,'Auto Zoom Window');
thisFrame = frames{1};
thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
Im = thisFrame(:,:,1);

binsh = floor(size(thisFrame,2)/30); binsv = floor(size(thisFrame,1)/30);Im = thisFrame(:,:,1);
bin_width = [binsv binsh];

pst = 1; est = size(thisFrame,1);
psth = 1; esth = size(thisFrame,2);

if bin_width(1) == size(thisFrame,1)
    st = 1;
    et = size(thisFrame,1);
else
    st = fliplr((est-bin_width(1)):(-bin_width(1)):pst);
    et = st + bin_width(1);
end

if bin_width(2) == size(thisFrame,2)
    sth = 1;
    eth = size(thisFrame,2);
else
    sth = psth:bin_width(2):esth;
    eth = sth + bin_width(2);
    inds = find(eth > size(thisFrame,2));
    eth(inds) = []; sth(inds) = [];
end
[sfn,efn] = getFrameNums(handles);
frameNums = sfn:efn;
for ii = 1:length(frameNums)
    fn = frameNums(ii);
    Rs(:,:,ii) = frames{fn}(zw(2):zw(4),zw(1):zw(3),1);
    Gs(:,:,ii) = frames{fn}(zw(2):zw(4),zw(1):zw(3),2);
    Bs(:,:,ii) = frames{fn}(zw(2):zw(4),zw(1):zw(3),3);
end

for ii = 1:length(st)
    rows = st(ii):et(ii);
    for jj = 1:length(sth)
        [ii jj]
        cols = sth(jj):eth(jj);
        subFrameR = Rs(rows,cols,:);
        subFrameR = reshape(subFrameR,length(rows) * length(cols),length(frameNums));
        subFrameG = Gs(rows,cols,:);
        subFrameG = reshape(subFrameG,length(rows) * length(cols),length(frameNums));
        subFrameB = Bs(rows,cols,:);
        subFrameB = reshape(subFrameB,length(rows) * length(cols),length(frameNums));
        intR = subFrameR(:,1);
        intG = subFrameG(:,1);
        intB = subFrameB(:,1);
        for n = 2:length(frameNums)
            intR = intersect(intR,subFrameR(:,n));
            intG = intersect(intG,subFrameG(:,n));
            intB = intersect(intB,subFrameB(:,n));
        end
        iouR(ii,jj) = length(intR)/(length(frameNums)*length(subFrameR(:,1))-length(intR));
        iouG(ii,jj) = length(intG)/(length(frameNums)*length(subFrameG(:,1))-length(intG));
        iouB(ii,jj) = length(intB)/(length(frameNums)*length(subFrameB(:,1))-length(intB));
    end
end
iou = (iouR + iouG + iouB)/3;

hf = figure_window(handles,100);
clf;
imagesc(iou);
axis equal;
colorbar
n = 0;
