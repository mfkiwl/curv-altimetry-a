%% Setup
setup_curvature_altimetry ()
addpath(genpath('C:\MatLabFiles\m'),'-end')
filepath = 'C:\MatLabFiles\gtgu-20150705-20150711-elev_prn_cluster.csv';

%% Load file and set columns into variables
data_obs = sortrows(load(filepath), [4 1]); 
doy = data_obs(:,1).'; % day of year
e = data_obs(:,2).';   % observed elevation angles
prn = data_obs(:,3).'; % GPS satellite
code = data_obs(:,4).'; % arc code (ascending or descending)

%% Correction computation
Ha = 3.5;  % fixed antenna height
type = 'a';
e_amp = 0.01;
num_steps = 4;

dH = get_curvature_altimetry_correction_pdoppler_point (e, Ha, type, e_amp, num_steps);

%% lsqfourier computation
DT = 24;
hoy = doy*DT;
degree = 2;
codeu = unique (code);
n = numel(codeu);
spec = cell(n,1);
power = cell(n,1);
period = cell(n,1);
hoyc = cell(n,1);
dHc = cell(n,1);
fit = cell(n,1);
fit2 = cell(n,1);

for i=1:n

    codei = codeu(i);
    idx = find(code==codei);
    hoyi = hoy(idx);
    dHi = dH(idx);
    hoyc{i} = hoyi;
    dHc{i} = dHi;

    [~, speci, fiti, fit2i] = lsqfourier(dHi, hoyi, [], degree);
    
    spec{i} = speci;
    power{i} =  speci.power';
    period{i} = speci.period';
    fit{i} = fiti;
    fit2{i} = fit2i;
end

return
%% Plot all codes

figure
hold on
for i=1:n; stem(period{i}, power{i}); end
xlabel('Period (h)')
ylabel('Power spectral density (m^2/h^-1)')
ylim([0 2.5e-7])
legend (num2strcell(codeu(:)), 'NumColumns', 3, 'Location', 'northwest')
grid on

figure
hold on
for i=1:n; plot(hoyc{i}, fit{i}, '.-'); end
xlabel('hour of year')
ylabel('fit')
legend (num2strcell(codeu(:)), 'NumColumns', 4, 'Location', 'southeast')
grid on

figure
hold on
for i=1:n; plot(period{i}, fit2{i}, '.-'); end
xlabel('Period (h)')
ylabel('fit2')
legend (num2strcell(codeu(:)), 'NumColumns', 3, 'Location', 'northwest')
grid on

%% Plot into subplots

for i=1:5:numel(codeu)
    
    fh=figure;
    for j=1:5
        m = i+(j-1);    
        subplot (2,3,j)
            stem (period{m}, power{m})
            legend (num2strcell(codeu(m)))
            xlabel('Period (h)')
            ylabel('Power spectral density (m^2/h^-1)')
            grid on
    end
    
%     fh.WindowState = 'maximized';
%     my_fig = strcat('spec_code_',num2str(i));
%     saveas(gcf,my_fig,'jpg');
    
end

%% Plot a chosen code
p = 1; 

figure
title (sprintf('Code = %i', p))
subplot (2,2,1)
stem(period{p}, power{p})
xlabel('Period (h)')
ylabel('Power spectral density (m^2/h^-1)')
legend (num2strcell(p))
grid on

subplot (2,2,2)
plot(hoyc{p}, dHc{p}*1000,'.-')
xlabel('hoy (h)')
ylabel('dH (mm)')
legend (num2strcell(p))
grid on

subplot (2,2,3)
hold on
for i=1:n; plot(hoyc{p}, fit{p}, '.-'); end
xlabel('hour of year')
ylabel('fit')
legend (num2strcell(p))
grid on

subplot (2,2,4)
hold on
for i=1:n; plot(period{p}, fit2{p}, '.-'); end
xlabel('Period (h)')
ylabel('fit2')
legend (num2strcell(p))
grid on

% figure
% stem(period{p}, power{p})
% xlabel('Period (h)')
% ylabel('Power spectral density (m^2/h^-1)')
% legend (num2strcell(p))
% grid on
% 
% figure
% plot(hoyc{p}, dHc{p}*1000,'.-')
% xlabel('hoy (h)')
% ylabel('dH (mm)')
% legend (num2strcell(p))
% grid on
% 
% figure
% hold on
% for i=1:n; plot(hoyc{p}, fit{p}, '.-'); end
% xlabel('hour of year')
% ylabel('fit')
% legend (num2strcell(p))
% grid on
% 
% figure
% hold on
% for i=1:n; plot(period{p}, fit2{p}, '.-'); end
% xlabel('Period (h)')
% ylabel('fit2')
% legend (num2strcell(p))
% grid on

%% Plot a chosen interval
p = [1:1:5];

for i=1:numel(p)
    
    figure
    stem(period{p(i)}, power{p(i)})
    xlabel('Period (h)')
    ylabel('Power spectral density (m^2/h^-1)')
    legend (num2strcell(i))
    grid on
    
    figure
    plot(hoyc{p(i)}, fit{p(i)}, '.-')
    xlabel('hour of year')
    ylabel('fit')
    legend (num2strcell(i))
    grid on
    
    figure
    plot(period{p(i)}, fit2{p(i)}, '.-')
    xlabel('Period (h)')
    ylabel('fit2')
    legend (num2strcell(i))
    grid on
end