%% DEMO - Residual altimetry correction for spherical pseudo-Doppler altimetry
setup_curvature_altimetry()

%% SETUP
H0 = 500e3; % reference antenna height for an orbital station (in meters)
DH = 50;  % deviation in antenna height (in meters)

ehor = get_horizon_elevation_angle(Ha);
e = [90:-0.1:ehor ehor]; % elevation angles domain

%% COMPUTATION
type = 'b';
rH = get_curvature_altimetry_retrieval_pdoppler_series_residual (e, Ha, DH, type);
[dH, k, dk] = get_curvature_altimetry_correction_pdoppler_series_residual_aux (DH, rH);

%%
figure
plot(e, rH, '.-k')
xlabel('Elevation angle (degrees)')
ylabel('Residual altimetry retrieval (m)')
xlim([ehor 90])
grid on

%%
figure
plot(e, dH, '.-k')
xlabel('Elevation angle (degrees)')
ylabel('Residual altimetry correction (m)')
xlim([ehor 90])
grid on

%%
figure
plot(e, dk*100, '.-k')
xlabel('Elevation angle (degrees)')
ylabel('Residual altimetry factor change (%)')
xlim([ehor 90])
grid on
