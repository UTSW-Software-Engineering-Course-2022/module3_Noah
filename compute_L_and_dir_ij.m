%% Compute Squareform L, L in edge_all order, and dir_ij in edge_all order
function [L, L_edge_all, dir_ij] = compute_L_and_dir_ij(m)
    % Compute the pairwise dist
    eucdist = pdist(m.var.coord);
    L = squareform(eucdist);

    % L in the format of m.var.edge_all, where the ith index of L represents
    % the length between m.var.edge_all(i,1) and m.var.edge_all(i,2)
    L_edge_all = NaN(length(m.var.edge_all),1);

    % Direction of ij, in the order of m.var.edge_all
    dir_ij = NaN(length(m.var.edge_all),3);
    for i = 1:length(m.var.edge_all)
        % Populate L_edge_all using the index in edge_all first and second
        % columns
        L_edge_all(i,1) = L(m.var.edge_all(i,1),m.var.edge_all(i,2));
        % r_j-r_i/l
        dir_ij(i,:) = ((m.var.coord(m.var.edge_all(i,2),:)) - m.var.coord(m.var.edge_all(i,1),:))/L_edge_all(i,1) ;
    end
end