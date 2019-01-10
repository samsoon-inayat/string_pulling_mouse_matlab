function hsvMean = selectPixelsAndGetHSV_1(RGB, Area,handles,type)

%
% function hsvMean = selectPixelsAndGetHSV(RGB, Area)
%
% Use this function in order to select multiple points from an image (use
% right click to stop process). The selected points are used to calculate
% the average HSV values.

% ARGUMENTS:
% RGB: the RGB image
% Area: the area size used to calulate the HSV values of each point
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Theodoros Giannakopoulos - January 2008
% www.di.uoa.gr/~tyiannak
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
zw = handles.md.resultsMF.zoomWindow;
if isempty(zw)
    zw = [1 1 fliplr(handles.md.frameSize)];
end
warning off;
% if get(handles.checkbox_rotateLeft,'Value')
%     view(gca,-90,90);
% else
%     view(gca,0,90);
% end

% if ~exist('zw','var')
%     zw = [];
% end

tdx = zw(1)+20;
tdy = zw(2)+20;
while 1
    figure(10);clf;
    imagesc(RGB); axis equal;
    if ~isempty(zw)
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
    end
    hold on;
    ha = gca;
    ht = text(tdx,tdy,sprintf('Left click and drag to select a rectangular region containing the %s',type));
    rect = floor(getrect(ha));
    rows = rect(2):(rect(2)+rect(4));
    rows(rows>handles.md.frameSize(1)) = [];
    rows(rows<1) = [];
    cols = rect(1):(rect(1)+rect(3));
    cols(cols>handles.md.frameSize(2)) = [];
    cols(cols<1) = [];
    rect = [min(cols) min(rows) max(cols)-min(cols) max(rows)-min(rows)];
    subFrame = double(RGB(rows,cols,:));
    nrows = size(subFrame,1);
    ncols = size(subFrame,2);
    ab = reshape(subFrame,nrows*ncols,3);
    nColors = getParameter(handles,'Number of Color Clusters');
    % repeat the clustering 3 times to avoid local minima
    options = statset('UseParallel',0);
    [cluster_idx, cluster_center] = kmeans(ab,nColors,'Options',options,'distance','sqEuclidean','Replicates',6);
    allColors = {'c','m','b','g','y','k','w'};
    figure(10);clf;imagesc(RGB);axis equal;
    hold on;
    if ~isempty(zw)
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
    end
    for ii = 1:nColors
        [y,x] = ind2sub(size(subFrame),find(cluster_idx == ii));
        y = y + rect(2);
        x = x + rect(1);
        plot(x,y,'.','color',allColors{ii});
    end
    delete(ht);
    ht = text(tdx,tdy,sprintf('To select color, left click in %s region',type));
    [X,Y,BUTTON] = ginput(1);
    X = floor(X); Y = floor(Y);

    for ii = 1:nColors
        [y,x] = ind2sub(size(subFrame),find(cluster_idx == ii));
        y = y + rect(2)-1;
        x = x + rect(1)-1;
        Lia = ismember([x y],[X Y],'rows');
        if any(Lia)
            break;
        end
    end
    selClus = ii;

    figure(10);clf;imagesc(RGB);axis equal;
    hold on;
    for ii = selClus
        [y,x] = ind2sub(size(subFrame),find(cluster_idx == ii));
        y = y + rect(2)-1;
        x = x + rect(1)-1;
        plot(x,y,'.','color',allColors{ii});
    end
    if ~isempty(zw)
        xlim([zw(1) zw(3)]);
        ylim([zw(2) zw(4)]);
    end
    opts.Interpreter = 'tex';
    opts.Default = 'No';
    % Use the TeX interpreter to format the question
    quest = 'Confirm the selected region is correct?';
    answer = questdlg(quest,'Please select',...
                      'Yes','No',opts);
    if strcmp(answer,'Yes')
        RGB1 = double(RGB);
        HSV = rgb2hsv(RGB);
        HSV = rgb2hsv(HSV);
        inds = sub2ind(size(RGB(:,:,1)),y,x);
        for ii = 1:3
            temp = HSV(:,:,ii);
            vals = temp(inds);
            hsvMean(:,ii) = vals';
            temp = RGB1(:,:,ii);
            vals = temp(inds);
            hsvMean(:,ii+3) = vals';
        end
%         for ii = 1:3
%             temp = HSV(:,:,ii);inds = sub2ind(size(temp),y,x);
%             temp = temp(inds);
%             hsvMean(1,ii) = temp;
%             hsvMean(2,ii) = std(temp)/sqrt(size(temp,1));
%             temp = RGB1(:,:,ii);
%             temp = temp(inds);
%             hsvMean(3,ii) = mean(temp);
%             hsvMean(4,ii) = std(temp)/sqrt(size(temp,1));
%         end
        break;
    end
end