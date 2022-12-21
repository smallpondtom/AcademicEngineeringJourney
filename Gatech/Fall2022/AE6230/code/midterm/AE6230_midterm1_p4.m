% AE6230 Midterm 1 Problem 4
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% (1)
syms m omega_n F_0 T_1 T_2 tau t real positive
F1(tau) = F_0/T_1*tau;
h(tau) = sin(omega_n*(t-tau));
xp1(t) = int(F1*h/m/omega_n,tau,0,t);
xp1(t) = simplify(expand(xp1));

%% (2)
F2 = -(T_1+T_2)*F_0/T_1/T_2*tau + (T_1+T_2)*F_0/T_2;
xp2(t) = int(F2*h/m/omega_n,tau,T_1,t);
xp2(t) = simplify(expand(xp2));

%% (3)
F3 = F_0/T_2*tau - (T_1+T_2)*F_0/T_2;
xp3(t) = int(F3*h/m/omega_n,tau,T_1+T_2,t);

%% 
xp_seg1 = xp1;
xp_seg2 = xp1 + xp2;
xp_seg3 = xp1 + xp2 + xp3;

simplify(expand(xp_seg2));
simplify(expand(xp_seg3));