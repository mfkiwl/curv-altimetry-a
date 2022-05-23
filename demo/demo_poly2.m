setup_curvature_altimetry()

%%
Ha = [10 50 100 200 300 500 1000];
ehor = get_spherical_reflection_horizon_elev (Ha);
ehor = min(ehor);
ezen = 90;
num_elevs = 1000;
e = linspace(ehor, ezen, num_elevs);

%%
dHz = get_curvature_altimetry_correction_pdoppler_zenith (Ha);
dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha, 'A');
dHn = dH./dHz;

%%
dHz1 = get_curvature_altimetry_correction_pdoppler_zenith_poly (Ha);
dHn1 = get_curvature_altimetry_correction_pdoppler_norm_poly (e);
dH1 = get_curvature_altimetry_correction_pdoppler_poly (e, Ha);

%%
figure
semilogy (e, abs(dH-dH1), '-.')
grid on
xlim([5 ezen])
legend (num2strcell(Ha))

figure
semilogy (e, abs(dHn-dHn1.'), '-.')
grid on
xlim([5 ezen])
legend (num2strcell(Ha))

figure
scatter (Ha, dHz-dHz1)
grid on
