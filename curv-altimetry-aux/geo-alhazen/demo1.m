setup_spherical_horizon () % Initial setup

%% Input values
Has = [10 50 100 200 300 500 1000];
ehors = get_spherical_reflection_horizon_elev (Has); % Minimum elevation angle
algs = {'fujimura','martinneira','helm','millerandvegh','fermat'};
frame = 'quasigeo';

%% Pre-allocate data
n = numel(Has);
m = numel(algs);
tmp = NaN(n,m);
Di = tmp;
g = tmp;
arclen = tmp;
sldist = tmp;
xspec = tmp;
yspec = tmp;

%% Computation of parameters for each algorithm
for i=1:m
    algorithm = algs{i};
    [Di(:,i), g(:,i), arclen(:,i), sldist(:,i), X_spec(:,i), Y_spec(:,i)]...
            = get_reflection_spherical (ehors(:), Has(:), [], [], algorithm, [], frame);
end

%% Expected values on spherical horizon
[Diref, gref, arclenref, sldistref, X_specref, Y_specref] ... 
                   = get_spherical_horizon_params (Has(:), [], frame);

%% Differences from expectation
dif_Di = Di - Diref;
dif_g = g - gref;
dif_X = X_spec - X_specref;
dif_Y = Y_spec - Y_specref;
dif_sd = sldist - sldistref;
dif_al = arclen - arclenref;

%% RMSE
rmse (1,:) = sqrt (sum(dif_g,1).^2 /numel(Has));
rmse (2,:) = sqrt (sum(dif_Di,1).^2/numel(Has));
rmse (3,:) = sqrt (sum(dif_X,1).^2./numel(Has));
rmse (4,:) = sqrt (sum(dif_Y,1).^2 /numel(Has));
rmse (5,:) = sqrt (sum(dif_sd,1).^2/numel(Has));
rmse (6,:) = sqrt (sum(dif_al,1).^2/numel(Has));

%% Tables

% Parameters
tbl_Di = array2table (Di, 'VariableNames',algs);
tbl_g = array2table (g, 'VariableNames',algs);
tbl_X = array2table (X_spec, 'VariableNames',algs);
tbl_Y = array2table (Y_spec, 'VariableNames',algs);
tbl_sd = array2table (sldist, 'VariableNames',algs);
tbl_al = array2table (arclen, 'VariableNames',algs);

% Differences from expectation
tbl_dDi = array2table (dif_Di, 'VariableNames',algs);
tbl_dg = array2table (dif_g, 'VariableNames',algs);
tbl_dX = array2table (dif_X, 'VariableNames',algs);
tbl_dY = array2table (dif_Y, 'VariableNames',algs);
tbl_dsd = array2table (dif_sd, 'VariableNames',algs);
tbl_dal = array2table (dif_al, 'VariableNames',algs);

% RMSE
tbl_rmse = array2table (rmse, 'VariableNames',algs, ...
                        'RowNames',{'Graz. angle','Delay','X coord.','Y coord.','Slant dist.','Arc Len.'});
