setup_curvature_altimetry()

%%
Ha = 100;
ehor = get_spherical_reflection_horizon_elev (Ha);
ezen = 90;
num_elevs = 100;
e = linspace(ehor, ezen, num_elevs);

dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha);
dHz = get_curvature_altimetry_correction_pdoppler_zenith (Ha);
dHn = dH./dHz;

%%
% figure, plot(e, dH, '.-k'), xlabel('Elev. (deg.)'),  ylabel('dH (m)'), grid on
% hline(dHz, '-r')
%idx = (e < 10); figure, plot(e(idx), dH(idx), '.-k'), xlabel('Elev. (deg.)'),  ylabel('dH (m)'), grid on

%%
% figure, semilogy(e, -dH, '.-k'), xlabel('Elev. (deg.)'),  ylabel('-dH (m)'), grid on
% hline_semilogy(-dHz, {'-r','LineWidth',1.5})

%%
figure, negsemilogy(e, dH, '.-k'), xlabel('Elev. (deg.)'),  ylabel('dH (m)'), grid on
hline_semilogy(abs(dHz), {'--r','LineWidth',1.5})

%%
figure, semilogy(e, dHn, '.-k'), xlabel('Elev. (deg.)'),  ylabel('dHn (m/m)'), grid on
%figure, plot(e, dHn, '.-k'), xlabel('Elev. (deg.)'),  ylabel('dHn (m/m)'), grid on

%%
x = e;
x = 1./sind(e);
[p,s] = nanpolyfit(x, log10(dHn), 5);

%
dHn2 = 10.^polyval(p, x);
figure
  semilogy(e, dHn,  'o-b')
  hold on
  semilogy(e, dHn2, '.-r')
  xlabel('Elev. (deg.)')
  ylabel('dHn (m/m)')
  grid on

%%
% figure, plot(e, (log10(dHn)))
% figure, plot(e, log10(dHn)./sind(e))
% figure, ezplot(@(x)1./sind(x), [0 90])

%%
s.Rinv = inv(s.R);
s.C = (s.Rinv*s.Rinv')*s.normr^2/s.df;
s.s = sqrt(diag(s.C));
s.u = 3*s.s;

disp([p(:) s.u])
