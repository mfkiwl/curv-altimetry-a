function [graz_ang, geo_ang, x_spec, y_spec, x_trans, y_trans] = get_reflection_spherical_fujimura (e, Ha, Ht, Rs)

% GET_REFLECTION_SPHERICAL_FUJIMURA Calculates reflection on spherical 
% surface based on Fujimura et al. (2019) equations.
%
% M. Fujimura et al. (2019)
% The Ptolemy–Alhazen Problem and Spherical Mirror Reflection
% Computational Methods and Function Theory,  v.19, p. 135–155
%
% INPUT:
% - Ha: antenna/receiver height (in meters)
% - e: elevation angle (in radians)
% - Ht: Transmitter/satelitte height (in meters)
% - Rs: Earth radius (in meters)
% 
% OUTPUT:
% - x_spec, y_spec: reflection point in local frame (vectors, in meters)
% - x_trans, y_trans: transmitter point in local frame (vectors, in meters)
% - graz_ang: grazing angle of spherical reflection that satisfies Snell's Law (in degrees)
% - geo_ang: geocentric angle between receiver and reflection point (in degrees) 

%% 
% Geocentric radii to receiving antenna and transmitting satellite
Ra = Rs+Ha;
% Rt = Rs+Ht; #UNUSED2

% Functions to convert from position vector to complex number and vice versa:
posgeo2complex = @(pos) complex(pos(2), pos(1))./Rs;
complex2posgeo = @(cpx) [imag(cpx), real(cpx)].*Rs;  % in geo frame

% Geocenter position in local frame:
pos_cnt_loc = [0 -Rs];

% Receiving antenna position:
pos_ant_loc = [0 Ha];  % in local frame
pos_ant_geo = pos_ant_loc - pos_cnt_loc;  % in geocentric frame
z1 = posgeo2complex(pos_ant_geo);  % as complex number

% Transmitting satellite position:
[pos_trans_loc, pos_trans_geo] = get_satellite_position (e, Ha, Ht, Rs, 2);
z2 = posgeo2complex(pos_trans_geo);

% Polynomial coefficients:
c4 = +conj(z1)*conj(z2);
c3 = -(conj(z1)+conj(z2));
c2 =  0;
c1 = (z1+z2);
c0 =-(z1*z2);
p = [c4 c3 c2 c1 c0];

% Polymomial roots solutions
us = roots(p);

% Fermat condition of minimum path lenght 
cond = abs(z1-us) + abs(z2-us);
[~,ind]= min(cond);

% Correct root
u = us(ind);

% Reflection point coordinates, in local frame:
pos_spec_geo = complex2posgeo(u);  % in geocentric frame
pos_spec_loc = pos_spec_geo + pos_cnt_loc;  % in local frame

% pos_spec_geo = complex2posgeo(u);  % in geocentric frame
% pos_spec_loc = pos_spec_geo + pos_cnt_loc;  % in local frame

% Point coordinates output results:
x_spec = pos_spec_loc(1);
y_spec = pos_spec_loc(2);
x_trans = pos_trans_loc(1);
y_trans = pos_trans_loc(2);
%pos_spec = struct('geo',pos_spec_geo, 'loc',pos_spec_loc);
%pos_trans = struct('geo',pos_trans_geo, 'loc',pos_trans_loc);
%%pos_spec = struct();
%%pos_spec.X = pos_spec_geo(:,1);
%%pos_spec.Y = pos_spec_geo(:,2);
%%pos_spec.x = pos_spec_loc(:,1);
%%pos_spec.y = pos_spec_loc(:,2);
%%%pos_spec.geo = pos_spec_geo;
%%%pos_spec.loc = pos_spec_loc;

%% Geocentric angle between antenna and reflection point
geo_ang = rad2deg(angle(u));

%% Grazing Angle
graz_ang = atand(cotd(geo_ang)-(Rs./Ra)./sind(geo_ang));

end

