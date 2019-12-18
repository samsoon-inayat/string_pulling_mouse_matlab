function [success,temp] = find_mask_grid_way (handles,thisFrame,cF,grid_specs)
% string_thickness = floor(getParameter(handles,'String Thickness in Pixels'));
nbins = grid_specs(1:2);
threshold = grid_specs(3);
Im = thisFrame(:,:,1);
pst = 1;
est = size(Im,1);
psth = 1;
esth = size(Im,2);
binsh = floor(size(thisFrame,2)/nbins(1)); binsv = floor(size(thisFrame,1)/nbins(2));
bin_width = [binsv binsh];
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
radius = 1;%getParameter(handles,'Range Search Radius');
success = 1;
for ii = 1:length(st)
    rows = st(ii):et(ii);
    cols = 1:size(Im,2);
    subFrame = thisFrame(rows,cols,:);
%     num_fur = [];
%     num_string = [];
%     num_background = [];
    for jj = 1:length(sth)
        if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
            axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
            success = 0;temp = [];
            return;
        end
        sub_subFrame = subFrame(:,sth(jj):eth(jj),:);
        temp = getThisMask(sub_subFrame,cF,size(sub_subFrame(:,:,1),1),size(sub_subFrame(:,:,1),2),radius);
        num_fur(ii,jj) = sum(temp(:));
%         temp = getThisMask(sub_subFrame,cS,size(sub_subFrame(:,:,1),1),size(sub_subFrame(:,:,1),2),300);
%         num_string(ii,jj) = sum(temp(:));
%         temp = getThisMask(sub_subFrame,cB,size(sub_subFrame(:,:,1),1),size(sub_subFrame(:,:,1),2),300);
%         num_background(ii,jj) = sum(temp(:));
    end
%     figure(10);clf;
%     plot(num_fur,'b');hold on;
%     plot(num_string,'r');
%     plot(num_background,'k');
%     title(ii);
%     pause(0.1);
%     anf(ii,:) = num_fur;
%     ans(ii,:) = num_string;
%     anb(ii,:) = num_background;
%     n = 0;
end

threshold_number = threshold*binsv*binsh;
xsf = num_fur > threshold_number;
% xss = num_string > threshold_number;
% for ii = 1:length(st)
%     xsf(ii,:) = num_fur(ii,:) > threshold_number;
%     xss(ii,:) = num_string(ii,:) > threshold_number;
%     figure(10);clf;plot(num_fur(ii,:),num_string(ii,:));
%     title(ii)
%     pause(0.3);
% end

% sxs = xsf + 2*xss;

% C = conv2(sxs,[1 2 1]);
% [rr,cc] = find(C>=6);
[rr,cc] = find(xsf);
% [~,mrri] = min(rr);
% string_body_intersection = [st(rr(mrri)) sth(cc(mrri))];
% M.topPoint = string_body_intersection(1);
temp = zeros(size(Im));
for ii = 1:length(rr)
    temp(st(rr(ii)):et(rr(ii)),sth(cc(ii)):eth(cc(ii))) = 1;
end
% Ih = imfill(temp,'holes');
% Ih = bwareaopen(Ih,100,8);
% Ih = bwconvhull(Ih,'objects');
% Im = double(Im).*temp;
