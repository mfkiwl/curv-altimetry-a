function Kz = get_vertical_sensitivity (g)

% g is the grazing angle. If you consider a planar surface, grazing angle
% is the elevation angle

    Kz = 2.*sind(g);

end