function [e, Ha, siz] = get_curvature_altimetry_series_prep (e, Ha)
    if isscalar(e)
        error('matlab:curvAltSeries:badInpElev', 'Input "e" shall not be scalar.');
    end

    siz = size(e);
    if isvector(e)
        e = colvec(e);  % necessary for gradient_all.
    end

    if isscalar(Ha)
        return;
    end
    
    if isvector(Ha)
        Ha = rowvec(Ha);
    end

    if isvector(e)
        e = repmat(e, [1 size(Ha,2)]);
    end
    if isvector(Ha)
        Ha = repmat(Ha, [size(e,1) 1]);
    elseif ~isequaln(Ha, repmat(Ha(1,:), [size(Ha,1) 1]))
        error('matlab:curvAltSeries:badInpHeight', ...
            'Input "Ha", when it is matrix, should have uniform columns.');
    end
    siz = size(e);
    assert(isequaln(size(Ha), siz))
end

