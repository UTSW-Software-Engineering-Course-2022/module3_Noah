clear, close all;

%% Setup the directory where the membrane object is located and add the directory to Matlab's function pool 
dir_mod = '/home2/s438167/module3_Noah';
addpath(dir_mod);
%--------------------------------------------------------------------------
% create 'unit' u using the unit module, and 'membrane' m using the membrane module 
u=ComUnit('erg',ComUnit.nm_to_cm(1000),300,ComUnit.kBT_to_erg(10,300)); 
m=ModMembrane(2,'unit',u);

%% Randomly perturb sphere
new_m = m;
rand_coords = randi([1 length(m.var.coord)],1,160);
percent_to_change = 0.05;
new_coords = perturbCoords(new_m.var.coord, rand_coords, percent_to_change);
new_m.var.coord = new_coords;

worse_m = m;
rand_coords = randi([1 length(m.var.coord)],1,160);
percent_to_change = 0.1;
worse_coords = perturbCoords(worse_m.var.coord, rand_coords, percent_to_change);
worse_m.var.coord = worse_coords;


%% Plot the results
% Calculate the h_diff
[H_diff, H_diff_new, H_diff_new_clipped] = get_H_diff(m, new_m);
[~, H_diff_worse, H_diff_worse_clipped] = get_H_diff(m, worse_m);

% Calculate the density
pts = linspace(0,1,1000); % points to evaluate the estimator

fig=figure;
subplot(2,2,1);
plot(m,'f',fig, 'col', H_diff, 'col_min', 0, 'col_max', max(H_diff), 'colBar', true);
title("Optimal Mesh")
subplot(2,2,2);
plot(new_m,'f',fig, 'col', H_diff_new_clipped, 'col_min', 0, 'col_max', max(H_diff_new_clipped), 'colBar', true);
title("Minor distortion")
subplot(2,2,3);
plot(worse_m,'f',fig, 'col', H_diff_worse_clipped, 'col_min', 0, 'col_max', max(H_diff_worse_clipped), 'colBar', true);
title("Significant distortion")
subplot(2,2,4);
ksdensity(H_diff, pts); hold on;
ksdensity(H_diff_new, pts); hold on;
ksdensity(H_diff_worse, pts);
lgd = legend('Optimal Mesh','Minor distortion', 'Significant distortion');
title("Probability Density of [0,1) Normalized delta H")
xlabel('[0,1) Normalized delta H')
ylabel("Density")
exportgraphics(fig,'/home2/s438167/module3_Noah/outputs/Figure1.png','Resolution',300)


