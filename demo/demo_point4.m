setup_curvature_altimetry()

%%
Ha = [10 50 100 200 300 500 1000];

num_heights = numel(Ha);
num_elevs = num_heights;

e = randint(0, 90, [1 num_elevs]);


%%
dH = get_curvature_altimetry_correction_pdoppler_point (e, Ha);

%%
disp([e(:) Ha(:) dH(:)])

