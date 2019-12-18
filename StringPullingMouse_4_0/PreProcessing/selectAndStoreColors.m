function selectAndStoreColors(handles,type)
% fn = round(get(handles.slider1,'Value'));
fn = get(handles.figure1,'userdata');
frames = get_frames(handles);
zw = getParameter(handles,'Zoom Window');
thisFrame = frames{fn};
if fn > 1
    thisFramem1 = frames{fn-1};
end
hf = figure(10);clf;
selCols = @selectPixelsAndGetHSV_1;
types = {'hands','Fur','String','Ears','Hand-String'};
if ~isempty(intersect(type,[1 2 3 4]))
    try
%         set(hf,'WindowStyle','modal');
        if type == 2
%             thisFrame = imgaussfilt(thisFrame,5);
            colorVals = selCols(thisFrame,20,handles,types{type});
        end
        if type == 3 || type == 4
            if type == 4
                thisFrame = imsharpen(thisFrame,'Radius',10);%,'Amount',1,'Threshold',0.1);
            end
            colorVals = selCols(thisFrame,5,handles,types{type});
        end
        if type == 1
            colorVals = selCols(thisFrame,5,handles,types{type});
    %         colorVals = selectPixelsAndGetRGB(thisFrame,5,handles,type);
        end
        colorVals = unique(colorVals,'rows');
        typeParamName = {'Hands Color', 'Fur Color', 'String Color', 'Ear Color'};
        setParameter(handles,typeParamName{type},colorVals);
        handles.md.resultsMF.colors(1,type) = {colorVals};
        if ~isempty(findobj(hf))
            close(hf);
        end
    catch
        handles.md.resultsMF.colors(1,type) = {[]};
        if ~isempty(findobj(hf))
            close(hf);
        end
    end
end
if ~isempty(intersect(type,[101 102 103]))
    thisFrame = thisFrame - thisFramem1;
    try
%         set(hf,'WindowStyle','modal');
        if type == 101
            colorVals = selCols(thisFrame,5,handles,types{1});
        end
        if type == 102
            colorVals = selCols(thisFrame,5,handles,types{2});
        end
        if type == 103
            colorVals = selCols(thisFrame,5,handles,types{end});
    %         colorVals = selectPixelsAndGetRGB(thisFrame,5,handles,type);
        end
        colorVals = unique(colorVals,'rows');
        typeParamName = {'Hands Diff Color', 'String Diff Color', 'Hands-String Diff Color'};
        setParameter(handles,typeParamName{type-100},colorVals);
        handles.md.resultsMF.diffColors(1,type-100) = {colorVals};
        if ~isempty(findobj(hf))
            close(hf);
        end
    catch
        handles.md.resultsMF.diffColors(1,type-100) = {[]};
        if ~isempty(findobj(hf))
            close(hf);
        end
    end
end
checkStatusOfColors(handles);
