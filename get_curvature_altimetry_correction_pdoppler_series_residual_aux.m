function [dH, k, dk] = get_curvature_altimetry_correction_pdoppler_series_residual_aux (DH, rH)
    dH = rH - DH;  % residual altimetry correction
    k = rH./DH;  % residual height factor
    dk = k - 1;  % residual height factor change
end

