function cor_vert_displace = get_curvature_altimetry_correction_vert_displace (e, Ha, varargin)

% GET_CURVATURE_ALTIMETRY_VERT_DISPLACE returns an approximate for curvature 
% altimetry correction based on the simple vertical displacement between y
% coordinate on plane and sphere. Given y on plane is just zero, the
% altimetry correction is simply the y coord. on the sphere.

[~, ~, ~, ~, ~, y_sph] = get_reflection_spherical (e, Ha, varargin);
cor_vert_displace = y_sph;
