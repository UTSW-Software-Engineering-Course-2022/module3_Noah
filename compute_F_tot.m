%% get F_tot
function [F_tot, X_int_mtx] = compute_F_tot(m,Fi,dir_ij,L)
    F_tot = NaN(m.var.n_coord,3);
    % get matrix of X_int for our current subset
    X_int_mtx = calculate_X_int(m.var.edge_all, L, Fi);
    f_l_mtx = Fi.fn(X_int_mtx);
    
    for i = 1:m.var.n_coord

        % get where edge_all contains i
        idx = m.var.edge_all == i;
        % sum row and get rows to keep
        idx_rows_to_keep = logical(sum(idx,2));
        % subset edge, dir_ij, idx
        subset_dir_ij = dir_ij(idx_rows_to_keep,:);
        idx_dir_switch = idx(idx_rows_to_keep,1);

        % switch sign if i is in first column of dir_ij
        subset_dir_ij(idx_dir_switch,:) = subset_dir_ij(idx_dir_switch,:) * -1;
        
        % Calculate f(l)
        f_l = f_l_mtx(idx_rows_to_keep,:);
    
        % Placeholder to sum up column wise later
        to_sum = NaN(length(subset_dir_ij), 3);
        
        for j = 1:length(subset_dir_ij)
            % Populate the result of f_l and dir_ij of this subset
            to_sum(j,:)=f_l(j,:).*subset_dir_ij(j,:); %multiplies rows
        end
        
        % Assign the sum to the F_tot
        F_tot(i,:) = sum(to_sum, 1);

    end
end