setup_curvature_altimetry()

%%
Ha = [10 50 100 200 300 500 1000];

e = 45;
e = repmat(e, size(Ha));

%%
dH = get_curvature_altimetry_correction_pdoppler_point (e, Ha);

%%
%figure, plot(Ha, dH, '.k')
%figure, semilogy(Ha, -dH, '.k'), xlabel('Height (m)'),  ylabel('-dH (m)'), grid on

figure
  negsemilogy(Ha, dH, '.-')
  xlabel('Height (m)')
  ylabel('dH (m)')
  grid on

