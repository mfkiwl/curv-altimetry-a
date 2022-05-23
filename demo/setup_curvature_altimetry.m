function setup_curvature_altimetry ()
    persistent has_been_ran
    if isempty(has_been_ran),  has_been_ran = false;  end
    if has_been_ran,  return;  end
    %addpath(genpath(pwd()))
    dir = pwd();
    if strcmpi(dir(end-3:end), 'demo')
      dir = fullfile(dir, '..');  % go up one level.
    end
    addpath(genpath(dir))
    has_been_ran = true;
end

