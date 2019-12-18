function saveFigAsPDF(hf,fileName,openFile)
%SAVEFIGASPDF Summary of this function goes here
%   Detailed explanation goes here
set(hf, 'PaperPositionMode', 'Auto', 'PaperOrientation','portrait');
eval(sprintf('print -painters -dpdf -r600 ''%s''',fileName));

if openFile
    winopen(fileName);
end

