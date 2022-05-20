close, clear all;
%% Setup the directory where the membrane object is located and add the directory to Matlab's function pool 
dir_mod = '/home2/s438167/module3_Noah';
addpath(dir_mod);
%--------------------------------------------------------------------------
% create 'unit' u using the unit module, and 'membrane' m using the membrane module 
rng(46);
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

t = 1500;

r=mean(sqrt(sum(m.var.coord(:,1).^2+m.var.coord(:,2).^2+m.var.coord(:,3).^2,2)));

%% Langevin equation
[m,stds,As,Vs, min_dts] = Run_iterations_LE(m, V0, k_c, k_a, k_v, k_r, t, delta_val, false, true);

%% Generate values for plotting
% Target values for plotting
A_zero = 4 * pi * r^2;
V_zero = 0.6 * 4/3*pi*r^3;
Vs = Vs/V_zero;
As = As/A_zero;
ts = linspace(1,t,t);
opt = ones(t,1);
H = Helfrich(m);

%% Plot results
fig=figure;
subplot(1,2,1);
plot(m,'f',fig, 'col', H, 'col_min', 0, 'col_max', max(H), 'colBar', true);
title("RBC after 1500 iterations");
subplot(1,2,2);
a = plot(ts, As); label1 = "A_t normalized by A_0"; hold on;
v = plot(ts, Vs); label2 = "V_t normalized by V_0"; hold on;
o = plot(ts, opt); label3 = "Optimal convergence"; hold on;
legend([a,v, o], [label1, label2, label3]);hold on;
ylim([0.4 1.6]);
title("Area and Volume in each iteration");
xlabel("t")
ylabel("Ratios of Area and Volume to the Optimal Value")

% filename = strcat(string(m.pm.k_c), '_', string(k_a), '_', string(k_v));
% filename = strcat(filename, '.png');
% saveas(fig,strcat('/home2/s438167/module3_Noah/outputs/', filename));

% serial = [440.207 465.532 448.396 466.266];
% parallel = [346.655 348.432 344.138 344.946];
% figure();
% boxplot(horzcat(serial.', parallel.'));
% ylabel("Time Elapsed")
% xlabel("Computation Method")
% xticklabels(["Serial" "Parallel"])
% title(["Speed comparison between serial and"," parallel computation of calculated_forces"], 'Interpreter', 'none');
