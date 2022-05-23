function dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha, type, varargin)
% GET_CURVATURE_ALTIMETRY_CORRECTION_PDOPPLER_SERIES Altimetry correction for the
% Earth's curvature effect and psudo-Doppler formulation (note: meant for 
% a series of elevation angles at a fixed antenna height).
% 
% INPUT:
% - e: elevation angles (vector or matrix, in degrees)
% - Ha: antenna height (scalar or vector, in meters)
% - type: (char) type of altimetry correction for the Earth's curvature
%           'A': type-A correction for crossed pseudo-Doppler altimetry
%           'B': type-B correction for spherical pseudo-Doppler altimetry
% - varargin: optional input, see get_reflection_spherical for details.
%
% Note: antenna height is assumed constant for each series of elevation angles, so:
% - if e is a vector, Ha shall be a scalar.
% - if e is matrix, Ha shall be a vector, with numel(Ha)==size(e,2).
% 
% OUTPUT:
% - dH: altimetry correction (vector or matrix, in meters)
% 
% Examples:
% - scalar Ha:
% e = 1:10;  Ha = 10;  dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha)
% - vector Ha:
% e = 1:10;  Ha = 1:10;  dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha)

    if (nargin <3) || isempty(type),  type = 'A';  end

    [e, Ha, siz] = get_curvature_altimetry_series_prep (e, Ha);

    [Di_p, ~, Kz_p] = get_reflection_planar (e, Ha);
    %[Di_s, ~, Kz_s] = get_reflection_spherical (e, Ha, varargin{:});  % WRONG!
    [Di_s, g] = get_reflection_spherical (e, Ha, varargin{:});

    % Interferometric delay difference between plane and sphere
    dDi = Di_p - Di_s;
    
    switch lower(type)
    case {'a','typea'}
        dH = -gradient_all_noend(dDi, Kz_p);
    case {'b','type'}
        Kz_s = get_vertical_sensitivity(g);
        dH1 = -gradient_all_noend(dDi, Kz_s);
        
        zeta = gradient_all_noend (Kz_p, Kz_s);  % = gradient (sind(e), sind(g));
        dH2 = Ha.*(zeta - 1);

        dH = dH1 + dH2;
    end

    dH = reshape(dH, siz);    
end

