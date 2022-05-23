function setup_spherical_reflection ()
    persistent has_been_ran
    if isempty(has_been_ran),  has_been_ran = false;  end
    if has_been_ran,  return;  end
    addpath(genpath(pwd()))
    has_been_ran = true;
end

