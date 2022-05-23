setup_curvature_altimetry()

%%
%Ha = [10 50 100 200 300 500 1000];
Ha = linspace(10, 1000, 50);
ehor = get_spherical_reflection_horizon_elev (Ha);
ehor = min(ehor);
ezen = 90;

num_elevs = 100;
num_heights = numel(Ha);

e = linspace(ehor, ezen, num_elevs);

%%
dHz = get_curvature_altimetry_correction_pdoppler_zenith (Ha);

%%
figure
  plot(Ha./1000, 10*dHz, 'o-')
  xlabel('Antenna height (km)')
  ylabel('Zenithal altimetry correction (cm)')
  grid on

%%
%[p,s] = polyfit(Ha, dHz+1000, 2);
[p,s] = polyfit(Ha./1000, 100*dHz, 2);

%%
dHz2 = polyval(p, Ha./1000)./100;
figure
  hold on
  plot(Ha./1000, 10*dHz, 'o-b')
  plot(Ha./1000, 10*dHz2, '.-r')
  xlabel('Antenna height (km)')
  ylabel('Zenithal altimetry correction (cm)')
  grid on

%%
s.Rinv = inv(s.R);
s.C = (s.Rinv*s.Rinv')*s.normr^2/s.df;
s.s = sqrt(diag(s.C));
s.u = 3*s.s;

disp([p(:) s.u])

t = table(p(:), s.u, {'cm/km^2' 'cm/km' 'cm'}', 'VariableNames',{'Coefficient','Uncertainty','Units'});
disp(t)
