function changePosition(hc,upos)

pos = get(hc,'Position');
pos = pos + upos;
set(hc,'Position',pos);