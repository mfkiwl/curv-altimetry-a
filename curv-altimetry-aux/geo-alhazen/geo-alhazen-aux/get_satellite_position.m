function varargout = get_satellite_position (e,Ha,Ht,Rs,f)

% Returns position vector of transmitter/satellite by equations of
% Martín-Neira (1993) and Helm (2008)
%
% INPUT:
% - e: Elevation angle of transmitter (in degree)
% - Ha: Antenna height (in meters)
% - Ht: Transmitter/satelitte height (in meters)
% - Rs: Earth radius
% - f: flag about frame:
%      if 0, local frame (origin at the antenna foot)
%      if 1, geocentric frame (origin at center of Earth)

if (nargin < 5) || isempty(f),  f = 0;  end

% radii to transmitting satellite and to receiving antenna:
Ra = Rs+Ha;
Rt = Rs+Ht;

% angle ...
tau = asind((Ra./Rt).*sind(90+e));

% geocentric position vector of satellite:
temp = e+tau;
temp = temp(:);  % make it a column vector
pos_trans_geo = Rt.*[cosd(temp), sind(temp)];

% geocentric position vector of antenna foot (sub-antenna point):
pos_foot_geo = [0, Rs];

% relative position vector of satellite w.r.t. sub-antenna point:
pos_trans = pos_trans_geo - pos_foot_geo;

switch f
case 0  % local frame
    varargout = {pos_trans};
case 1  % geocentric frame
    varargout = {pos_trans_geo};
case 2  % both
    varargout = {pos_trans, pos_trans_geo};
end 

end

