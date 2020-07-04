function ff = makeFigureRowsCols (figNum,figPos,varargin)

p = inputParser;
addRequired(p,'figNum',@isnumeric);
addRequired(p,'figPos',@isnumeric);
addOptional(p,'RowsCols',[1 1],@isnumeric);
addOptional(p,'spaceRowsCols',[0 0],@isnumeric);
addOptional(p,'rightUpShifts',[0 0],@isnumeric);
addOptional(p,'widthHeightAdjustment',[0 0],@isnumeric);
parse(p,figNum,figPos,varargin{:});

magFac = 1;
ff.hf = figure(figNum);clf;
set(ff.hf,'Units','inches');
if isnan(figPos(1))
    tempPos = get(ff.hf,'Position');
    figPos(1) = tempPos(1);
    figPos(2) = tempPos(2);
end
figPos(3) = magFac*figPos(3); figPos(4) = magFac*figPos(4);
set(ff.hf,'Units','inches','Position',figPos,'MenuBar','none','ToolBar','none',...
    'NumberTitle','on','Color','w','Resize','on',...
    'NextPlot','add');

nRows = p.Results.RowsCols(1);
nCols = p.Results.RowsCols(2);
sprc = p.Results.spaceRowsCols; whUnits = p.Results.widthHeightAdjustment; rtup = p.Results.rightUpShifts;
[pL pB pW pH] = getPanelPropsThis(nRows,nCols,sprc,whUnits,rtup);
for rr = 1:nRows
    for cc = 1:nCols
        ff.axesPos{rr,cc} = [pL(cc) pB(rr) pW pH];
        ff.h_axes(rr,cc) = axes('Position',ff.axesPos{rr,cc});
    end
end
n = 0;

function [panelLefts panelBottoms panelWidth, panelHeight] = getPanelPropsThis(nRows,nCols,sprc,whUnits,rtup)
fineSp = 0.001;
spaceBetweenRows = sprc(1);
spaceBetweenColumns = sprc(2);
panelWidth = 1/nCols + whUnits(1) * fineSp;
panelHeight = 1/nRows + whUnits(2) * fineSp;
panelLefts(1) = rtup(1); % shift right for all columns
for ii = 2:nCols
    panelLefts(ii) = panelLefts(ii-1) + panelWidth + spaceBetweenColumns;
end
panelBottoms(1) = rtup(2); % shift up for all rows
for ii = 2:nRows
    panelBottoms(ii) = panelBottoms(ii-1) + panelHeight + spaceBetweenRows;
end
panelBottoms = fliplr(panelBottoms);


% function paPosition = adjustPositionThis(paPosition,adjustment)
% paPosition(1) = paPosition(1) + adjustment(1) * fineSp;
% paPosition(2) = paPosition(2) + adjustment(2) * fineSp;
% paPosition(3) = paPosition(3) + adjustment(3) * fineSp;
% paPosition(4) = paPosition(4) + adjustment(4) * fineSp;

