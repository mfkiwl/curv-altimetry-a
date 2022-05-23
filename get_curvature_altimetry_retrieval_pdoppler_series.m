function H = get_curvature_altimetry_retrieval_pdoppler_series (e, Ha, type, varargin)
% GET_CURVATURE_ALTIMETRY_PDOPPLER_SERIES Altimetry retrieval based on pseudo-Doppler formulation (note: meant for 
% a series of elevation angles at a fixed antenna height).
% 
% INPUT:
% - e: elevation angles (vector or matrix, in degrees)
% - Ha: antenna height (scalar or vector, in meters)
% - type: (char) type of altimetry method for the Earth's curvature
%           'A': type-A method for crossed pseudo-Doppler altimetry
%           'B': type-B method for spherical pseudo-Doppler altimetry
% - varargin: optional input, see get_reflection_spherical for details.
%
% Note: antenna height is assumed constant for each series of elevation angles, so:
% - if e is a vector, Ha shall be a scalar.
% - if e is matrix, Ha shall be a vector, with numel(Ha)==size(e,2).
% 
% OUTPUT:
% - dH: altimetry retrieval (vector or matrix, in meters)
% 
% Examples:
% - scalar Ha:
% e = 1:10;  Ha = 10;  H = get_curvature_altimetry_retrieval_pdoppler_series (e, Ha)
% - vector Ha:
% e = 1:10;  Ha = 1:10;  H = get_curvature_altimetry_retrieval_pdoppler_series (e, Ha)

    if (nargin <3) || isempty(type),  type = 'A';  end

    [e, Ha, siz] = get_curvature_altimetry_series_prep (e, Ha);

    [Di_s, g] = get_reflection_spherical (e, Ha, varargin{:});

    switch lower(type)
    case {'a','typea'},  a = e;
    case {'b','typeb'},  a = g;
    end
    Kz = get_vertical_sensitivity (a);

    H = gradient_all_noend(Di_s, Kz);

    H = reshape(H, siz);
end

