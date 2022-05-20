function [m,stds,As,Vs, min_dts] = Run_iterations_LE(m, V0, k_c, k_a, k_v, k_r, t, delta_val, save, par)

    r=mean(sqrt(sum(m.var.coord(:,1).^2+m.var.coord(:,2).^2+m.var.coord(:,3).^2,2)));

    m.pm.Vdh.V0 = V0;
    m.pm.k_c = k_c;
    
    [Fi] = Finternal(m);
    
    % keep track
    stds = NaN(t,1);
    min_dts = NaN(t,1);
    As = NaN(t,1);
    Vs = NaN(t,1);
    
    % Parallel computing
    if par
        p = gcp();
        M = p.NumWorkers;
        fprintf("Running parallel with %d workers\n", M)
    else
        M = 0;
        disp("Running serial")
    end

    for i = 1:t
        X = sprintf('Running time step %d',i);
        disp(X);
        
        As(i,1) = sum(Area(m),1);
        Vs(i,1) = sum(Volume(m),1);

        [L, L_edge_all, dir_ij] = compute_L_and_dir_ij(m);

        std_edge_l = std(L_edge_all,1);
        stds(i) = std_edge_l;
        Y = sprintf('Std of edge length %d',std_edge_l);
        disp(Y);

        % Calc Forces
        [F_tot, X_int_mtx] = compute_F_tot(m,Fi,dir_ij,L);
        [F_b, F_a, F_v] = calculate_forces(m, delta_val, k_a, k_v, r, M);
        F_r = k_r * randn(m.var.n_coord, 3); 
        F_tot = (F_tot + F_r + F_b + F_a + F_v);
        min_dt = calculate_delta_t(m,Fi,F_tot,L, X_int_mtx);
        min_dts(i,1) = min_dt;
        
        m.var.coord = m.var.coord + m.pm.mu * F_tot * min_dt;

        rLim=[min(Fi.rg),max(Fi.rg)];
        [m] = RemeshCtrl(m,Fi,rLim);

        if save == true
            if mod(i,500) == 0

               h = figure;
               plot(m,'f',h);
               savefig(h, strcat('/home2/s438167/module3_Noah/outputs/iteration_', string(i),'.fig'))

            end
        end
        
    end    



end