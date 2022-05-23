%% Results for the paper

setup_curvature_altimetry()

%%
Ha = [10 50 100 200 300 500];
% Ha = [10 50 100:100:500];
Ha1 = linspace(0,500,100);
ehor = get_spherical_reflection_horizon_elev (max(Ha));
ehor = min(ehor);
ezen = 90;
num_elevs = 100;
% e = linspace(ehor, ezen, num_elevs);
e = [90:-0.01:ehor ehor];

%%
dHz = get_curvature_altimetry_correction_pdoppler_zenith (Ha);
dH = get_curvature_altimetry_correction_pdoppler_series (e, Ha, 'A');
dHn = dH./dHz;

%%
dHn1 = get_curvature_altimetry_correction_pdoppler_norm_poly (e);
dHz0 = get_curvature_altimetry_correction_pdoppler_zenith (Ha1);
dHz1 = get_curvature_altimetry_correction_pdoppler_zenith_poly (Ha1);

dH0 = get_curvature_altimetry_correction_pdoppler_series (e, Ha, 'A');
dH1 = get_curvature_altimetry_correction_pdoppler_poly (e, Ha);
dif_dH = dH0-dH1;

%% Results for the article 

leg = num2strcell(Ha);
leg{end+1} = 'Curve fit';

setup_plot()
figure 
semilogy (e, dHn)
hold on
semilogy (e, dHn1, 'o')
xlabel ('Elevation angle (degrees)')
ylabel ('Normalized altimetry correction (m/m)')
grid on
legend (leg)
xlim ([ehor ezen])
ylim ([min(dHn1) 10^4])

figure
plot (Ha1, dHz0, 'or')
hold on
plot (Ha1, dHz1, '-k')
xlabel ('Antenna Height (m)')
ylabel ('Zenith altimetry correction (m)')
ylim ([min(dHz0) 0])
legend({'Numerical','Curve fit'})
grid on

return
%%
c1 = [1    1    0
      0    1    0
      0    1    1
      0    0    1
      0    0    0
      1    0    1
      1    0    0]; %y,g,c,b,k,r 
set(groot,'defaultAxesColorOrder',c1)
figure
semilogy (e, abs(dif_dH), '-')
xlabel ('Elevation angle (degrees)')
ylabel (sprintf('Differences between numerical and polynomial \n altimetry correction (m)'))
grid on
xlim([ehor ezen])
ylim ([10^-7 10^1])
legend (leg)

figure
plot (e, abs(dif_dH./dH0).*100, '-.')
xlabel ('Elevation angle (degrees)')
ylabel (sprintf('Percentual differences between numerical and polynomial \n altimetry correction (%%)'))
grid on
xlim([ehor ezen])
ylim([0 100])
% ylim([10^-3 10^2])
legend (leg)