function dHz = get_curvature_altimetry_correction_pdoppler_zenith (Ha, type, e_tol, num_steps, poly_deg)
    if (nargin < 2),  type = '';  end
    if (nargin < 3) || isempty(e_max),  e_tol = 10;  end
    if (nargin < 4) || isempty(num_steps),  num_steps = 10;  end
    if (nargin < 4) || isempty(poly_deg),  poly_deg = 2;  end

    assert(isvector(Ha)) % || isscalar(Ha)
    siz = size(Ha);
    Ha = rowvec(Ha);
    n = prod(siz);  % = numel(Ha);

    % get domain of elevation angles:
    e_dom = linspace(90-e_tol, 90, num_steps)';

    % get series of altimetry corrections:
    dH_dom = get_curvature_altimetry_correction_pdoppler_series (e_dom, Ha, type);

    dHz = NaN(siz);
    for j=1:n
        % fit a low-order polynomial then evaluate it at zenith:
        dHz(j) = nanpolyfitval(e_dom, dH_dom(:,j), poly_deg, 90);
    end
end

