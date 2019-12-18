function [xBox,XVals] = get_mouse_string_xBox(handles,fn,thisFrame,image_resize_factor,nbin,ow)


boxes = getParameter(handles,'Mouse String Boxes');
present = 0;
if ~isempty(boxes)
    indBox = boxes(:,1) == fn;
    if sum(indBox) > 0
        present = 1;
        if ~ow
            xBox = boxes(indBox,2:5);
            return;
        end
    end
end

cF = getColors(handles,'Fur',4:6,0);cS = getColors(handles,'String',4:6,0);cN = getColors(handles,'Nose',4:6,0);

hb = get_head_box(handles,fn,thisFrame,image_resize_factor,0);
thisFrame = thisFrame(hb(2):hb(4),hb(1):hb(3),:);
binsh = floor(size(thisFrame,2)/nbin(2)); binsv = floor(size(thisFrame,1)/nbin(1));Im = thisFrame(:,:,1);
fgb = find_feature_grid(handles,thisFrame,{cF,cS,cN},[1 size(Im,1)],[1 size(Im,2)],[binsv binsh],[0.1 0.1 0.1]);
gF = fgb.xs{1} | fgb.xs{3};
gS = fgb.xs{2};

gF_r = findRegions(gF,1);
if length(gF_r) > 1
    [~,gF_r,~] = combineRegions(gF_r,1:length(gF_r),size(gF),1);
end

gS_r = findRegions(gS,1);
if length(gS_r) > 1
    [~,gS_r,~] = combineRegions(gS_r,1:length(gS_r),size(gS),1);
end

if isempty(gF_r) || isempty(gS_r)
    error;
end

gF_r = findRegions(gF_r.cIn,1);
gS_r = findRegions(gS_r.cIn,1);

L1 = [gS_r.xb';gS_r.yb'];
L2 = [gF_r.xb';gF_r.yb'];

% figure(101);clf;imagesc(gF_r.cIn);axis equal;title(fn);hold on;plot(gF_r.xb,gF_r.yb,'r');plot(gS_r.xb,gS_r.yb,'r');

P = InterX(L1,L2);
ec = 1.1;
ni = 1;
while isempty(P)
    gFe = expandOrCompressMask(gF_r.cIn,ec);
    gF_r = findRegions(gFe,1);
    if length(gF_r) > 1
        [~,gF_r,~] = combineRegions(gF_r,1:length(gF_r),size(gF),1);
    end
    L2 = [gF_r.xb';gF_r.yb'];
    P = InterX(L1,L2);
    ec = ec + 0.1;
    ni = ni + 1;
    if ni > 10
        break;
    end
end

% figure(100);clf;imagesc(gF_r.cIn);axis equal;title(fn);hold on;plot(gF_r.xb,gF_r.yb,'r');plot(gS_r.xb,gS_r.yb,'r'); plot(P(1,1),P(2,1),'r*');

if numel(P) > 2
    [~,col] = min(P(2,:));
    P = P(:,col);
end

P = floor(P);
XVals = [(fgb.horiz(1,P(1))+ hb(1) - 1) (fgb.vert(1,P(2))+ hb(2) - 1)];
if P(1) > 1
    xBox(1) = fgb.horiz(1,P(1)-1);
else
    xBox(1) = fgb.horiz(1,P(1));
end
if P(2) > 1
    xBox(2) = fgb.vert(1,P(2)-1);
else
    xBox(2) = fgb.vert(1,P(2));
end
xBox(3) = fgb.horiz(2,P(1)+1);
xBox(4) = fgb.vert(2,P(2)+1);

if xBox(1) < 1
    xBox(1) = 1;
end

if xBox(2) < 1
    xBox(1) = 1;
end

xBox(1) = xBox(1) + hb(1) - 1;
xBox(2) = xBox(2) + hb(2) - 1;
xBox(3) = xBox(3) + hb(1) - 1;
xBox(4) = xBox(4) + hb(2) - 1;

if present
    boxes(indBox,:) = [fn xBox];
else
    boxes = [boxes;[fn xBox]];
end
setParameter(handles,'Mouse String Boxes',boxes);