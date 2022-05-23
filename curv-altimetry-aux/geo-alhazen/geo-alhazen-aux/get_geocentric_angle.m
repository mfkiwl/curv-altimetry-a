function [geo_ang,geo_ang_at] = get_geocentric_angle (Ha,Ht,e,g,Rs)

% Returns geocentric angles, where phi is the geocentric angle between 
% antenna and transmitter and phi1 is the geocentric angle between antenna 
% and reflection point
%
% INPUT:
% - Ha: Antenna height (in meters)
% - Ht: Transmitter/satelitte height (in meters)
% - e: Elevation angle of transmitter (in degree)
% - g: Grazing angle (in degree)
% - Rs: Earth radius (in meters)
%
% Obs: 
% - Rt and is only for phi_at, otherwise use h2=0 and e=0;
% - g is only for phi_as, otherwise use g=0.

if nargin==1 || isempty(Ht) || Ht == 0
    Ht = 20e6; %in meters - p. 335
end

if nargin==4 || isempty(Rs) || Rs == 0
    Rs = 6370e3; %in meters
end

%% Conversion
% e_rad = deg2rad(e);
% g_rad = deg2rad(g);
Ra = Rs+Ha;
Rt = Rs+Ht;
%% Geocentric Angle Antenna-Transmitter
% Coefficients of quadratic polynomial
a=1;
b=-2*(Ra).*cosd(90+e);
c=(Ra).^2-(Rt).^2;

% Delta of quadratic
delta=b.^2-4.*a.*c;

% Roots
r1=(-b+delta.^0.5)./(2*a);
r2=(-b-delta.^0.5)./(2*a);

% Choose of correct root
D=max(r1,r2);

% Geocentric angle
geo_ang_at=acos((D.^2 -(Ra).^2 -(Rt).^2)./(-2*(Ra).*(Rt)));

%% Geocentric Angle Antenna-Reflection Point
geo_ang = acosd((Rs./(Rs+Ha)).*cosd(g))-g;
