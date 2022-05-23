function [X, Y] = get_quasigeo_coord (x, y, Rs)

% GET_QUASIGEO_COORD Convert coordinates from local to quasigeocentric frame.
% 
% Note: local frame has origin at the foot of the antenna.
% while quasigeocentric frame has origin at the center of osculating sphere
%
% INPUT:
% - x,y: pair of coordinates in local frame (matrix, in meters)
% 
% OUTPUT: 
% - X,Y: pair of coordinates in quasigeocentric frame (matrix, in meters)
% 
% OPTIONAL INPUT:
% - Rs: surface radius to the center of osculating sphere (scalar, in meters)

    if (nargin < 3) || isempty(Rs),  Rs = get_earth_radius();  end

    Y = y + Rs;
    X = x;

end
