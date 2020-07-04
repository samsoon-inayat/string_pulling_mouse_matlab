function s = combineRegionsAcrossString (handles,M,fn,s,thr)
string_thickness = getParameter(handles,'String Thickness in Pixels');
Is = get_mask(handles,fn,5);
if sum(Is(:)) == 0
    displayMessageBlinking(handles,'No string mask was found ... skipping combining of regions',{'FontSize',14},2);
    return;
end
combs = nchoosek(1:length(s),2);
frameSize = size(Is);
[dl,ol,bdl] = findDistsAndOverlaps(M,M.thisFrame,s,s);
for ii = 1:size(combs,1)
    ind1 = combs(ii,1); ind2 = combs(ii,2);
    D = bdl(ind1,ind2);
    if D > 1.5 * string_thickness%thr(1)
        continue;
    end
    [ts,cR,cMask] = combineRegions(s,combs(ii,:),frameSize);
    ir = cMask & Is;
    if sum(ir(:)) > 150
        if (cR.MajorAxisLength * M.scale) < thr
            s = ts;
            break;
        end
    end
end
