function ff = makeFigureWindow__one_axes_only (figNum,figPos,axesPos)
magFac = 1;
hf = figure(figNum);clf; figPos(3) = magFac*figPos(3); figPos(4) = magFac*figPos(4);
set(hf,'Units','inches','Position',figPos,'MenuBar','none','ToolBar','none',...
    'NumberTitle','on','Color','w','Resize','off',...
    'NextPlot','add');


ff.numberOfRows = 1; % specify how many rows do you want in the figure
ff.spaceBetweenRows = [0.05]; % specify based on number of rows what would be the spacing between rows
ff.rowHeights = axesPos(4); % specify row heights ... should have the same number as number of rows

ff.numberOfCols = [1]; % for each row specify the number of columns
ff.colWidths = {axesPos(3)}; % for each row specify the column widths
ff.spaceBetweenCols = {[0.001]}; % specify space between columns

ff.leftOffset = axesPos(1); % how much the whole figure is offset to left from figure's left border
ff.bottomOffset = axesPos(2); % how much the whole figure is offset upwards from the bottom border of the figure

ff = getPanelsProps(ff); % will give a structure output which has all the lefts and bottoms of panels

ff.hf = makeFigureWindow(figNum,figPos,1);

ff = makeAxes(ff.hf,ff,1,1,[0 0 0 0]); % for generating axes
ff.pos = axesPos;

% 
% 
% ff.numberOfRows = 1; % specify how many rows do you want in the figure
% ff.spaceBetweenRows = [0.05]; % specify based on number of rows what would be the spacing between rows
% ff.rowHeights = [0.80]; % specify row heights ... should have the same number as number of rows
% 
% ff.numberOfCols = [1]; % for each row specify the number of columns
% ff.colWidths = {[0.75]}; % for each row specify the column widths
% ff.spaceBetweenCols = {[0.001]}; % specify space between columns
% 
% ff.leftOffset = 0.2; % how much the whole figure is offset to left from figure's left border
% ff.bottomOffset = 0.15; % how much the whole figure is offset upwards from the bottom border of the figure
% 
% ff = getPanelsProps(ff); % will give a structure output which has all the lefts and bottoms of panels
% 
% figNum = 1; figPosition = [1 5 1.8 2];
% 
% ff.hf = makeFigureWindow(figNum,figPosition,1);
% 
% % ff = makeAxes(ff.hf,ff,1,1,[0 0 0 0]); % for generating axes
% 
