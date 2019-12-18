function frame = remove_string(handles,frame,cS,cF)

pd = get_processed_data(handles);
if ~isempty(pd)
    if isfield(pd,'frames_no_string')
        frame = pd.frames_no_string;
        return;
    end
end

if iscell(frame)
    for ii = 1:length(frame)
        ii
        frame{ii} = remove_string_frame(frame{ii},cS,cF);
    end
    pd.frames_no_string = frame;
    set_processed_data(handles,pd);
else
    frame = remove_string_frame(frame,cS,cF);
end

function frame = remove_string_frame(frame,cS,cF)

radius = 2.5;

nrows = size(frame,1);
ncols = size(frame,2);

temp = getThisMask(frame,cS,size(frame(:,:,1),1),size(frame(:,:,1),2),radius);
% tempF = getThisMask(frame,cF,size(frame(:,:,1),1),size(frame(:,:,1),2),1);
% for rr = 1:size(tempF,1)
%     thisRow = tempF(rr,:);
%     thisRow = conv(thisRow,[1 1 1 1 1 1 1 1],'same');
%     tempF(rr,:) = thisRow;
% end
% tempF(tempF > 0) = 1; tempF(tempF < 0) = 0;
% itemp = tempF & temp;
% [rr,cc] = find(itemp); 
% r = randi([1 size(cF,1)],1,length(rr));
% for ii = 1:length(rr)
%     frame(rr(ii),cc(ii),:) = cF(r(ii),:)';
% end
% temp = getThisMask(frame,cS,size(frame(:,:,1),1),size(frame(:,:,1),2),radius);
temp = reshape(temp,nrows*ncols,1);
temp = conv(temp,[1 1 1 1 1 1 1],'same');
temp(temp > 0) = 1; temp(temp < 0) = 0;
temp = reshape(temp,nrows,ncols);
numA = 7;
for rr = 1:size(temp,1)
    thisRow = temp(rr,:);
    dtr = diff(thisRow);
    rising = find(dtr > 0);
    falling = find(dtr < 0);
    if length(rising) ~= length(falling)
        if length(rising) > length(falling)
            falling = [falling size(frame,2)];
        else
            rising = [1 rising];
        end
    end
    for jj = 1:length(rising)
        pixelsToChange = rising(jj):falling(jj);
        if isempty(pixelsToChange)
            continue;
        end
        ri = (rising(jj)-numA); re = (rising(jj)-1); fi = (falling(jj)+1); fe = (falling(jj)+numA);
        if re < 1
            ri = []; re = [];
        else
            if ri < 1 && re >= 1
                ri = 1;
            end
        end
        if fi > size(frame,2)
            fi = [];
            fe = [];
        else
            if fe > size(frame,2) && fi <= size(frame,2)
                fe = size(frame,2);
            end
        end
        ptc = pixelsToChange;
        midP = floor(length(pixelsToChange)/2);
        pixelsToChange = ptc(1:midP);
        if isempty(pixelsToChange)
            continue;
        end
        changeWith = [ri:re];
        if ~isempty(changeWith)
            r = randi([1 length(changeWith)],1,length(pixelsToChange));
            inds = changeWith(r);
            frame(rr,pixelsToChange,:) = repmat(mean(frame(rr,inds,:),2),1,length(pixelsToChange),1);
        end
        
        pixelsToChange = ptc(midP:end);
        changeWith = [fi:fe];
        if ~isempty(changeWith)
            r = randi([1 length(changeWith)],1,length(pixelsToChange));
            inds = changeWith(r);
            frame(rr,pixelsToChange,:) = frame(rr,inds,:);
        end
    end
end
