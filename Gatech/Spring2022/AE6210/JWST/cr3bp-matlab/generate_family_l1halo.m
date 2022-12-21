%% Construct family of halo around EML1
% Yuri Shimane, 2022/02/15
% Generate family of EML1 halo orbits. 
% The generated csv file is a 7xN matrix, where each COLUMN corresponds to
% a solution. The first 6 entries are [x,y,z,vx,vy,vz], and the 7th entry 
% is the period.
% All quantities are in canonical units. To obtain dimensional quantities,
% (km, seconds, and km/sec), multiply distance by param.Lstar, time by 
% param.Tstar, and velocity by param.Vstar. 

% house keep
clear; close all; clc;

% define CR3BP parameter
defineParam_EarthMoon;

% ... choose in-plane phase angle
phi = 0;  % 0 or pi
% ... choose collinear Lagrangan point (1,2, or 3)
lp = 1;
% ... choose northern or southern family
northsouth = 1;  % n = 1 or 3
% ... choose out-of-plane altitude of halo-orbit [km]
Az_km = 12000; 

% construct Halo orbit
tolDC = 1e-11;
[x0_lpo, period] = ...
    collinearHalo(param.mu,param.Lstar,phi,lp,northsouth,Az_km,tolDC);

% continue in period-decreasing direction
dperiod = -0.0002;  % variation in period at each iteration
nmax = 500;
sols1 = npc_period(x0_lpo, period, param.mu, dperiod, nmax, tolDC);

% continue in period-decreasing direction
dperiod = 0.0002;  % variation in period at each iteration
nmax = 500;
sols2 = npc_period(x0_lpo, period, param.mu, dperiod, nmax, tolDC);

%% combine solutions
sols_unsorted = horzcat(sols1, sols2,vertcat(x0_lpo,period));
sols = sortrows(sols_unsorted',7)';
writematrix(sols,"EML1_halo_northern.csv");

%% Test load function
clear sols;
sols = readmatrix("EML1_halo_northern.csv");

%% plot results
figure(1)
plot3(param.LP(lp,1),param.LP(lp,2),param.LP(lp,3),'xk');
hold on;
[~,nsol] = size(sols);
for i = 1:nsol
    reltol = 1.e-12;
    abstol = 1.e-13;
    sol = propagate_cr3bp(sols(1:6,i), [0 sols(7,i)], param.mu, reltol, abstol);
    plot3(sol.y(1,:), sol.y(2,:), sol.y(3,:),'-b','LineWidth',0.5);
end
% first one
sol = propagate_cr3bp(x0_lpo, [0 period], param.mu, reltol, abstol);
plot3(sol.y(1,:), sol.y(2,:), sol.y(3,:),'-r','LineWidth',1.5);
grid on;
xlabel('x'); ylabel('y'); zlabel('z');