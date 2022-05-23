function c = gradient_all_noend (varargin)
% GRADIENT_ALL_NOEND Column-wise gradient with disabled end-points (where it's inaccurate).
% See also: gradient_noend

    [c, dim] = gradient_all (varargin{:});
    switch dim
    case 1
        c(1,:) = NaN;
        c(end,:) = NaN;
    case 2
        c(:,1) = NaN;
        c(:,end) = NaN;
    otherwise
        error('gradient_all_noend:badDim', ...
            'Higher-dimension input not supported.');
    end
end

%!test
%! gradient_all_noend((1:10)')
%! gradient_all_noend(repmat((1:10)', [1 3]))

