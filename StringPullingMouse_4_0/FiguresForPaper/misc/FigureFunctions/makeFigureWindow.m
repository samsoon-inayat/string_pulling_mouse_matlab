function hf = makeFigureWindow (figNum,figPos,magFac)

% p = inputParser;
% default_maxY = max(means)+max(sems);
% default_colors = distinguishable_colors(20);
% default_ySpacingFactor = 10;
% addRequired(p,'means',@isnumeric);
% addRequired(p,'sems',@isnumeric);
% addRequired(p,'combs',@isnumeric);
% addRequired(p,'sig',@isnumeric);
% addOptional(p,'maxY',default_maxY,@isnumeric);
% addOptional(p,'colors',default_colors,@iscell);
% addOptional(p,'ySpacingFactor',default_ySpacingFactor,@isnumeric);
% parse(p,means,sems,combs,sig,varargin{:});
% 
% cols = p.Results.colors;
% myy = p.Results.maxY;
% maxY = default_maxY;
% ySpacingFactor = p.Results.ySpacingFactor;


magFac = 1;
hf = figure(figNum);clf; figPos(3) = magFac*figPos(3); figPos(4) = magFac*figPos(4);
set(hf,'Units','inches','Position',figPos,'MenuBar','none','ToolBar','none',...
    'NumberTitle','on','Color','w','Resize','off',...
    'NextPlot','add');
