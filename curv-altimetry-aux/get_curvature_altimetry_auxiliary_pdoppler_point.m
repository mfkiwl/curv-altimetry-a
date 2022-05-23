function dH = get_curvature_altimetry_auxiliary_pdoppler_point (kind, e, Ha, type, e_amp, num_steps, varargin)
% GET_CURVATURE_ALTIMETRY_AUXILIARY_PDOPPLER_POINT Altimetry correction or retrieval for the
% Earth's curvature effect and pseudo-Doppler formulation (note: meant for 
% a single point or multiple independent points).
% 
% INPUT:
% - kind: 'retrieval' or 'correction' (char)
% - e: elevation angles (vector, in degrees)
% - Ha: antenna height (vector, in meters)
% - type: (char) type of altimetry correction for the Earth's curvature
%           'A': type-A correction for crossed pseudo-Doppler altimetry
%           'B': type-B correction for spherical pseudo-Doppler altimetry
% - varargin: optional input, see get_reflection_spherical for details.
%
% OUTPUT:
% - ou: altimetry correction or retrieval (vector, in meters)

    if (nargin < 4),  type = [];  end
    if (nargin < 5),  e_amp = [];  end
    if (nargin < 6),  num_steps = [];  end

    f = ['get_curvature_altimetry_' kind '_pdoppler_series'];

    siz = size(e);  n = prod(siz);
    if ~isscalar(Ha)  % independent points
        assert(isequal(size(Ha), siz));
        dH = NaN(siz);
        for i=1:n
            e_domi = get_elev_dom (e(i), e_amp, num_steps);
            dH_dom = feval(f, e_domi, Ha(i), type, varargin{:});
            dH(i) = dH_dom(e_domi==e(i));
            %dH(i) = nanmedian(dH_dom);  % WRONG! e_dom may not be centered.
        end
    else  % series of sat. elevations at the same ant. height
        % build neighboring domains around each requested elevation:
        [de_dom, num_steps] = get_delev_dom (e_amp, num_steps);
        e_dom_all = e(:) + de_dom(:).';
        e_dom_all = reshape(e_dom_all.', [n*(num_steps+1) 1]);
        %e_dom_all = unique(e_dom_all(:));
        e_dom_all(e_dom_all > 90) = [];
        
        % calculate for all points simultaneously:
        dH_dom_all = feval(f, e_dom_all, Ha, type, varargin{:});

        % retrieve the solution at the requested elevations:
        [ind, ind_all] = ismember(e(:), e_dom_all);
        dH = NaN(n, 1);
        dH(ind) = dH_dom_all(ind_all);
        dH = reshape(dH, siz);
    end
end

%%
% create a domain of elevations, centered if possible:
function e_dom = get_elev_dom (e, e_amp, num_steps)
    de_dom = get_delev_dom (e_amp, num_steps);
    e_dom = e + de_dom;
    e_dom(e_dom > 90) = [];  % avoid extrapolation
end

%%
% create a domain of elevation differencess, centered.
function [de_dom, num_steps] = get_delev_dom (e_amp, num_steps)
    if isempty(e_amp),  e_amp = 0.1;  end  % elev amplitude (scalar)
    if isempty(num_steps),  num_steps = 4;  end  % number of steps (scalar)
    de_dom_tmp = linspace(0, e_amp, round(num_steps/2)+1);
    de_dom = horzcat(-flip(de_dom_tmp(2:end)), de_dom_tmp);
end

