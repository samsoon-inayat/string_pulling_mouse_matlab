function mask = compute_masks_KNN_select(handles,frame,object,mc)

MMT = str2double(get(handles.edit_mouseMaskTol,'String'));
% if get(handles.checkbox_useSimpleMasks,'Value')
%     sm = 1;
%     rgb = 1;
% else
    sm = 1;
    rgb = 1;
% end

intsct = 0;
if rgb
    colorCols = 4:6;
    hsvFrame = frame;
else
    colorCols = 1:3;
    hsvFrame = rgb2hsv(frame);
%     hsvFrame = rgb2hsv(hsvFrame);
end
nrows = size(frame,1);
ncols = size(frame,2);

numberOfPoints = getParameter(handles,'KNN Search Number of Points');


if strcmp(object,'background')
%     mc = getColors(handles,'Background',colorCols,intsct);%mouseColors(:,colorCols);
    if sm
        Im = getThisMask_KNN(hsvFrame,mc,nrows,ncols,numberOfPoints);
    else
        Im = getThisMask(hsvFrame,mc,nrows,ncols,numberOfPoints);
    end
    mask = Im;
end

if strcmp(object,'body')
%     mc = getColors(handles,'Fur',colorCols,0);%mouseColors(:,colorCols);
    if sm
        Im = getThisMask_KNN(hsvFrame,mc,nrows,ncols,numberOfPoints);
    else
        Im = getThisMask(hsvFrame,mc,nrows,ncols,numberOfPoints);
    end
%     Iback = compute_masks_KNN(handles,frame,'background',1);
%     mask = (~Iback)&Im;
    mask = Im;
end
if strcmp(object,'ears')
%     ec = getolors(handles,'Ears',colorCols,intsct);%earColors(:,colorCols);
    ec = mc;
    if sm
        Ie = getThisMask_KNN(hsvFrame,(ec),nrows,ncols,numberOfPoints);
    else
        Ie = getThisMask(hsvFrame,(ec),nrows,ncols,numberOfPoints);
    end
    mask = Ie;
end

if strcmp(object,'hands')
%     hc = getColors(handles,'hands',colorCols,intsct);%handColors(:,colorCols);
    hc = mc;
    if sm
        Ih = getThisMask_KNN(hsvFrame,hc,nrows,ncols,numberOfPoints);
    else
        Ih = getThisMask(hsvFrame,hc,nrows,ncols,numberOfPoints);
    end
    mask = Ih;
end


if strcmp(object,'string')
%     sc = getColors(handles,'String',colorCols,intsct);
    sc = mc;
    if sm
        Is = getThisMask_KNN(hsvFrame,sc,nrows,ncols,numberOfPoints);
    else
        Is = getThisMask(hsvFrame,sc,nrows,ncols,numberOfPoints);
    end
    mask = Is;
end


if strcmp(object,'nose')
%     mc = getColors(handles,'Nose',colorCols,intsct);%mouseColors(:,colorCols);
    if sm
        Im = getThisMask_KNN(hsvFrame,mc,nrows,ncols,numberOfPoints);
    else
        Im = getThisMask(hsvFrame,mc,nrows,ncols,numberOfPoints);
    end
    mask = Im;
end
