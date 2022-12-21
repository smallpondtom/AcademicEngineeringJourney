%% Construct one halo orbit
% Yuri Shimane, 2022/02/15

% house keep
% clear; close all; clc;

% define CR3BP parameter
defineParam_SunEarth;

%% Halo construction (orbit 1)
% ... choose in-plane phase angle
phi = pi;  % 0 or pi
% ... choose collinear Lagrangan point (1,2, or 3)
lp = 2;
% ... choose northern or southern family
northsouth = 3;  % n = 1 or 3
% ... choose out-of-plane altitude of halo-orbit [km]
Az_km = 4E+05; 

% construct Halo orbit
tolDC = 1e-12;
[x0_lpo, period] = ...
    collinearHalo(param.mu,param.Lstar,phi,lp,northsouth,Az_km,tolDC);

% propagate final result for plotting
reltol = 1.e-12;
abstol = 1.e-13;
sol = propagate_cr3bp(x0_lpo, [0 period], param.mu, reltol, abstol);

% plot result
figure(1)
plot3(param.LP(lp,1),param.LP(lp,2),param.LP(lp,3),'xk');
hold on;
plot3(sol.y(1,:), sol.y(2,:), sol.y(3,:),'-b','LineWidth',1.5);
grid on;
xlabel('x'); ylabel('y'); zlabel('z');
title(['Sun-Earth Halo']);


