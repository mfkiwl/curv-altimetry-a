function [delay, graz_ang, arc_len, slant_dist, x_spec, y_spec, ehor] = get_spherical_reflection_horizon (Ha, Rs, frame)

% GET_SPHERICAL_REFLECTION_HORIZON: Returns parameters of the specular reflection on the spherical horizon.
% 
% All parameters are precisely derived from closed trigonometric formulations or exact expected results. 
% 
% INPUT:
% - Ha: antenna height above the surface (in meters)
% 
% OUTPUT:
% - delay: interferometric delay (in meters)
% - graz_ang: grazing angle (degrees)
% - arc_len: arc length (in meters)
% - slant_dist: slant distance (in meters)
% - x_spec, y_spec: specular reflection point coordinates (in meters)
% - ehor: elevation angle (degrees)
% 
% OPTIONAL INPUT:
% - R0: radius of the sphere (in meters)
% - frame: (char) coordinate reference frame ('local' - default - or 'quasigeo')

    if (nargin < 2) || isempty(Rs),  Rs = get_earth_radius();  end
    if (nargin < 3) || isempty(frame),  frame = 'local';  end

    delay = zeros(size(Ha));
    graz_ang = zeros(size(Ha));
    slant_dist = sqrt(2.*Rs.*Ha+Ha.^2);    
    Y_spec = Rs-Ha./(1+Ha./Rs);
    X_spec = sqrt(Rs.^2-Y_spec.^2);
    y_spec = Y_spec-Rs;
    x_spec = X_spec;
    arc_len = Rs.*(asin(x_spec./Rs));
    ehor = get_horizon_elevation_angle (Ha,Rs);

    if strcmpi(frame, 'local'),  return;  end
    % output will be in quasi-geocentric frame:
    x_spec = X_spec;
    y_spec = Y_spec;
end

