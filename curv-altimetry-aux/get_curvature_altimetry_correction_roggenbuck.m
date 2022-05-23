function cor_Roggenbuck = get_curvature_altimetry_correction_roggenbuck (e, Ha, Rs)

% GET_CURVATURE ALTIMETRY returns an approximate altimetry correction based on
% Roggenbuck and Reinking (2019)

if (nargin < 3)||isempty(Rs);  Rs = get_earth_radius();  end

cor_Roggenbuck = Ha.^2.*(1./(2*Rs.*tand(e).^2));