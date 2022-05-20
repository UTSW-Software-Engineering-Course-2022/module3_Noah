function [F_b, F_a, F_v] = calculate_forces(m, delta_val, k_a, k_v, r, M)
    
    F_b = NaN(m.var.n_coord,3);    
    F_v = NaN(m.var.n_coord,3);
    F_a = NaN(m.var.n_coord,3);
    
    % H
    H = Helfrich(m);
    H_tot = sum(H,1);
    
    % A
    A = Area(m);
    A_tot = sum(A,1);
    A_zero = 4 * pi * r^2;
    E_a = k_a * (A_tot - A_zero)^2 / A_zero;
    
    % V
    V = Volume(m);
    V_tot = sum(V,1);
    V_zero = 0.6 * 4/3*pi*r^3;
    E_v = k_v * (V_tot - V_zero)^2 / V_zero;
    
    % for each dimension, x, y, z
    for dim = 1:3
        
        % perturb vertex
        parfor (i = 1:m.var.n_coord,M)
            
            % reset coord
            m_par = m;
            
            % perturb vertex
            m_par.var.coord(i,dim) = m_par.var.coord(i,dim) + delta_val;
            
            % H
            H_perturb = Helfrich(m_par);
            H_tot_perturb = sum(H_perturb,1);
            F_b(i,dim) = -(H_tot_perturb - H_tot) / delta_val;
            
            % A
            A_perturb = Area(m_par);
            A_tot_perturb = sum(A_perturb,1);
            delta_E_a =  (k_a * (A_tot_perturb - A_zero)^2 / A_zero) - E_a;
            F_a(i,dim) = -(delta_E_a) / delta_val;
            
            % V
            V_perturb = Volume(m_par);
            V_tot_perturb = sum(V_perturb,1);
            delta_E_v =  (k_v * (V_tot_perturb - V_zero)^2 / V_zero) - E_v;
            F_v(i,dim) = -(delta_E_v) / delta_val;
            
            
            
        end
    end

end