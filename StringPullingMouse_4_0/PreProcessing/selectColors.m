function selectColors(handles,object)
objectColor = sprintf('%s Color',object);
hsvMean = getParameter(handles,objectColor);
if isempty(hsvMean)
    allfns = getAllEpochFrameNums(handles);
    if isempty(allfns)
        return;
    end
    fns = allfns(randi([1 length(allfns)],1,20));
else
    [sfn,efn] = getFrameNums(handles);
    if sfn == efn
        fns = sfn;
    else
        fns = randi([sfn efn],1,20);
    end
end

frames = get_frames(handles);
colorVals = [];
for ii = 1:length(fns)
    fn = fns(ii);
    thisFrame = frames{fn};
%     if strcmp(object,'Nose') || strcmp(object,'Ears')
%         try
%             hb = get_head_box_from_msint(handles,fn,thisFrame,16);
%             zw = hb;
%         catch
%             try
%                 [bb(1),bb(2),bb(3),bb(4)] = get_body_box(handles,fn,thisFrame,[50 50],16);
%                 zw = bb;
%             catch
%                 zw = getParameter(handles,'Zoom Window');
%             end
%         end
%         thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
%     else
        try
            [bb(1),bb(2),bb(3),bb(4)] = get_body_box(handles,fn,thisFrame,[50 50],16);
        catch
            bb = getParameter(handles,'Zoom Window');
        end
        thisFrame = thisFrame(bb(2):bb(4),bb(1):bb(3),:);
%     end
    [colorVals,decision] = selectPixelsAndGetHSV_1(thisFrame,20,handles,object);
%     colorVals = [colorVals;temp];
%     uColorVals = unique(colorVals,'rows');
%     % uCV = findValsAroundMean(uColorVals(:,1:3),[3 100]);
%     setParameter(handles,objectColor,uColorVals);
    if strcmp(decision,'Exit')
        break;
    end
end
figure(10);close(gcf);
if isempty(colorVals)
    return;
end

% oColorVals = getParameter(handles,objectColor);
% if ~isempty(oColorVals)
%     opts.Interpreter = 'tex';opts.Default = 'Yes';
%     quest = 'Add to existing colors?';
%     answer = questdlg(quest,'Please select',...
%                       'Yes','No','Exit',opts);
%     if strcmp(answer,'Yes')
%         colorVals = [colorVals;oColorVals];
%     end
%     if strcmp(answer,'Exit')
%         return;
%     end
%     if isempty(answer)
%         return;
%     end
% end
% uColorVals = unique(colorVals,'rows');
% % uCV = findValsAroundMean(uColorVals(:,1:3),[3 100]);
% setParameter(handles,objectColor,uColorVals);
checkStatusOfColors(handles);
