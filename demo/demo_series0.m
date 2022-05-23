setup_curvature_altimetry()

%%
Ha = 10;
ehor = get_spherical_reflection_horizon_elev (Ha);
ezen = 90;
num_elevs = 100;
e = linspace(ehor, ezen, num_elevs);

type = 'a';  myplot = @loglog;
%type = 'b';  myplot = @plot;

dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha, type);
He = get_curvature_altimetry_retrieval_pdoppler_series (e, Ha, type);
dHalt = He - Ha;

%%
figure, myplot(-dH, -dHalt, 'o-k')
xlabel('Theoretical -dH (m)')
ylabel('Numerical -dH (m)')
grid on
 
%%
figure, plot(-dH, dH-dHalt, '.k')
xlabel('Theoretical -dH (m)')
ylabel('Discrepancy in dH (m)')
grid on
