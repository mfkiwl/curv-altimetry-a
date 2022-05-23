function [Di, g, Kz] = get_reflection_planar (e, Ha)
    g = e;
    Kz = 2*sind(g);
    Di = Ha.*Kz;    
end

