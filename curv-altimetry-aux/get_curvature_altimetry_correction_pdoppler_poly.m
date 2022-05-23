function dH = get_curvature_altimetry_correction_pdoppler_poly (e, Ha)

[size_e,~] = size(e);
[size_Ha,~] = size (Ha);

if size_e == size_Ha; e=e'; end

dHz = get_curvature_altimetry_correction_pdoppler_zenith_poly (Ha);
dHn = get_curvature_altimetry_correction_pdoppler_norm_poly (e);
dH = dHz.*dHn;