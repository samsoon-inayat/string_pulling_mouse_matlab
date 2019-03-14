function [fn,fp] = getFileInfo
fileName = 'recentFiles.mat';
if ~exist(fileName)
    [fn,fp,~] = uigetfile;%('*.*');
    if ~ischar(fn)
        return;
    end
    fls.fns{1} = fn;
    fls.fps{1} = fp;
    fls.fnswp{1} = [fp fn];
    save(fileName,'-struct','fls');
    return;
end
fls = load(fileName);
ind = generalGUIForSelection(['Load new file';fls.fnswp'],1);
if ind == 0
    fn = 0;fp = 0;
    return;
end
if ind == 1
    [fn,fp,~] = uigetfile('*.*');
    if ~ischar(fn)
        return;
    end
    fnswp = [fp fn];
    IndexC = strfind(fls.fnswp,fnswp)
    Index = find(not(cellfun('isempty', IndexC)));
    if ~isempty(Index)
        return;
    end
    ind = length(fls.fns)+1;
    if ind > 10
        fls.fns(1) = [];
        fls.fps(1) = [];
        fls.fnswp(1) = [];
        ind = 10;
    end
    fls.fns{ind} = fn;
    fls.fps{ind} = fp;
    fls.fnswp{ind} = [fp fn];
    save(fileName,'-struct','fls');
    return;
end

ind = ind-1;
fn = fls.fns{ind};
fp = fls.fps{ind};
