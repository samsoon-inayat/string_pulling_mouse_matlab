function [md,sem,varargout] = findMeanAndStandardError (data,varargin)

if isvector(data)
    md = nanmean(data);
    sem = nanstd(data)/sqrt(length(data));
    if nargout > 2
        varargout{1} = nanstd(data)
    end
    return;
end


if nargin > 1
    dim = varargin{1};
    if dim>2
        error;
    end
else
    dim = 1;
end

md = nanmean(data,dim);
sem = nanstd(data,0,dim)./sqrt(size(data,dim));

if nargout > 2
    varargout{1} = nanstd(data,0,dim)
end