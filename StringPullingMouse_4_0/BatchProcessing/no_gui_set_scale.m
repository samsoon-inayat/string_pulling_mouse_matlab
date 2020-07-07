function no_gui_set_scale(handles)
[sfn,efn] = getFrameNums(handles);
fn = sfn;%round(get(handles.slider1,'Value'));
frames = get_frames(handles);
hf = figure(10);
set(hf,'WindowStyle','modal');
imshow(frames{fn});
axis equal; axis off;
tdx = 20;
tdy = 20;
text(tdx,tdy,sprintf('Draw a line on an object of known dimension (by clicking and dragging)'));
hline = imline(gca);
set(hf,'WindowStyle','normal');
if isempty(hline)
%     displayFrames(handles,fn);
    return;
end
pos = round(hline.getPosition);
close(hf);
prompt = 'Enter length with units';
title = 'Input Length';
dims = 1;
answer = inputdlg(prompt,title,dims,{'230 mm'});
% left = pos(1,1);
% right = pos(2,1);
diffP = diff(pos,1,1);
% numPixels = right - left;
numPixels = sqrt(sum(diffP.^2));
mm = sscanf(answer{1},'%f');
setParameter(handles,'Scale',mm/numPixels);
% set(handles.text_scale,'String',{'Scale',sprintf('%.3f',getParameter(handles,'Scale')),'mm/pixels'});
% displayFrames(handles,fn);
% set(handles.figure1,'userdata',fn);