%GRADIENT_NOEND Gradient with disabled end-points (where it's inaccurate).
function c = gradient_noend (varargin)
    c = gradient (varargin{:});
    c(1) = NaN;
    c(end) = NaN;
end

% gradient_noend = @(varargin) setel(setel(gradient(varargin{:}), 1,NaN), 'end',NaN);

