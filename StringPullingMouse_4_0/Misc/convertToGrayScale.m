function fng = convertToGrayScale(handles,fn,ic)


if ~exist('ic','var')
    try
        mouse_color = getParameter(handles,'Mouse Color');
    catch
        mouse_color = 'White';
    end
    if strcmp(mouse_color,'Black')
        ic = 1;
    else
        ic = 0;
    end
end

nrows = size(fn{1},1);
ncols = size(fn{1},2);
nFrames = length(fn);

fng = zeros(nrows,ncols,nFrames);

% for ii = 1:length(fn)
%     fng(:,:,ii) = double(rgb2gray(fn{ii}));
% end

for ii = 1:length(fn)
    if ~ic
        fng(:,:,ii) = double(rgb2gray(fn{ii}));
    else
        fng(:,:,ii) = double(rgb2gray(imcomplement(fn{ii})));
    end
end