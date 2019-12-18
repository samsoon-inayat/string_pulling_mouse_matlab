
function dispFigureWindowKeyPressFcn(event,handles)
uda = get(gcf,'userdata');
if strcmp(event.Key,'control')
    uda(1) = 1;
    set(gcf,'userdata',uda);
end
if strcmp(event.Key,'alt')
    uda(1) = 2;
    set(gcf,'userdata',uda);
end
if strcmp(event.Key,'shift')
    uda(1) = 3;
    set(gcf,'userdata',uda);
end
if strcmp(event.Key,'delete')
    uda(1) = 3;
    set(gcf,'userdata',uda);
end
