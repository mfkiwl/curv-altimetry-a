function [dH, k, dk] = get_curvature_altimetry_correction_pdoppler_series_residual (e, Ha, DH, type, varargin)
% GET_CURVATURE_ALTIMETRY_CORRECTION_PDOPPLER_SERIES_RESIDUAL: Residual
% altimetry correction for the Earth's curvature effect and pseudo-Doppler
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
% - dH: residual altimetry correction (vector or matrix, in meters)
% - k: residual height factor (vector or matrix, in meters)
% - dk: residual height factor change (vector or matrix, in meters)

    if (nargin < 4),  type = ''; end

    rH = get_curvature_altimetry_retrieval_pdoppler_series_residual (e, Ha, DH, type, varargin{:});

    [dH, k, dk] = get_curvature_altimetry_correction_pdoppler_series_residual_aux (DH, rH);
end
