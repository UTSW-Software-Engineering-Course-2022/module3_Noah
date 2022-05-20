% Run RBC parallel

% params
delta_val = 1e-4;
V0 = 0.02;
k_c = 0.1; 
k_a = 0.5;
k_v = 0.2; 
k_r = 0.0;
t = 1500;
rng(46);

% num rbc
n = 4;

u=ComUnit('erg',ComUnit.nm_to_cm(1000),300,ComUnit.kBT_to_erg(10,300)); 

RBCs = cell(n,1);

for i = 1:n
    RBCs{i} = RBC(ModMembrane(2,'unit',u));
end

parfor i = 1:n
    RBCs{i} = computeRBC(RBCs{i}, V0, k_c, k_a, k_v, k_r, t, delta_val, false, false);
end

%% Plot 4 results
fig=figure;
subplot(2,2,1);
plot(RBCs{1}.m,'f',fig);
title("RBC 1")
subplot(2,2,2);
plot(RBCs{2}.m,'f',fig);
title("RBC 2")
subplot(2,2,3);
plot(RBCs{3}.m,'f',fig);
title("RBC 3")
subplot(2,2,4);
plot(RBCs{4}.m,'f',fig);
title("RBC 4")