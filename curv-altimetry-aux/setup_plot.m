%% Default setup to plot results of master's thesis
function setup_plot ()

c = [ 1    1    0
      0    1    0
      0    1    1
      0    0    1
      0    0    0
      1    0    0]; %y,g,c,b,k,r 
set(groot,'defaultAxesColorOrder',c)
set(groot,'defaultAxesFontSize',14)
set(groot,'DefaultLineLineWidth',2)