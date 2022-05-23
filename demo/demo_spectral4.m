%% Setup
setup_curvature_altimetry ()
addpath(genpath('C:\MatLabFiles\m'),'-end')
filepath = 'C:\MatLabFiles\gtgu-20150705-20150711-elev_prn_cluster.csv';

%% Load file and set columns into variables
data_obs = sortrows(load(filepath), [3 4 1]); 
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
hoy = doy.*DT;
degree = [];
prnu = unique (prn);
n = 0;
opt.hifac = 5;

for i=1:numel(prnu)
    
    prni = prnu(i);
    idx_prn_aux = find (prn == prni);
    hoy_prn = hoy(idx_prn_aux);
    dH_prn = dH(idx_prn_aux);
    
    [~, spec, fiti, fit2i] = lsqfourier(dH_prn, hoy_prn, [], degree, opt);
    
    period {i} = spec.period';
    power {i} =  spec.power';
    fit {i} = fiti;
    fit2 {i} = fit2i;
    dHi{i} = dH_prn;
    hoyi{i} = hoy_prn;
    
end

%%
for i=1:numel(prnu)  
    
    prni = prnu(i);
    
    figure
    stem (period{i}, power{i})
    xlabel('Period (h)')
    ylabel('Power spectral density (m^2/h^-1)')
    title (sprintf ('PRN%i', prni))
    grid on
    
    figure
    scatter (hoyi{i}, dHi{i}.*1000)
    xlabel ('Hour of year')
    ylabel ('Height correction (mm)')
    title (sprintf ('PRN%i', prni))
    grid on
    
end