close, clear all;
%% Setup the directory where the membrane object is located and add the directory to Matlab's function pool 
dir_mod = '/home2/s438167/module3_Noah';
addpath(dir_mod);
%--------------------------------------------------------------------------
% create 'unit' u using the unit module, and 'membrane' m using the membrane module 
u=ComUnit('erg',ComUnit.nm_to_cm(1000),300,ComUnit.kBT_to_erg(10,300)); 
before_m=ModMembrane(2,'unit',u);

%% Distort
m = before_m;
% rand_coords = randi([1 length(m.var.coord)],1,160);
% percent_to_change = 0.05;
% coords = perturbCoords(m.var.coord, rand_coords, percent_to_change);
% m.var.coord = coords;
% 
% before_m = m;

%% Langevin Propagation
m.pm.Vdh.V0=0.02; %adjusting the internal force
[Fi] = Finternal(m);

% Do timesteps
t = 1000;

% generate random force
k_r = 0;
F_r = k_r * randn(m.var.n_coord, 3); % (163, 3)

% keep track of std
stds = NaN(t);

for i = 1:t
    X = sprintf('Running time step %d',i);
    disp(X)
    [L, L_edge_all, dir_ij] = compute_L_and_dir_ij(m);
    std_edge_l = std(L_edge_all);
    stds(i) = std_edge_l;
    Y = sprintf('Std of edge length %d',std_edge_l);
    disp(Y)
    [F_tot, X_int_mtx] = compute_F_tot(m,Fi,dir_ij,L);
    min_dt = calculate_delta_t(m,Fi,F_tot,L);
    m.var.coord = m.var.coord + m.pm.mu * (F_tot + F_r) * min_dt;
end    

%% Plot Before and after
fig=figure;
subplot(1,2,1);
plot(before_m,'f',fig);
subplot(1,2,2);
plot(m,'f',fig);

%% Plot edge length stds
plot(linspace(1,t,t), stds)