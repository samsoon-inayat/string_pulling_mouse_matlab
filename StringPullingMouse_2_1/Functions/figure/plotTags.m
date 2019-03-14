function out = plotTags(handles,ha,fn,tag)
axes(ha);hold on;
R = handles.md.resultsMF.R;
if isempty(R)
    return;
end
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

% objects are 1 body 2 ears 3 hands --> corresponding tags are 7,8 for
% body, 2,3 for ears, 4 and 5 for hands
objectToProcess = get(handles.uibuttongroup_objectToProcess,'userdata');

if get(handles.checkbox_displayAreas,'Value')
    da = 1;
    P = handles.md.resultsMF.P;
else
    da = 0;
end



for ii = 1:length(inds)
    iii = inds(ii);
    if R(iii,2)~=8 && R(iii,2)~=7
%         plot(R(iii,3),R(iii,4),'.r');
        if R(iii,2) == 2
            if da & objectToProcess == 2
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frameSize,boundaryPixels);
                plot(cc,rr,'r','linewidth',1);
            else
                plot(R(iii,3),R(iii,4),'*m','MarkerSize',7);
            end
%             text(R(iii,3)+50,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
        if R(iii,2) == 3
            if da & objectToProcess == 2
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frameSize,boundaryPixels);
                plot(cc,rr,'b','linewidth',1);
            else
                plot(R(iii,3),R(iii,4),'*c','MarkerSize',7);
            end
%             text(R(iii,3)-80,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
        if R(iii,2) == 4
            if da & objectToProcess == 3
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frameSize,boundaryPixels);
                plot(cc,rr,'r','linewidth',1);
            else
                plot(R(iii,3),R(iii,4),'.m','MarkerSize',10);
            end
%             text(R(iii,3)+50,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
        if R(iii,2) == 5
            if da & objectToProcess == 3
                Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
                boundaryPixels = P(Lia,3);
                [rr,cc] = ind2sub(handles.md.frameSize,boundaryPixels);
                plot(cc,rr,'b','linewidth',1);
            else
                plot(R(iii,3),R(iii,4),'.c','MarkerSize',10);
            end
%             text(R(iii,3)-80,R(iii,4)-10,handles.md.tag_labels{R(iii,2)},'FontSize',7,'Color','w');
        end
    end
    if R(iii,2)==8
        jj = find(R(inds,2) == 7);
        C = getSubjectFit(R(inds(jj),[3 4]),R(iii,3),R(iii,4),R(iii,5));
%             plot(C.Centroid(1),C.Centroid(2),'*g','MarkerSize',5);
        plot(C.Major_axis_xs,C.Major_axis_ys,'g');
        plot(C.Minor_axis_xs,C.Minor_axis_ys,'g');
        plot(C.Ellipse_xs,C.Ellipse_ys,'g');
    end
    if R(iii,2)==1
        if da & objectToProcess == 4
            Lia = ismember(P(:,[1 2]),[fn R(iii,2)],'rows');
            boundaryPixels = P(Lia,3);
            [rr,cc] = ind2sub(handles.md.frameSize,boundaryPixels);
            plot(cc,rr,'y','linewidth',1);
        else
            plot(R(iii,3),R(iii,4),'*y','MarkerSize',7);
        end
    end
end
out = R(inds,:);
