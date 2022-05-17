%% Define H_diff function
function [H_diff, H_diff_new, H_diff_new_clipped] = get_H_diff(m, new_m)
    new_m.pm.k_c = 10;
    m.pm.k_c = 10;
    H_temp_new_m = Helfrich(new_m);
    H_temp_m = Helfrich(m);
    H_ideal = (8 * pi * new_m.pm.k_c)/m.var.n_coord;

    H_diff = abs(H_temp_m - H_ideal);
    H_diff = (H_diff - min(H_diff)) / ( max(H_diff) - min(H_diff) );

    % Clip the values if higher than 50 percent change
    H_temp_new_clipped = H_temp_new_m;
    H_temp_new_clipped(H_temp_new_clipped > H_ideal * 1.5) = H_ideal * 1.5;
    H_temp_new_clipped(H_temp_new_clipped < H_ideal * 0.5) = H_ideal * 0.5;

    H_diff_new = (H_temp_new_m - H_ideal);
    H_diff_new = H_diff_new/H_ideal;
    H_diff_new = (H_diff_new - min(H_diff_new)) / ( max(H_diff_new) - min(H_diff_new) );
    
    H_diff_new_clipped = (H_temp_new_clipped - H_ideal);
    H_diff_new_clipped = H_diff_new_clipped/H_ideal;
    H_diff_new_clipped = (H_diff_new_clipped - min(H_diff_new_clipped)) / ( max(H_diff_new_clipped) - min(H_diff_new_clipped) );

end