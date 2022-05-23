function dHn = get_curvature_altimetry_correction_pdoppler_norm_poly (e)


c0 = 7.23463328557479e-08;
c1 = -1.18071993546865e-05;
c2 = 0.000707682087746741;
c3 = -0.0203181878000224;
c4 = 0.329262624274052;
c5= -0.330164289939700;
x = 1./sind(e);

cn = c0*x.^5 + c1*x.^4 + c2*x.^3 + c3*x.^2 + c4*x + c5;

dHn = 10.^cn;