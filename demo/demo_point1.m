setup_curvature_altimetry()

%%
Ha = 10;
ehor = get_spherical_reflection_horizon_elev (Ha);
ezen = 90;
num_elevs = 100;
e = linspace(ehor, ezen, num_elevs);

dH = get_curvature_altimetry_correction_pdoppler_point (e, Ha);

%%
%figure, plot(e, dH, '.-k'), xlabel('Elev. (deg.)'),  ylabel('dH (m)'), grid on
%idx = (e < 10); figure, plot(e(idx), dH(idx), '.-k'), xlabel('Elev. (deg.)'),  ylabel('dH (m)'), grid on

%%
%figure, semilogy(e, -dH, '.-k'), xlabel('Elev. (deg.)'),  ylabel('-dH (m)'), grid on
figure, negsemilogy(e, dH, '.-k'), xlabel('Elev. (deg.)'),  ylabel('dH (m)'), grid on

