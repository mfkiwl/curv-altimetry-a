setup_curvature_altimetry()

%% 
%#ok<*NOPTS>

Ha = 10 

e = 45

dH = get_curvature_altimetry_correction_pdoppler_point (e, Ha)
H = get_curvature_altimetry_retrieval_pdoppler_point (e, Ha)
