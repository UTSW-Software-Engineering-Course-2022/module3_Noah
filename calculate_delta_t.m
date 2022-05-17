%% Calculate dt
function min_dt = calculate_delta_t(m,Fi,F_tot,L)
    
    dt_mtx = NaN(length(m.var.edge_all),1);
    dr = Fi.rn(2) - Fi.rn(1);
    
    for edge = 1:length(m.var.edge_all)

        i = m.var.edge_all(edge,1);
        j = m.var.edge_all(edge,2);
        i_coord = m.var.coord(m.var.edge_all(edge,1),:);
        j_coord = m.var.coord(m.var.edge_all(edge,2),:);

        X_int = floor(L(i,j)/dr + 0.5) - floor(Fi.rn(1)/dr+0.5);

        l_plus_num = (0.5 * (Fi.rg(Fi.in(X_int)) + Fi.rg(Fi.in(X_int)+1)))^2 - L(i, j)^2;
        l_minus_num = (0.5 * (Fi.rg(Fi.in(X_int)-2) + Fi.rg(Fi.in(X_int)-1)))^2 - L(i, j)^2;
        denom = 2 * m.pm.mu * dot((j_coord- i_coord) , (F_tot(j,:) - F_tot(i,:)));
        
        dt_plus = l_plus_num / denom ;
        dt_minus = l_minus_num / denom ;
        
        dt = 0.0;
        if dt_plus > 0
            dt = dt_plus;
        else
            dt = dt_minus;
        end

        dt_mtx(edge,1) = dt;
    end
    min_dt = min(dt_mtx);

end