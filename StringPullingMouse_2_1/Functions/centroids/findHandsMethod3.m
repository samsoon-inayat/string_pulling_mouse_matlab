function C = findHandsMethod2(handles,M,fn,type,masks,thisFrame,Cs)
sLeft = getRegion(M,fn-1,'Left Hand');
sRight = getRegion(M,fn-1,'Right Hand');
masks.thisFrame = thisFrame;
Cm = Cs{1};
tF = zeros(size(thisFrame(:,:,1)));
[allxs,allys] = meshgrid(1:size(tF,2),1:size(tF,1));
In = inpolygon(allxs,allys,Cm.Ellipse_xs,Cm.Ellipse_ys);masks.In = In;
startingVal = 1;
cIn = expandOrCompressMask(In,startingVal);
masks.cIn = cIn;
% zw = handles.md.resultsMF.zoomWindow;
F1 = double(rgb2gray(thisFrame));
% zw1 = handles.md.resultsMF.zoomWindow;
% global gradients;
% thisGradient = reshape(gradients(:,fn),zw1(4)-zw1(2)+1,zw1(3)-zw1(1)+1);
% maskGradient = find_mask_threshold(thisGradient,2);
% maskG = imfill(maskGradient);
% maskG = bwareaopen(maskG,100);
% sg = findRegions(M,Cs,masks,F1,maskG);
% sbDhs = findRegions(M,Cs,masks,bDg,bDhs_mask);
[s sp] = findRegions(M,Cs,masks,F1,masks.Ih);
if strcmp(type,'')
    C = sp;
    return;
end
% if length(s) > 4
%     s = narrowDownRegions(s,sbDhs);
%     n = 0;
% end

% see if you can find which hand moved and how much it moved
if isempty(sRight)
    pf = 0;
    earsC = Cs{2};
    xrp = earsC(1).Centroid(1); yrp = earsC(1).Centroid(2);
    xlp = earsC(2).Centroid(1); ylp = earsC(2).Centroid(2);
else
    pf = 1;
    xrp = sRight.Centroid(1); yrp = sRight.Centroid(2);
    xlp = sLeft.Centroid(1); ylp = sLeft.Centroid(2);
end

bD_mask = masks.bd;
fD_mask = masks.fd;
% bDhs_mask = find_mask_1(handles,bD,'handString');
bDg = [];%double(rgb2gray(bD));
[sbD sbDo] = findRegions(M,Cs,masks,bDg,bD_mask);
[sfD sfDo] = findRegions(M,Cs,masks,bDg,fD_mask);

% [d_s_sB,o_s_sB] = findDistsAndOverlaps(M,thisFrame,s,sbD);
% [d_s_sF,o_s_sF] = findDistsAndOverlaps(M,thisFrame,s,sfD);
% [d_s_sR,o_s_sR] = findDistsAndOverlaps(M,thisFrame,s,sRight);
% [d_s_sL,o_s_sL] = findDistsAndOverlaps(M,thisFrame,s,sLeft);
% 
% [d_sB_sR,o_sB_sR] = findDistsAndOverlaps(M,thisFrame,sbD,sRight);
% [d_sB_sL,o_sB_sL] = findDistsAndOverlaps(M,thisFrame,sbD,sLeft);
% 
% [d_sF_sR,o_sF_sR] = findDistsAndOverlaps(M,thisFrame,sfD,sRight);
% [d_sF_sL,o_sF_sL] = findDistsAndOverlaps(M,thisFrame,sfD,sLeft);
% 

[d_sR_s,o_sR_s] = findDistsAndOverlaps(M,thisFrame,sRight,s);
[d_sL_s,o_sL_s] = findDistsAndOverlaps(M,thisFrame,sLeft,s);

doR = o_sR_s./d_sR_s;
doL = o_sL_s./d_sL_s;

plotStringAndRegions(3000,[],masks,M,{s,sRight,sLeft},[]);

% START detecting which hand has moved little or not moved

if any(doL) & ~any(doR)
    ind = find(doL);
    CL = s(ind);
    s(ind) = [];
end

if ~any(doL) & any(doR)
    ind = find(doR);
    CR = s(ind);
    s(ind) = [];
end

if any(doL) & any(doR)
    indR = find(doR == max(doR));
    indL = find(doL == max(doL));
    if indR == indL
        if length(s) == 1
            s = find_centroids_coincident(s(indR),[xrp yrp],[xlp ylp]);
            C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
            return;
        end
        if s(indR).Area > getParameter(handles,'Touching Hands Area')
            s = find_centroids_coincident(s(indR),[xrp yrp],[xlp ylp]);
            C = find_centroids_from_two(M,Cs,s,xrp,yrp,xlp,ylp);
            return;
        else
            if doL(indL) > doR(indR)
                CL = s(indL);
            end
            [d_s_sbD,o_s_sbD] = findDistsAndOverlaps(M,thisFrame,s,sbD);
            do = o_s_sbD./d_s_sbD;
            [rr,cc] = find(do==max(do(:)));
            CR = s(rr);
            if ~exist('CL','var')
                s(rr) = [];
                [d_sL_s,o_sL_s] = findDistsAndOverlaps(M,thisFrame,sLeft,s);
                doL = o_sL_s./d_sL_s;
                indL = find(doL == max(doL));
                CL = s(indL);
            end
            C(1) = CL;
            C(2) = CR;
            C(1).Hand = 'Left Hand';
            C(2).Hand = 'Right Hand';
            return;           
        end
    end
    CR = s(indR);
    CL = s(indL);
    C(1) = CL;
    C(2) = CR;
    C(1).Hand = 'Left Hand';
    C(2).Hand = 'Right Hand';
    return;
end

% END detecting which hand has moved little or not moved

% START find other hand if one hand has already been found

if exist('CL','var')
    if length(sbD) == 1
        [d_s_sbD,o_s_sbD] = findDistsAndOverlaps(M,thisFrame,s,sbD);
        doR = o_s_sbD./d_s_sbD;
        if any(doR)
            ind = find(doR == max(doR));
            temp = s(ind);
    %         % check if temp is the right one
    %         [d_sR_t,o_sR_t] = findDistsAndOverlaps(M,thisFrame,sRight,temp);
    %         [d_sR_sbD,o_sR_sbD] = findDistsAndOverlaps(M,thisFrame,sRight,sbD);
    %         ind = find(d_sR_s == min(d_sR_s));
            CR = s(ind);
        end
    else
        [d_s_sbD,o_s_sbD] = findDistsAndOverlaps(M,thisFrame,s,sbD);
        doR = o_s_sbD./d_s_sbD;
        [ind,cc] = find(doR == max(doR(:)));
        CR = s(ind);
    end
    if ~exist('CR','var')
        [d_sR_s,o_sR_s] = findDistsAndOverlaps(M,thisFrame,sRight,s);
        if ~any(o_sR_s)
            [~,ind] = min(d_sR_s);
            CR = s(ind);
        end
    end
    C(1) = CL;
    C(2) = CR;
    C(1).Hand = 'Left Hand';
    C(2).Hand = 'Right Hand';
    return;
end

if exist('CR','var')
    if length(sbD) == 1
        [d_s_sbD,o_s_sbD] = findDistsAndOverlaps(M,thisFrame,s,sbD);
        doR = o_s_sbD./d_s_sbD;
        ind = find(doR);
        CL = s(ind);
    else
        [d_s_sbD,o_s_sbD] = findDistsAndOverlaps(M,thisFrame,s,sbD);
        doR = o_s_sbD./d_s_sbD;
        [ind,cc] = find(doR == max(doR(:)));
        CL = s(ind);
    end
    C(1) = CL;
    C(2) = CR;
    C(1).Hand = 'Left Hand';
    C(2).Hand = 'Right Hand';
    return;
end

% END find other hand if one hand has already 50been found


% if coincident

% if one hand moved and later became coincident

% if one hand moved and later both hands are separate



% if both hands moved and are coincident

% if both hands moved and later are separate

n = 0;
return;
