function findBody_ML(handles,sfn,efn)

detector = vision.CascadeObjectDetector('furDetector.xml');
global frames;
zw = getParameter(handles,'Zoom Window');
frameNums = sfn:efn;
RE = handles.md.resultsMF.RE;
for ii = 1:length(frameNums)
    tic;
    fn = frameNums(ii);
    thisFrame = frames{fn};
    thisFrame = thisFrame(zw(2):zw(4),zw(1):zw(3),:);
    thisRE = RE(fn,2:end);
    C = getSubjectFit([thisRE(1)-zw(1) thisRE(2)-zw(2)],thisRE(3),thisRE(4),thisRE(5));
    bbox = [min(C.Ellipse_xs) min(C.Ellipse_ys) max(C.Ellipse_xs)-min(C.Ellipse_xs) max(C.Ellipse_ys)-min(C.Ellipse_ys)];
    bbox_ML = step(detector,thisFrame);
    detectedImg = insertObjectAnnotation(thisFrame,'rectangle',bbox_ML,'Fur');
%     detectedImg = insertObjectAnnotation(thisFrame,'rectangle',bbox,'Fur');
    figure(100);clf;imshow(detectedImg);
    pause(0.1);
    n = 0;
%     displayMessage(handles,sprintf('Finding %s fit ... Processing frame %d - %d/%d ... time remaining %s','body',fn,ii,length(frameNums),getTimeRemaining(length(frameNums),ii)));
end
% displayMessage(handles,sprintf('Done processing frames %d to %d',sfn,efn));
