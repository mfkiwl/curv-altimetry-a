function dH = get_curvature_altimetry_retrieval_pdoppler_point (e, Ha, type, e_amp, num_steps, varargin)
% GET_CURVATURE_ALTIMETRY_RETRIEVAL_PDOPPLER_POINT Altimetry retrieval for the
% Earth's curvature effect and pseudo-Doppler formulation (note: meant for 
% a single point or multiple independent points).
% 
% INPUT:
% - e: elevation angles (vector, in degrees)
% - Ha: antenna height (vector, in meters)
% - type: (char) type of altimetry retrieval for the Earth's curvature
%           'A': type-A retrieval for crossed pseudo-Doppler altimetry
%           'B': type-B retrieval for spherical pseudo-Doppler altimetry
% - varargin: optional input, see get_reflection_spherical for details.
%
% OUTPUT:
% - H: altimetry retrieval (vector, in meters)

    if (nargin < 3),  type = [];  end
    if (nargin < 4),  e_amp = [];  end
    if (nargin < 5),  num_steps = [];  end

    dH = get_curvature_altimetry_auxiliary_pdoppler_point ('retrieval', e, Ha, type, e_amp, num_steps, varargin{:});
end

