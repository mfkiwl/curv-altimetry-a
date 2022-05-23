function [graz_ang, geo_ang, x_spec, y_spec, x_trans, y_trans] = get_reflection_spherical_helm (e, Ha, Ht, Rs)

% GET_REFLECTION_SPHERICAL_HELM Calculates reflection on spherical 
% surface based on Helm (2008) equations.
%
% A. Helm (2008)
% Ground-based GPS altimetry with the L1 OpenGPS receiver
% using carrier phase-delay observations of reflected GPS signals
% Scientific Technical Report 08/10
% doi: 10.2312/GFZ.b103-08104
% www.gfz-potsdam.de/bib/pub/str0810/0810.pdf
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

%% quasigeocentric origin
pos_cnt_loc = [0 -Rs];

%% Location vector of transmitter/satellite
[pos_trans_loc, pos_trans_geo]  = get_satellite_position (e,Ha,Ht,Rs,2);
x_trans = pos_trans_loc(1);
y_trans = pos_trans_loc(2);

%% Location vector of receiver
pos_ant_loc = [0 Ha]; % Location vector of receiver
pos_ant_geo = pos_ant_loc - pos_cnt_loc;

%% Solution to root of quartic polynomial (gamma)
% Solution to roots of quartic polynomial iterating gamma (without using all of roots)
% Iterative scheme based on modified Newthon-method - p.35-36-
[c0,c1,c2,c3,c4,~,gamma0] = quartic_param (pos_ant_geo, pos_trans_geo, Rs); % Quartic coefficients
    
i = 1;
i_max = 1000;
tns(1) = tand(gamma0/2);
gammas(1) = gamma0;
% cond = 1e-8*(180/pi);
cond = sqrt(eps());

while (i <= i_max)

    tn = tns(i);
    fn = c4.*tn.^4 + c3.*tn.^3 + c2.*tn.^2 + c1.*tn + c0;
    f1n = 4.*c4.*tn.^3 + 3.*c3.*tn.^2 + 2.*c2.*tn + c1;
    f2n = 12.*c4.*tn.^2 + 6.*c3.*tn + 2.*c2;
    kn = abs(f2n./f1n);
    tns(i+1) = tn-(fn./f1n);
    gammas(i+1) = 2.*atand((tns(i+1)));

    if (abs((gammas(i+1))-(gammas(i))) < cond)
        break
    end

    if (f1n==0 && kn>1) == true
        break
    end
    i = i+1;
end

if (i > i_max)
    disp('Did not converged!');
end

gamma = gammas(i);

%% Position vector of specular reflection point 
pos_spec_geo = [(Rs*cosd(gamma)) (Rs*sind(gamma))];
pos_spec_loc = pos_spec_geo + pos_cnt_loc;
x_spec = pos_spec_loc(1);
y_spec = pos_spec_loc(2);

%% Grazing angle
graz_ang = 90-(gamma-e);

%% Geocentric angle between reflection point and subreceiver (phi1)
geo_ang = get_geocentric_angle (Ha,Ht,e,graz_ang,Rs);
