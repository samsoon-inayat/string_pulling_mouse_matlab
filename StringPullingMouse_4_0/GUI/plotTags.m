function out = plotTags(handles,ha,fn,tag)
dispProps = get(handles.pushbutton_select_annotation_colors,'userdata');
dispTags_body = get(handles.checkbox_tags_body,'Value');
dispTags_ears = get(handles.checkbox_tags_ears,'Value');
dispTags_hands = get(handles.checkbox_tags_hands,'Value');
dispTags_nose = get(handles.checkbox_tags_nose,'Value');

[globalR,globalP,globalRDLCS] = get_R_P_RDLC(handles);
handles.md = get_meta_data(handles);
% axes(ha);hold on;
hold(ha,'on');
if get(handles.checkbox_display_DLC_results,'Value')
    dlc = 1;
    R = globalRDLCS;
else
    dlc = 0;
    R = globalR;%handles.md.resultsMF.R;
end
if isempty(R)
    return;
end
zw = getParameter(handles,'Zoom Window');
if isempty(zw)
    md = get_meta_data(handles);
    zw = [1 1 md.frame_size(2) md.frame_size(1)];
%     setParameter(handles,'Zoom Window',[1 1 md.frame_size(2) md.frame_size(1)]);
end
tdx = zw(3)-300;
tdy = zw(2)+50;
objects = {'B','E','N','H'};
indsO = [3 2 2 4 4 NaN 1];
mobj = [];

if exist('tag','var')
    if tag ~=8
        Lia = ismember(R(:,[1 2]),[fn tag],'rows');
        inds = find(Lia);
    else
        Lia7 = ismember(R(:,[1 2]),[fn 7],'rows');
        Lia8 = ismember(R(:,[1 2]),[fn 8],'rows');
        inds = find(Lia7|Lia8);
    end
else
    inds = find(R(:,1) == fn);
end
mSize = 12;
mSizeN = 12;

% objects are 1 body 2 ears 3 hands --> corresponding tags are 7,8 for
% body, 2,3 for ears, 4 and 5 for hands
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');

if get(handles.checkbox_displayAreas,'Value')
    da = 1;
    P = globalP;
else
    da = 0;
end
xlims = xlim(ha);
ylims = ylim(ha);

if dlc == 1
    P = [-1 -1 -1];
end

for ii = 1:length(inds)
    iii = inds(ii);
    if R(iii,2)~=8 && R(iii,2)~=7
%         plot(R(iii,3),R(iii,4),'.r');
        if R(iii,2) == 2 && dispTags_ears
            if da & objectToProcess == 2
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frame_size,boundaryPixels);
                plot(ha,cc,rr,dispProps.leftEar_line_color,'linewidth',1);
            else
                plot(ha,R(iii,3),R(iii,4),...
                    sprintf('.%s',dispProps.leftEar_dot_color),'MarkerSize',mSize);
            end
%             text(R(iii,3)+50,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
        if R(iii,2) == 3 && dispTags_ears
            if da & objectToProcess == 2
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frame_size,boundaryPixels);
                plot(ha,cc,rr,dispProps.rightEar_line_color,'linewidth',1);
            else
                plot(ha,R(iii,3),R(iii,4),...
                    sprintf('.%s',dispProps.rightEar_dot_color),'MarkerSize',mSize);
            end
%             text(R(iii,3)-80,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
        if R(iii,2) == 4 && dispTags_hands
            if da & objectToProcess == 3
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frame_size,boundaryPixels);
                plot(ha,cc,rr,dispProps.leftHand_line_color,'linewidth',1);
            else
                plot(ha,R(iii,3),R(iii,4),...
                    sprintf('.%s',dispProps.leftHand_dot_color),'MarkerSize',mSize);
            end
%             text(R(iii,3)+50,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
        if R(iii,2) == 5 && dispTags_hands
            if da & objectToProcess == 3
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frame_size,boundaryPixels);
                plot(ha,cc,rr,dispProps.rightHand_line_color,'linewidth',1);
            else
                plot(ha,R(iii,3),R(iii,4),...
                    sprintf('.%s',dispProps.rightHand_dot_color),'MarkerSize',mSize);
            end
%             text(R(iii,3)-80,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
    end
    if R(iii,2)==8 && dispTags_body
        jj = find(R(inds,2) == 7);
        C = getSubjectFit(R(inds(jj),[3 4]),R(iii,3),R(iii,4),R(iii,5));
%             plot(C.Centroid(1),C.Centroid(2),'*g','MarkerSize',5);
        plot(ha,C.Major_axis_xs,C.Major_axis_ys,dispProps.bodyEllipse_color);
        plot(ha,C.Minor_axis_xs,C.Minor_axis_ys,dispProps.bodyEllipse_color);
        plot(ha,C.Ellipse_xs,C.Ellipse_ys,dispProps.bodyEllipse_color);
    end
    if R(iii,2)==1 && dispTags_nose
        if da & objectToProcess == 4
            Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
            boundaryPixels = P(Lia,3);
            [rr,cc] = ind2sub(handles.md.frame_size,boundaryPixels);
            plot(ha,cc,rr,dispProps.nose_line_color,'linewidth',1);
        else
            plot(ha,R(iii,3),R(iii,4),...
                sprintf('.%s',dispProps.nose_dot_color),'MarkerSize',mSizeN);
        end
    end
    if dlc
        text(ha,tdx,tdy+200,sprintf('%.2f',R(iii,5)),'fontsize',8,'Color','w','fontweight','Bold');
    else
        if R(iii,5) == 1
            ind = indsO(R(iii,2));
            if isempty(strfind(mobj,objects{ind})) || isempty(mobj)
                mobj = [mobj objects{ind}];
            end
        end
    end
end
if ~isfield(dispProps,'manual_detection_identifier')
    dispProps.manual_detection_identifier = 'w';
    set(handles.pushbutton_select_annotation_colors,'userdata',dispProps);
    md = get_meta_data(handles);
    fileName = fullfile(md.processed_data_folder,'dispProps.mat');
    save(fileName,'-struct','dispProps');
end
text(ha,tdx,tdy,sprintf('%s',sort(mobj)),'fontsize',8,'Color',dispProps.manual_detection_identifier,'fontweight','Bold');
out = R(inds,:);
