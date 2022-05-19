close, clear all;
%% Setup the directory where the membrane object is located and add the directory to Matlab's function pool 
dir_mod = '/home2/s438167/module3_Noah';
addpath(dir_mod);
%--------------------------------------------------------------------------
% create 'unit' u using the unit module, and 'membrane' m using the membrane module 
u=ComUnit('erg',ComUnit.nm_to_cm(1000),300,ComUnit.kBT_to_erg(10,300)); 
before_m=ModMembrane(2,'unit',u);
m = before_m;

%% Params
% Values for Forces
delta_val = 1e-4;

V0 = 0.02; %adjusting the internal force
k_c = 0.1; % 100 makes it elongate along x, 0.001 makes it dimple star
k_a = 0.5; % 5 flattens, 0.001 also elongate
k_v = 0.2; % 10 makes pointy % 0.1 makes concave
k_r = 0.0;

t = 3000;

r=mean(sqrt(sum(m.var.coord(:,1).^2+m.var.coord(:,2).^2+m.var.coord(:,3).^2,2)));

%% Langevin Equation
[m,stds,As,Vs,min_dts] = Run_iterations_LE(m, V0, k_c, k_a, k_v, k_r, t, delta_val, false);

%% Plot Before and after
fig=figure;
subplot(1,2,1);
plot(before_m,'f',fig);
subplot(1,2,2);
plot(m,'f',fig);

filename = strcat(string(m.pm.k_c), '_', string(k_a), '_', string(k_v));
filename = strcat(filename, '.png');
saveas(fig,strcat('/home2/s438167/module3_Noah/outputs/', filename));

% %% Plot edge length stds
% plot(linspace(1,t,t), stds, figure2);
% disp(std(stds(200:t)));
% % std after convergence == 0.0024
