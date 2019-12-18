function o = find_feature_grid (handles,thisFrame,cv,verticalG,horizontalG,bin_width,threshold)

Im = thisFrame(:,:,1);
pst = verticalG(1);
est = verticalG(2);

psth = horizontalG(1);
esth = horizontalG(2);

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
radius = 1;
for ii = 1:length(st)
    rows = st(ii):et(ii);
    cols = 1:size(Im,2);
    subFrame = thisFrame(rows,cols,:);
    for jj = 1:length(sth)
        sub_subFrame = subFrame(:,sth(jj):eth(jj),:);
        for kk = 1:length(cv)
%             if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
%                 o = [];
%                 return;
%             end
            temp = getThisMask(sub_subFrame,cv{kk},size(sub_subFrame(:,:,1),1),size(sub_subFrame(:,:,1),2),radius);
            num_mask{kk}(ii,jj) = sum(temp(:));
        end
    end
%     pause(0.01);
end

for ii = 1:length(cv)
    threshold_number = threshold(ii)*bin_width(1)*bin_width(2);
    xs{ii} = num_mask{ii} > threshold_number;
end

o.vert = [st;et];
o.horiz = [sth;eth];
o.xs = xs;