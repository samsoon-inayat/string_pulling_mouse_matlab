function uv = runCLG(handles,frameSeq)

alpha = 0.012;
ratio = 0.75;
minWidth = 50;
nOuterFPIterations = 7;
nInnerFPIterations = 1;
nSORIterations = 30;
para = [alpha,ratio,minWidth,nOuterFPIterations,nInnerFPIterations,nSORIterations];

for ii = 2:size(frameSeq,3)
    if strcmp(get(handles.pushbutton_stop_processing,'visible'),'off')
        axes(handles.axes_main);cla;set(handles.axes_main,'visible','off');
        uv = [];
        return;
    end
    frame1 = frameSeq(:,:,ii-1);
    frame2 = frameSeq(:,:,ii);
    [vx,vy,~] = Coarse2FineTwoFrames(frame1,frame2,para);
    uv(:,:,ii) = vx + i*vy;
    displayMessage(handles,sprintf('Estimating motion ... processing frame %d/%d',ii,size(frameSeq,3)));
end
