function figure_hands_NN(handles)

if ~exist('handles','var')
    fh = findall(0, 'Type', 'Figure', 'Name', 'String Pulling Behavior Analytics');
    handles = guidata(fh);
    handles.md = get_meta_data(handles);
end

sfn = 219;
efn = 222;

out = get_all_params(handles,sfn,efn,10);
outDLC = get_all_params_DLC(handles,sfn,efn,10);

frames = get_frames(handles);

fns = sfn:efn;
M = populateM(handles,[],[]);

ff = makeFigureRowsCols(101,[7 5.5 6.9 2],'RowsCols',[1 6],...
    'spaceRowsCols',[0.03 0.0225],'rightUpShifts',[0.02 0.03],'widthHeightAdjustment',...
    [-25 -40]);
gg = 1;
set(gcf,'color','w');

mSize = 5;
mSizep = 2;
for ii = 1:length(fns)
    fn = fns(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(M.zw(2):M.zw(4),M.zw(1):M.zw(3),:);
    axes(ff.h_axes(1,ii));
    imagesc(thisFrame);
    axis equal;
    axis off;
    hold on;
    % right hand
    xc = out.right_hand.centroid(fn,1)-M.zw(1);
    yc = out.right_hand.centroid(fn,2)-M.zw(2);
    plot(xc,yc,'.c','markersize',mSize);
    xcd = outDLC.right_hand.centroid(fn,1)-M.zw(1);
    ycd = outDLC.right_hand.centroid(fn,2)-M.zw(2);
    plot(xcd,ycd,'+c','markersize',mSizep);
    plot([xc xcd],[yc ycd],'w','linewidth',0.5);
    
    % Left hand
    xc = out.left_hand.centroid(fn,1)-M.zw(1);
    yc = out.left_hand.centroid(fn,2)-M.zw(2);
    plot(xc,yc,'.m','markersize',mSize);
    xcd = outDLC.left_hand.centroid(fn,1)-M.zw(1);
    ycd = outDLC.left_hand.centroid(fn,2)-M.zw(2);
    plot(xcd,ycd,'+m','markersize',mSizep);
    plot([xc xcd],[yc ycd],'w','linewidth',0.5);

    % right ear
    xc = out.right_ear.centroid(fn,1)-M.zw(1);
    yc = out.right_ear.centroid(fn,2)-M.zw(2);
    plot(xc,yc,'.c','markersize',mSize);
    xcd = outDLC.right_ear.centroid(fn,1)-M.zw(1);
    ycd = outDLC.right_ear.centroid(fn,2)-M.zw(2);
    plot(xcd,ycd,'+c','markersize',mSizep);
    plot([xc xcd],[yc ycd],'w','linewidth',0.5);
    
    % Left ear
    xc = out.left_ear.centroid(fn,1)-M.zw(1);
    yc = out.left_ear.centroid(fn,2)-M.zw(2);
    plot(xc,yc,'.m','markersize',mSize);
    xcd = outDLC.left_ear.centroid(fn,1)-M.zw(1);
    ycd = outDLC.left_ear.centroid(fn,2)-M.zw(2);
    plot(xcd,ycd,'+m','markersize',mSizep);
    plot([xc xcd],[yc ycd],'w','linewidth',0.5);
    
    % Nose
    xc = out.nose.centroid(fn,1)-M.zw(1);
    yc = out.nose.centroid(fn,2)-M.zw(2);
    plot(xc,yc,'.y','markersize',mSize);
    xcd = outDLC.nose.centroid(fn,1)-M.zw(1);
    ycd = outDLC.nose.centroid(fn,2)-M.zw(2);
    plot(xcd,ycd,'+y','markersize',mSizep);
    plot([xc xcd],[yc ycd],'w','linewidth',0.5);
    
end

delete(ff.h_axes(1,5));
delete(ff.h_axes(1,6));
pdfFileName = sprintf('%s_1.pdf',mfilename);
pdfFileName = [pwd '\FiguresForPaper\pdfs\' pdfFileName]
save2pdf(pdfFileName,gcf,600);
