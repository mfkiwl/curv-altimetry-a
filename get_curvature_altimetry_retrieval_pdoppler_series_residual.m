function rH = get_curvature_altimetry_retrieval_pdoppler_series_residual (e, Ha, DH, type, varargin)
% GET_CURVATURE_ALTIMETRY_RETRIEVAL_PDOPPLER_SERIES_RESIDUAL: Residual
% altimetry retrieval for the Earth's curvature effect and pseudo-Doppler
% formulation (note: meant for a series of elevation angles at a fixed
% antenna height).
% 
% INPUT:
% - e: elevation angles (vector or matrix, in degrees)
% - Ha: antenna height (scalar or vector, in meters)
% - DH: deviation antenna height (scalar or vector, in meters)
% - type: (char) type of altimetry correction for the Earth's curvature
%           'A': type-A correction for crossed pseudo-Doppler altimetry
%           'B': type-B correction for spherical pseudo-Doppler altimetry
% - varargin: optional input, see get_reflection_spherical for details.
% 
% OUTPUT:
% - rH: residual altimetry retrieval (vector or matrix, in meters)

    if (nargin < 4) || isempty(type), type = 'b';  end
    assert(isvector(e))
    assert(isscalar(Ha))

    H0 = Ha + DH;  % nominal antenna height    
    [Di0, g] = get_reflection_spherical (e, H0, varargin{:}); % nominal interf. delay
    Di = get_reflection_spherical (e, Ha, varargin{:}); % actual interf. delay

    switch lower(type)
    case {'a','type-a'},  Kz0 = 2.*sind(e);
    case {'b','type-b'},  Kz0 = 2.*sind(g);
    end
    
    rDi = Di0 - Di;  % residual interf. delay
    rH = gradient_noend(rDi, Kz0);  % residual altimetry retrieval
end

