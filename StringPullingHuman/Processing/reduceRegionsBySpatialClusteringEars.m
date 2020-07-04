function s_r1 = reduceRegionsBySpatialClusteringEars(M,s_r1,varargin)

while 1
    if strcmp(get(M.pushbutton_stop_processing,'visible'),'off')
        axes(M.axes_main);cla;
        s_r1 = [];
        break;
    end
    psL = length(s_r1);
    if psL == 1
        break;
    end
    if nargin == 3
        s_r1 = spatialClusteringEars(s_r1,size(M.thisFrame(:,:,1)),psL-1,M,1);
    else
        s_r1 = spatialClusteringEars(s_r1,size(M.thisFrame(:,:,1)),psL-1,M);
    end
    plotStringAndRegions(100,[],[],M,{s_r1},[]);
    title(M.fn);
    pause(0.15);
    if psL == length(s_r1)% | length(s_r1) == 2
        break;
    end
end