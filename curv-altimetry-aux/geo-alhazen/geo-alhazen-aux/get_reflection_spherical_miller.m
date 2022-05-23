function [graz_ang, geo_ang, x_spec, y_spec, x_trans, y_trans] = get_reflection_spherical_miller (e, Ha, Ht, Rs)

% GET_REFLECTION_SPHERICAL_MILLER  Calculates reflection on spherical 
% surface based on Miller & Vegh (1993) equations.
%
%Main reference 
% A. R. Miller and E. Vegh (1993)
% "Exact Result for the Grazing Angle of Specular Reflection from a Sphere"
% SIAM Review, Vol. 35, No. 3 (Sep., 1993), pp. 472-480
% <https://doi.org/10.1137/1035091>
% <https://www.jstor.org/stable/2132427>

% Complementary reference
% A. R. Miller and E. Vegh (1990)
% "Computing the grazing angle of specular reflection"
% International Journal of Mathematical Education in Science and
% Technology, v. 21, n. 2
% <https://doi.org/10.1080/0020739900210213>
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

%% convert degree to radians
e_rad = deg2rad(e); % elevation angle should be in radians

%% Quartic poynomial solution
% spheric-centric angle (phi) - Fig.1, p.473
% (law of cosines at the center of sphere)
[~,geo_ang_at] = get_geocentric_angle (Ha,Ht,rad2deg(e_rad),0,Rs); %geocentric angle between antenna and transmitter

k1=Rs./(Rs+Ha);  % mid p.473
k2=Rs./(Rs+Ht);  % mid p.473

alpha=exp(1i.*geo_ang_at).*(exp(1i.*geo_ang_at) -k1.*k2);  % top p.473
beta=k1.^2 +k2.^2 -2.*k1.*k2.*exp(1i.*geo_ang_at);  % top p.473
gamma=2*(k1.^2 +k2.^2 -k1.*k2.*cos(geo_ang_at) -1);  % top p.473

n = numel(e_rad);
zs = NaN(n,4);

for i=1:numel(e_rad)
    % Roots of quartic polynomial
    zs(i,:) = roots([alpha(i), beta(i), gamma(i), conj(beta(i)), conj(alpha(i))]);  % top p.473
end

psi = z2psi(zs,geo_ang_at, k1, k2);
graz_ang = psi.*180./pi; % Grazing angle of spherical specular reflection

%% Geocentric angles
% Geocentric angle between receiver and reflection point
geo_ang = get_geocentric_angle (Ha,Ht,e,graz_ang,Rs);

%% Reflection point location vector
pos_spec_geo = [(Rs.*sind(geo_ang)) (Rs.*cosd(geo_ang))];
pos_cnt_loc = [0 -Rs];
pos_spec_loc = pos_spec_geo + pos_cnt_loc; 
x_spec = pos_spec_loc(1);
y_spec = pos_spec_loc(2);

%% Location vector of transmitter/satellite
pos_trans_loc = get_satellite_position (e,Ha,Ht,Rs,0);
x_trans = pos_trans_loc(1);
y_trans = pos_trans_loc(2);
end


function psi = z2psi (zs, phi, k1, k2)
  
% Evaluation for the correct root

% Roots of quartic polynomial ([alpha, beta, gamma, conj(beta), conj(alpha)])
psis = (1/2).*acos(real(zs));  % bottom p.473

% Condition: phi + 2*psis = acos(k1*cos(psis)) +acos(k2*cos(psis)) % eq.2, p.473
% Left hand condition
eq2_lhs = phi +2*psis;
% Right hand condition
eq2_rhs = acos(k1*cos(psis)) +acos(k2*cos(psis)); % eq.2, p.473
% Equation 2 equality test
eq2_neq = eq2_lhs - eq2_rhs;

% Column of mininum eq2_neq (Equality test)
eq2_col = argmin(abs(eq2_neq), [], 2);

[n, m] = size(zs);

% [n,m]Size of array, (1:n)Rows of array, eq2_col column of array
% Return the indices
eq2_ind = sub2ind([n m], (1:n)', eq2_col);
% Get the minimum error of equalities test
eq2_err = eq2_neq(eq2_ind);
% Tolerance
tol = sqrt(eps());
% Error should be smallest than tolerance
eq2_cond = (abs(eq2_err) < tol);
% "the unique value psi of psi* that satisfies [eq.(2)] is the grazing angle" bottom p.473
% Psi receive the real part of correct root of quartic polynomial
psi = real(psis(eq2_ind));

end
