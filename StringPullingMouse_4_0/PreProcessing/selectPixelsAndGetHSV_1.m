function [hsvMean,decision] = selectPixelsAndGetHSV_1(iRGB, Area,handles,type)
if strcmp(type,'String')
    setParameter(handles,'Number of Color Clusters',7);
end
if strcmp(type,'Fur')
    setParameter(handles,'Number of Color Clusters',5);
end
zw = getParameter(handles,'Auto Zoom Window');
zw = [];
md = get_meta_data(handles);
% if strcmp(type,'Background')
%     zw = getParameter(handles,'Zoom Window');
% %     zw = [1 1 fliplr(handles.md.frameSize)];
% end
% if strcmp(type,'Nose') || strcmp(type,'Ears')
% %     [hb,bb] = get_head_box(handles,[],iRGB,[50 50 100 200],8);
% %     zw = handles.hb;
%     zw = [];%[1 1 size(iRGB,2) size(iRGB,1)];
% %     zw = [1 1 fliplr(handles.md.frameSize)];
% end
warning off;
% RGB = adjustContrast(iRGB);
% iRGB = RGB;
RGB = iRGB;
decision = 'No';
if ~isempty(zw)
tdx = zw(1)+20;
tdy = zw(2)+20;
else
    tdx = 10;
    tdy = 10;
end
objectColor = sprintf('%s Color',type);
hsvMean = getParameter(handles,objectColor);
addColors = 1;
firstTimeRun = 1;
hf = figure(10);clf;
add_window_handle(handles,hf);
set(hf,'WindowStyle','modal');
screenSize = get(0,'ScreenSize');
set(hf,'Position',[50 200 screenSize(3)-100 screenSize(4)-300],'units','Pixels');
% pause(1);
% close(hf)
% return;
quit = 0;
while ~quit
    figure(hf);clf;
%     set(hf,'Position',get(0,'ScreenSize'),'units','Pixels');
    if firstTimeRun
        if ~isempty(hsvMean)
            mc = hsvMean(:,4:6);
            imagesc(RGB);axis equal;
            title('Please wait ... calculating mask');
            ht = text(tdx,tdy,sprintf('Please wait ... calculating mask'),'Color','r','FontWeight','Bold');
            pause(0.1);
            Im = getThisMask(iRGB,mc,size(RGB,1),size(RGB,2),1.5);
            oRGB = imoverlay(RGB,Im);
        else
            oRGB = RGB;
            ht = text(tdx,tdy,sprintf('Please wait ... '),'Color','r','FontWeight','Bold');
        end
        imagesc(oRGB);
        axis equal;
        title('');
        delete(ht);
        if ~isempty(zw)
            xlim([zw(1) zw(3)]);
            ylim([zw(2) zw(4)]);
        end
    end
    
    if ~firstTimeRun | isempty(hsvMean)
        imagesc(oRGB);
        axis equal;
        if ~isempty(zw)
            xlim([zw(1) zw(3)]);
            ylim([zw(2) zw(4)]);
        end

        hold on;
        ha = gca;
        ht = text(tdx,tdy,sprintf('Left click and drag to select a rectangular region containing the %s',type),'Color','r','FontWeight','Bold');
        rect = floor(getrect(ha));
        if rect(3) == 0
            continue;
        end
        rows = rect(2):(rect(2)+rect(4));
        rows(rows>size(iRGB,1)) = [];
        rows(rows<1) = [];
        cols = rect(1):(rect(1)+rect(3));
        cols(cols>size(iRGB,2)) = [];
        cols(cols<1) = [];
        rect = [min(cols) min(rows) max(cols)-min(cols) max(rows)-min(rows)];

        if addColors
            subFrame = double(RGB(rows,cols,:));
            nrows = size(subFrame,1);
            ncols = size(subFrame,2);
            ab = reshape(subFrame,nrows*ncols,3);
        %     if ~strcmp(type,'Background')
        %         oColVals = getParameter(handles,'Background Color');
        %         oColVals = oColVals(:,4:6); % 4:6 column for RGB colors
        %         [C,ia,ib] = intersect(ab,oColVals,'rows');
        %         if ~isempty(ia)
        %             ab(ia,:) = NaN;
        %         end
        %     end
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
            tempMask = zeros(size(RGB(:,:,1)));
            for ii = selClus
                [y,x] = ind2sub(size(subFrame),find(cluster_idx == ii));
                y = y + rect(2)-1;
                x = x + rect(1)-1;
                inds = sub2ind(size(RGB(:,:,1)),y,x);
                tempMask(inds) = 1;
                oRGB = imoverlay(RGB,tempMask);
                figure(10);clf;
                subplot 121;
                imagesc(oRGB);axis equal;
        %         plot(x,y,'.','color',allColors{ii});
            end
            if ~isempty(zw)
                xlim([zw(1) zw(3)]);
                ylim([zw(2) zw(4)]);
            end
            pause(0.3);
            subplot 122
            phsvMean = hsvMean;
            hsvMean = [hsvMean;getRGBColors(RGB,tempMask)];
        end
        if ~addColors
            subFrameRGB = double(RGB(rows,cols,:));
            subFrameIm = double(Im(rows,cols));
            inds = find(subFrameIm);
            rs = subFrameRGB(:,:,1);
            gs = subFrameRGB(:,:,2);
            bs = subFrameRGB(:,:,3);
            theseColors = [rs(inds) gs(inds) bs(inds)];
            originalColors = hsvMean(:,4:6);
            crows = [];
            for ii = 1:size(theseColors,1)
                ed = sqrt(sum((originalColors - theseColors(ii,:)).^2,2));
                crows = [crows;find(ed<s_threshold)];
            end
            ia = unique(crows);
    %         [C,ia,ib] = intersect(originalColors,theseColors,'rows');
            if ~isempty(ia)
                hsvMean(ia,:) = [];
            end
            figure(10);clf;
        end
        hsvMean = unique(hsvMean,'rows');
        mc = hsvMean(:,4:6);
        imagesc(RGB);axis equal;
        title('Please wait ... calculating mask');
        pause(0.1);
        Im = getThisMask(iRGB,mc,size(RGB,1),size(RGB,2),1.5);
        oRGB = imoverlay(RGB,Im);
        imagesc(oRGB);axis equal;
        if ~isempty(zw)
            xlim([zw(1) zw(3)]);
            ylim([zw(2) zw(4)]);
        end
        title('');
    end
    while 1
        quest = 'Please select';
%         if ~firstTimeRun
            nColors = getParameter(handles,'Number of Color Clusters');
            buttonName = sprintf('Edit Number of Clusters (%d)',nColors);
            answers = {'Add colors','Remove colors','Next frame','Skip Frame','Exit','Save colors','Undo',buttonName};
            choice = bttnChoiceDialog(answers, 'Please select', 1, quest, [1 2 3 4;5 6 7 8]);
%         else
%             answers = {'Add colors','Remove colors','Next frame','Skip Frame','Exit','Save colors'};
%             choice = bttnChoiceDialog(answers, 'Please select', 4, quest, [1 2 3;4 5 6]);
%         end
        if choice == 8
            answer = inputdlg('Enter the number of clusters');
            try
                val = str2num(answer{1});
                if val > 7 || val < 1
                    uiwait(msgbox('Enter number of clusters 1-7','Success','modal'));
                    continue;
                end
                setParameter(handles,'Number of Color Clusters',val);
                set(handles.edit_numberOfClusters,'String',num2str(val));
                set(handles.slider_numberOfClusters,'Value',val);
                setParameter(handles,'Number of Color Clusters',val);
            catch
                continue;
            end
            continue;
        end
        answer = answers{choice};
        firstTimeRun = 0;
        if strcmp(answer,'Undo')
            hsvMean = phsvMean;
            if ~isempty(hsvMean)
                mc = hsvMean(:,4:6);
                Im = getThisMask(iRGB,mc,size(RGB,1),size(RGB,2),1.5);
                oRGB = imoverlay(iRGB,Im);
                figure(10);clf;
                imagesc(oRGB);
                axis equal;
                if ~isempty(zw)
                    xlim([zw(1) zw(3)]);
                    ylim([zw(2) zw(4)]);
                end
            else
                figure(10);clf;
                oRGB = RGB;
                imagesc(oRGB);
                axis equal;
                if ~isempty(zw)
                    xlim([zw(1) zw(3)]);
                    ylim([zw(2) zw(4)]);
                end
            end
%             break;
        end
        if strcmp(answer,'Exit')
            hsvMean = getParameter(handles,objectColor);
            decision = 'Exit';
            quit = 1;
            break;
        end
        if strcmp(answer,'Next frame') | strcmp(answer,'Save colors')
            hsvMean = unique(hsvMean,'rows');
            % uCV = findValsAroundMean(uColorVals(:,1:3),[3 100]);
            setParameter(handles,objectColor,hsvMean);
            firstTimeRun = 1;
            if strcmp(answer,'Next frame') 
                quit = 1;
                break;
            end
        end
        if strcmp(answer,'Skip Frame')
    %         hsvMean = getParameter(handles,objectColor);
            quit = 1;
            break;
        end 
        if strcmp(answer,'Add colors')
            addColors = 1;
            break;
        end 
        if strcmp(answer,'Remove colors')
            addColors = 0;
            s_threshold = 1.5;
            break;
    %         prompt = 'Enter matching color threshold (value between 1-5)';
    %         title = 'Color Closeness Threshold Value';
    %         dims = 1;
    %         answer = inputdlg(prompt,title,dims,{'1.5'});
    %         s_threshold = sscanf(answer{1},'%f');
        end 
    end
end

function colVals = getRGBColors(frame,mask)
inds = find(mask);
RGB1 = double(frame);
HSV = rgb2hsv(frame);
HSV = rgb2hsv(HSV);
%         inds = sub2ind(size(RGB(:,:,1)),y,x);
for ii = 1:3
    temp = HSV(:,:,ii);
    vals = temp(inds);
    colVals(:,ii) = vals';
    temp = RGB1(:,:,ii);
    vals = temp(inds);
    colVals(:,ii+3) = vals';
end