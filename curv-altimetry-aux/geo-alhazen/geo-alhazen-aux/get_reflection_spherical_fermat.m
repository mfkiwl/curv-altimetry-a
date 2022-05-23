function [graz_ang, geo_ang, x_spec, y_spec, x_trans, y_trans] = get_reflection_spherical_fermat (e, Ha, Ht, Rs)

% GET_REFLECTION_SPHERICAL_FUJIMURA Calculates reflection on spherical 
% surface with a numerical method based on Fermat's principle of least time
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


%% Interferometric delay 
% get distance between any two points (or pairs of points):
sumcol = @(arg) sum(arg, 2);  % sum columns
get_dist = @(pos1, pos2) sumcol((pos1-pos2).^2).^0.5;

% get reflection distance:
get_dist_reflect = @(pos_ant, pos_sat, pos_spec) ...
  get_dist(pos_ant, pos_spec) + get_dist(pos_spec, pos_sat);

% get direct distance:
get_dist_direct = @(pos_ant, pos_sat) ... 
  get_dist(pos_ant, pos_sat); %Unused

% get interferometric distance:
get_dist_interf = @(pos_spec, pos_ant, pos_sat) ...
  get_dist_reflect(pos_ant, pos_sat, pos_spec) - get_dist_direct(pos_ant, pos_sat); %Unused

%%
% get slant distance:
get_dist_slant_aux = @(e, R1, h21)...
  sqrt((R1 + h21)^2 - R1.^2.*cosd(e).^2) - R1.*sind(e); %Unused
get_dist_slant = @(e, R0, h1, h2) ...
  get_dist_slant_aux(e, R0+h1, h2-h1); % Unused 

% get antenna position:
get_pos_ant = @(h_ant) [0 h_ant];
 
%% Reflection point
get_y_sph = @(x, R0) sqrt(R0.^2 - x.^2) - R0;

get_pos_spec = @(x, R0) [x get_y_sph(x, R0)];

%%
%Antenna position
pos_ant = get_pos_ant(Ha); %in local frame

% Satellite position
pos_trans_loc = get_satellite_position (e,Ha,Ht,Rs,0); %local frame
x_trans = pos_trans_loc(1);
y_trans = pos_trans_loc(2);

%% Iterations
opt = struct('MaxIter',1000, 'TolX',1e-6, 'TolFun',1e-6); %fminsearch optmization options 
f = @(x) get_dist_reflect(pos_ant, pos_trans_loc, get_pos_spec(x, Rs)); % Function minimized 

x_pla = Ha./tand(e); % Reflection point x axis on plane
if (e==0),  x_pla = 0;  end  % Avoid division by zero
[x_sph] = fminsearch(f, x_pla,opt); % Reflection point x axis on sphere by Fermat's Principle

%% Reflection point position
pos_spec_loc = get_pos_spec(x_sph, Rs); % Reflection point location
x_spec = pos_spec_loc(1);
y_spec = pos_spec_loc(2);

%% Grazing Angle
graz_ang = real(get_grazing_angle_vector (pos_ant,pos_spec_loc,pos_trans_loc));

%% Geocentric angle
geo_ang = get_geocentric_angle (Ha,Ht,e,graz_ang,Rs);