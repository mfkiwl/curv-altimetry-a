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
    code_prn = code(idx_prn_aux);
    codeu_prn = unique(code_prn);
    count_code_prn = numel(codeu_prn);
    hoy_prn = hoy(idx_prn_aux);
    dH_prn = dH(idx_prn_aux);
    
    for j=1:count_code_prn
        
        n = n+1;
        ct(n,1) = n; ct(n,2) = prni; ct(n,3) = codeu_prn(j);
        
        code_idx_aux = find(codeu_prn(j)==code_prn);
        lgt = numel(code_idx_aux);
        hoyi = hoy_prn(code_idx_aux); 
        dHi = dH_prn(code_idx_aux);
        
        hoyc{n} = hoyi; dHc{n} = dHi;
        
        [~, spec, fiti, fit2i] = lsqfourier(dHi, hoyi, [], degree, opt);
        
        period {n} = spec.period';
        power {n} =  spec.power';
        fit {n} = fiti;
        fit2 {n} = fit2i;
      
    end
    
end

% return 
%% Plot
y = 1;

for i=1:numel(prnu)  
    
    prni = prnu(i);
    idx = find(prni==ct(:,2));
    
    fh=figure; 
    hold on
    for j=1:numel(idx)
       n = idx(j); 
       stem (period{n}, power{n})
    end
    
    xlabel('Period (h)')
    ylabel('Power spectral density (m^2/h^-1)')
    title (sprintf ('PRN%i', prni))
    legend (num2strcell(ct(idx,3)))
    grid on
    hold off
    
%     fh.WindowState = 'maximized';
%     my_fig = strcat('spec_prn_',num2str(i));
%     saveas(gcf,my_fig,'jpg');

    if y==1
       
        figure
        hold on
        for j=1:numel(idx)
            n = idx(j);
            plot (hoyc{n}, dHc{n}.*1000, '.-')
        end
        xlabel('hour of year')
        ylabel('dH(mm)')
        title (sprintf ('PRN%i', prni))
        legend (num2strcell(ct(idx,3)))
%         set (gca, 'Yscale', 'log')
        grid on
        hold off
        
%         figure
%         hold on
%         for j=1:numel(idx)
%             n = idx(j);
%             plot (hoyc{n}, fit{n}, '.-')
%         end
%         xlabel('hour of year')
%         ylabel('fit')
%         title (sprintf ('PRN%i', prni))
%         legend (num2strcell(ct(idx,3)))
%         grid on
%         hold off
%         
%         figure
%         hold on
%         for j=1:numel(idx)
%             n = idx(j);
%             plot (period{n}, fit2{n}, '.-')
%         end
%         xlabel('Period(h)')
%         ylabel('fit2')
%         title (sprintf ('PRN%i', prni))
%         legend (num2strcell(ct(idx,3)))
%         grid on
%         hold off   
        
    end
    
end
