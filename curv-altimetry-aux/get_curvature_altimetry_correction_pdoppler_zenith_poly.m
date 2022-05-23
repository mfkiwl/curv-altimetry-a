function dHz = get_curvature_altimetry_correction_pdoppler_zenith_poly (Ha)

% Ha = antenna height (in meters)

cz = -25.5869404721825;
dHz = (cz.*(Ha./1000).^2)./100;