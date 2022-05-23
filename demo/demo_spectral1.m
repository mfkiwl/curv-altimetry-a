% Spectral analysis of all data sorted by doy
filedir = 'C:\MatLabFiles'; 
filedir = 'c:\work\experiment\20220110 - vitor, empirical\'; 
%filename = 'gtgu-20150705-20150711-elev_prn_cluster.csv'; 
filename = 'gtgu-20150705-20150711-azim_elev_prn_cluster.csv'; 
filepath = fullfile(filedir, filename);

%% Setup
dir = 'C:\work\experiment\20220120 - Vitor, código curv-altimetry\demo';
run(fullfile(dir, 'setup_curvature_altimetry'))
setup_curvature_altimetry ()

%% Load file and set columns into variables
data_obs = sortrows(load(filepath),1); 
doy = data_obs(:,1).'; % day of year
a = data_obs(:,2).';   % observed azimuth angles
e = data_obs(:,3).';   % observed elevation angles
ddoy = doy - floor(min(doy));
%return

%% Apply azimuthal mask:
azim_lim = [070 270];
idx = azimuth_in_interval(a, 'clockwise', azim_lim);
a = a(idx);
e = e(idx);
doy = doy(idx);
ddoy = ddoy(idx);

%% Plot input data
figure
maximize()
plot(ddoy, e,'.-')
xlabel('Time change (days)')
ylabel('Elevation (degrees)')
%ylim ([-1 max(dH*1000)])
grid on

%
temp = rem(doy,1)*24;
ind = argsort(temp);
figure
plot(temp(ind), e(ind),'.-k')
xlabel('Time of day (hours)')
ylabel('Elevation (degrees)')
%ylim ([-1 max(dH*1000)])
grid on

%% Computate correction
Ha = 3.5;  % fixed antenna height
type = 'a';
e_amp = 0.01;
num_steps = 4;

dH = get_curvature_altimetry_correction_pdoppler_point (e, Ha, type, e_amp, num_steps);

%% Discard outliers
dH(abs(dH)>1e-3) = NaN;

%% Plot correction
figure
plot(doy*24, dH*1000,'.-')
xlabel('Time (h)')
ylabel('Height (mm)')
%ylim ([-1 max(dH*1000)])
grid on

%% Spectral analysis
DT = 24;
degree = 2;
period_inp = struct('hifac',1/5);
opt = struct('method','independent');
%opt = [];
[~, spec, fit, fit2, fit3] = lsqfourier(dH, ddoy.*DT, period_inp, degree, opt);

%% Convert PSD units:
% h^-1=1/h=1/(h*60^2s/h)=1/(3600s)=3600^-1*s^-1=3600^-1*Hz
% m^2/h^-1=m^2/(3600^-1Hz)=(1/3600)*m^2/Hz
spec.power2 = spec.power./3600;
spec.power2_unit = 'm^2/Hz';
spec.power2_label = sprintf('PSD (%s)', spec.power2_unit);
% ?m=m*10^6=m*1e6
% ?m^2=(?m)^2=m^2*10^12=m^2*1e6^2
spec.power3 = spec.power2*1e6^2;
spec.power3_unit = '?m^2/Hz';
spec.power3_label = sprintf('PSD (%s)', spec.power3_unit);

%% Plot spectrum
figure
maximize()
semilogx(spec.period, spec.power)
%set(gca(), 'XScale','log')
xlabel('Period (h)')
ylabel('PSD (m^2/h^-1)')
grid on

%
figure
maximize()
semilogx(spec.period, spec.power3)
xlabel('Period (h)')
ylabel(spec.power3_label)
grid on

%% Check sidereal day submultiples:
DTS=23.9344696;
fS=1/DTS;

figure
maximize()
semilogx(spec.period, spec.power3, '.-k')
xlabel('Period (h)')
ylabel(spec.power3_label)
grid on
temp = 1./(fS*(2:(ceil(max(spec.freq/fS)))));
vline(temp, '--r')
axis tight
xlim([min(xlim()) max(temp)])

%%
figure
maximize()
%stem(spec.freq, spec.power)
plot(spec.freq, spec.power3, '.-k')
xlabel('Frequency (h^{-1})')
ylabel(spec.power3_label)
vline(fS*(1:floor(max(spec.freq/fS))), '--r')
axis tight
grid on

%%
figure
maximize()
plot(spec.freq, spec.power3, '.-k')
axis tight
set(gca(), 'XDir','reverse')
set(gca(), 'XTickLabel',num2strcell(get(gca(),'XTick')'.^-1, '%.1f')')
xlabel('Period (h)')
ylabel(spec.power3_label)
vline(fS*(1:ceil(max(spec.freq/fS))), '--r')
grid on

%%
return
opt = struct('method','iterated', 'max_num_components',100);
[peak, spec, fit, fit2, fit3] = lsqfourier(dH, ddoy.*DT, period_inp, degree, opt);

%%
m=30;
figure
maximize()
hold on
plot(doy*24, dH*1000,'-k')
%plot(doy*24, fit2(:,spec.order(1:m))*1000, '-g', 'LineWidth',1)
%plot(doy*24, fit3(:,spec.order(1:m))*1000, '-r', 'LineWidth',1)
%plot(doy*24, fit3(:,spec.order(m))*1000, '-r', 'LineWidth',1.5)
plot(doy*24, fit3(:,spec.order(end))*1000, '-r', 'LineWidth',1.5)
plot(doy*24, fit*1000, '-g', 'LineWidth',1.5)
plot(doy*24, dH*1000,'.k')
xlabel('Time (h)')
ylabel('Height (mm)')
ylim ([-0.3 +0.05])
grid on

%figure, plot(doy*24, fit2(:,spec.order(1:m))*1000, '-g', 'LineWidth',1)
