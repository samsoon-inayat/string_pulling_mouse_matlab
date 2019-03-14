function out = checkStatusOfSteps(handles)
out = 1;
oc = checkStatusOfColors(handles);

if sum(oc) < 5
    displayMessageBlinking(handles,'Please select all colors ... complete step 3',{'ForegroundColor','r','FontSize',12},3);
    out = 0;
end

zw = getParameter(handles,'Auto Zoom Window');

if isempty(zw)
    displayMessageBlinking(handles,'No Zoom Window for Masks ... complete step 4',{'ForegroundColor','r','FontSize',12},3);
    out = 0;
end

