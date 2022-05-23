function [c0,c1,c2,c3,c4,t0,gamma0] = quartic_param (pos_ant, pos_sat, Rs)

% Return parameters (coefficients and starting estimate value)
% of quartic polynomial for Martin-Neira (1993) and Helm (2008) equations

%%
xt=pos_sat(1); % X coordinate of transmitter/satellite
yt=pos_sat(2); % Y coordinate of transmitter/satellite

xr=pos_ant(1); % X coordinate of receiver
yr=pos_ant(2); % Y coordinate of receiver

%% Coefficients of quartic polynomial
c0 = ((xt.*yr)+(yt.*xr))-(Rs.*(yt+yr));
c1 = (-4.*((xt.*xr)-(yt.*yr)))+(2.*Rs.*(xt+xr));
c2 = (-6.*((xt.*yr)+(yt.*xr)));
c3 = (4.*((xt.*xr)-(yt.*yr)))+(2.*Rs.*(xt+xr));
c4 = ((xt.*yr)+(yt.*xr))+(Rs.*(yt+yr));

%% Starting estimate value 
cos_gamma_rt = dot(pos_sat, pos_ant)./(norm(pos_sat).*norm(pos_ant));
gamma_rt = acosd(cos_gamma_rt); % Angle between receiver and transmitter direction

gamma0 = (90-(gamma_rt./3));
t0 = tand(gamma0./2); % Starting estimate value 