setup_curvature_altimetry()

%%
Ha = linspace(1,500,10);
ehor = get_spherical_reflection_horizon_elev (max(Ha));
ehor = min(ehor);
ezen = 90;
num_elevs = 1000;
e = linspace(ehor, ezen, num_elevs);

%%
dHz = get_curvature_altimetry_correction_pdoppler_zenith (Ha);
dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha, 'A');
dHn = dH./dHz;

dHz1 = get_curvature_altimetry_correction_pdoppler_zenith_poly (Ha);
dHn1 = get_curvature_altimetry_correction_pdoppler_norm_poly (e);
dH1 =  get_curvature_altimetry_correction_pdoppler_poly (e, Ha);

dif_dH  = dH-dH1;
dif_dHn = dHn.'-dHn1;
dif_dHz = dHz-dHz1;

%%
figure
semilogy (e, abs(dif_dH), '-.')
xlabel ('elevation angle (degrees)')
ylabel ('differences on dH (m)')
grid on
xlim([5 ezen])
legend (num2strcell(Ha))


%%
% figure
% contour(e, Ha, (dif_dH).', [-0.01 0.01], '--r');
% ylabel ('Antenna Height (m)');
% xlabel ('Elevation angle (degrees)');
% % legend ({'1-cm altimetry correction'},'Location', 'southeast')
% % xlim ([5 90])
% % ylim ([0 50])
% grid on