function [delay, graz_ang, arc_len, slant_dist, x_spec, y_spec, x_trans, y_trans, elev_spec] = get_spherical_reflection (e, Ha, Ht, Rs, algorithm, trajectory, frame)
% GET_SPHERICAL_REFLECTION  Calculates specular reflection on spherical surface.
%
% INPUT:
% - e: elevation angles (matrix; in degrees) 
% - Ha: antenna height (matrix; in meters)
% Notes: 
% - elevation angle is define zero at zenith
% - matrix input may also be a vector or a scalar
% - non-scalar input must have the same size
% 
% OUTPUT:
% - delay: interferometric propagation delay on spherical surface (matrix, in meters)
% - graz_ang: grazing angle of spherical reflection that satisfies Snell's law (matrix, in degrees)
% - arc_len: arc lenght between subreceiver point and reflection point (matrix, in meters)
% - slant_dist: slant distance between receiver and reflection point (matrix, in meters)
% - x_spec, y_spec: reflection point coordinates (matrices, in meters)
% - x_trans, y_trans: transmitter point coordinates (matrices, in meters)
% - elev_spec: elevation angle from antenna to reflection point (matrix, in degrees)
% - delay_trig: trigonometric formulation of interferometric propagation delay (matrix, in meters)
% Note: output will be a matrix of the same size as input.
% 
% OPTIONAL INPUT
% - Ht: Transmitter/satelitte height (scalar, in meters)
% - Rs: Earth surface radius (scalar, in meters)
% - algorithm: (char), see source code for details
%   'fujimura'
%   'martin-neira'
%   'miller&vegh'
%   'helm'
%   'fermat'
%   'itu' (under research)
%   'line-sphere fermat' (under research)
%   'circle inversion' (under research)
% - trajectory: (char), see source code for details
%   'orbital'  % orbital trajectory (constant geocentric distance)
%   'horizontal'  % horizontal trajectory (constant y-axis coordinate)
%   'circular'  % circular trajectory around the receiving antenna (constant direct distance)
% - frame: (char) coordinate reference frame ('local' - default - or 'quasigeo')

    if (nargin < 1),  e = [];  end
    if (nargin < 2),  Ha = [];  end
    if (nargin < 3),  Ht = [];  end
    if (nargin < 4),  Rs = [];  end
    if (nargin < 5),  algorithm = [];  end
    if (nargin < 6),  trajectory = [];  end
    if (nargin < 7),  frame = [];  end

    if isempty(e),   e  = 45;  end
    if isempty(Ha),  Ha = 10;  end
    if isempty(Ht),  Ht = get_satellite_height();  end
    if isempty(Rs),  Rs = get_earth_radius();  end
    if isempty(algorithm),  algorithm = 'fujimura';  end
    if isempty(trajectory),  trajectory = 'orbital';  end
    if isempty(frame),  frame = 'local';  end

    %% Check input size compatibility:
    assert(isscalar(Ht))
    assert(isscalar(Rs))
    siz = size(e);  e = e(:);  n = prod(siz);
    siz2 = size(Ha);  Ha = Ha(:);  n2 = prod(siz2);
    assert(n2==1 || (n2==n && isequal(siz2, siz)))
    %assert(isscalar(Ha) || isequal(size(Ha), size(e)))

    %% Select algorithm
    switch lower(algorithm)
        case {'fujimura'}
            f = @get_reflection_spherical_fujimura;
        case {'miller','miller&vegh','millerandvegh'}
            f = @get_reflection_spherical_miller;
        case {'martinneira','martin-neira'}
            f = @get_reflection_spherical_martinneira;
        case {'helm'}
            f = @get_reflection_spherical_helm;
         case {'fermat','numerical'}
            f = @get_reflection_spherical_fermat;
        otherwise
            error('Unknown algorithm "%s"', char(algorithm));
    end

    %% Get ancillary results:
    Hts = get_satellite_trajectory (e, Ha, Ht, Rs, trajectory);
    ehor = get_horizon_elevation_angle (Ha, Rs);
    
    %% Pre-allocate memory:
    temp = NaN(n,1);
    graz_ang  = temp;
    geo_ang   = temp;
    x_spec    = temp;
    y_spec    = temp;
    x_trans   = temp;
    y_trans   = temp;

    %% Run selected algorithm
    i2 = 1;
    for i=1:n
        if (n2>1),  i2 = i;  end
        if (e(i) < ehor(i2)),  continue;  end
        [graz_ang(i), geo_ang(i), x_spec(i), y_spec(i), x_trans(i), y_trans(i)] = f(...
            e(i), Ha(i2), Hts(i), Rs);        
    end

    %% Additional parameters
    [delay, arc_len, slant_dist, elev_spec] = get_spherical_reflection_extra (...
        n2, Ha, Rs, geo_ang, x_spec, y_spec, x_trans, y_trans);

    %% Reshape output matrices as in input matrices:
    delay = reshape(delay, siz);
    graz_ang = reshape(graz_ang, siz);
    arc_len = reshape(arc_len, siz);
    slant_dist = reshape(slant_dist, siz);
    x_spec = reshape(x_spec, siz);
    y_spec = reshape(y_spec, siz);
    x_trans = reshape(x_trans, siz);
    y_trans = reshape(y_trans, siz);
    elev_spec = reshape(elev_spec, siz);

    %% Optionally, convert from reference frame:
    if strcmpi(frame, 'local'),  return;  end
    [x_spec, y_spec] = get_quasigeo_coord (x_spec, y_spec, Rs);
    [x_trans, y_trans] = get_quasigeo_coord (x_trans, y_trans, Rs);    
end

%%
function [delay, arc_len, slant_dist, elev_spec] = get_spherical_reflection_extra (n2, Ha, Rs, geo_ang, x_spec, y_spec, x_trans, y_trans)

    % Arc Length from subreceiver point to reflection point:
    arc_len = deg2rad(geo_ang)*Rs;

    % Receiving antenna position vector in local frame:
    pos_ant = [zeros(n2,1) Ha]; 

    % Relative position vectors:
    pos_spec = [x_spec(:) y_spec(:)];
    pos_trans = [x_trans(:) y_trans(:)];
    pos_trans_spec = pos_trans - pos_spec;
    pos_ant_spec   = pos_ant   - pos_spec;
    pos_ant_trans  = pos_ant   - pos_trans;

    % Slant distance from reflection point to receiver:
    slant_dist = norm_all(pos_ant_spec);

    % Interferometric propagation delay:
    delay_direct = norm_all(pos_ant_trans);
    delay_reflect_inc = norm_all(pos_trans_spec);
    delay_reflect_out = norm_all(pos_ant_spec);
    delay_reflect = delay_reflect_inc + delay_reflect_out;
    delay = delay_reflect - delay_direct;

    % Reflection elevation angle:
    dir_rec_spec = pos_ant_spec./delay_reflect_out;
    dir_vert = [0 1];
    elev_spec = -90 + acosd(dot_all(-dir_vert, -dir_rec_spec));
    debugit = 0;
    if debugit
      elev_specb = e - 2*graz_ang;
      elev_specb(e==90) = -90;
      fpk e erb-elev_spec  % DEBUG
    end

end

%%
function Hts = get_satellite_trajectory (e, Ha, Ht, R0, trajectory)
    assert(isvector(Ha))
    assert(isscalar(Ht))
    %n = numel(Ha);  % WRONG!
    n = numel(e);

    %% initial positions
    if isscalar(Ha)
        pos_ant  = [0 Ha]; %Antenna position
    else
        siz = size(Ha);
        Ha = Ha(:);
        zero = zeros(siz);
        pos_ant  = [zero Ha]; %Antenna position
    end
    pos_foot = [0 0];  %Antenna's foot in local frame (origin of local frame)
    pos_geo  = [0 -R0];  % Quasigeocentric origin
    pos_foot_geo = pos_foot - pos_geo; % Antenna's foot in quasigeocentric frame

    %% transmitting satellite's trajectory:
    switch lower(trajectory)
        case 'orbital'  % orbital trajectory (constant geocentric distance)
            Hts = repmat(Ht, [n 1]);
        case 'horizontal'  % horizontal trajectory (constant y-axis coordinate)
            vert_dist = (Ht-Ha).*ones(n,1);
            horiz_dist = vert_dist.*cotd(e(:));
            pos_trans_ant = [horiz_dist vert_dist];
            pos_trans = pos_ant + pos_trans_ant;
            pos_trans_geo = pos_trans + pos_foot_geo;
            Hts = norm_all(pos_trans_geo);
        case 'circular'  % circular trajectory around the receiving antenna (constant direct distance)
            %pos_trans = Ht.*[cosd(e), sind(e)];  % WRONG!
            direct_dist = Ht - Ha;
            pos_trans_ant = direct_dist.*[cosd(e(:)), sind(e(:))];
            pos_trans = pos_ant + pos_trans_ant;
            pos_trans_geo = pos_trans + pos_foot_geo;
            Hts = norm_all(pos_trans_geo);
        otherwise
            error('Unknown transmitting satellite trajectory "%s".', char(trajectory))
    end

end

