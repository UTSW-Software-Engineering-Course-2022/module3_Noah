%% Define a perturbation function
function new_coords = perturbCoords(coord, idxs, percent_to_change)
    [theta, rho, r] = cart2sph(coord(:,1), coord(:,2), coord(:,3));
    pol_coords = [theta, rho, r];
    percent_up_and_down = [1-percent_to_change 1+percent_to_change];
    new_pol_coords = pol_coords;
    for i = 1:length(idxs)
        new_pol_coords(idxs(i),1) = pol_coords(idxs(i),1) * randsample(percent_up_and_down,1);
        new_pol_coords(idxs(i),2) = pol_coords(idxs(i),2) * randsample(percent_up_and_down,1);
    end
    
    [x, y, z] = sph2cart(new_pol_coords(:,1), new_pol_coords(:,2), new_pol_coords(:,3));
    new_coords = [x, y, z];
end