% AE6230 HW1 Problem 3
% Author: Tomoki Koike

%% Housekeeping commands


clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% ODE solve

syms z(t) 
syms omega_n Z_r omega g real
zdot = diff(z,t);
zddot = diff(zdot, t);
ode = zddot + omega_n^2*z == -Z_r*omega^2*cos(omega*t) + g;
cond1 = z(0) == 0;
cond2 = zdot(0) == 0;
cond = [cond1, cond2];
zsol(t) = dsolve(ode,cond)
simplify(zsol)