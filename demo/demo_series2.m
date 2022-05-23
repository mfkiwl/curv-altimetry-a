setup_curvature_altimetry()

%%
Ha = [10 50 100 200 300 500 1000];
ehor = get_spherical_reflection_horizon_elev (Ha);
ehor = min(ehor);
ezen = 90;

num_elevs = 100;
num_heights = numel(Ha);

e = linspace(ehor, ezen, num_elevs);

%%
dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha);

%%
%figure, plot(e, dH, '.k')
%figure, semilogy(e, -dH, '.k'), xlabel('Elev. (deg.)'),  ylabel('-dH (m)'), grid on

figure
  negsemilogy(e, dH, '.-')
  xlabel('Elev. (deg.)')
  ylabel('dH (m)')
  xlim([min(ehor) ezen])
  grid on
  h=legend(num2strcell(Ha), 'Location','southeast');
    title(h, 'Ha (m)')

