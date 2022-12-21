% ME 6444 HW3 Problem 2 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
% Declare and solve necessary conditions
syms gamma(epsilon) epsilon(v) v(x, t)  
syms rho A E_1 E_2 alpha T_0 l 

v_x = diff(v, x);
v_xx = diff(v_x, x);
v_t = diff(v, t);
v_tt = diff(v_t, t);
%%
epsilon = v_x^2/2
gamma = T_0 + E_1*A*epsilon + E_2*A*epsilon^2 + alpha*A*diff(epsilon, t)
v_eom = rho*A*v_tt - diff(gamma, x) * v_x - gamma * v_xx
%%
syms phi_1(x) phi_2(x) beta_1(t) beta_2(t) v_tilde(x, t)

phi_1(x) = sin(pi*x/l);
phi_2(x) = sin(2*pi*x/l);
v_tilde(x, t) = beta_1(t) * phi_1(x) + beta_2(t) * phi_2(x);
%%
gamma_tilde = subs(gamma, v, v_tilde)
%%
r_tilde(x, t) = subs(v_eom, [v, gamma], [v_tilde, gamma_tilde])
%%
EOM1 = int(r_tilde(x, t) * phi_1(x), x, 0, l) == 0
EOM2 = int(r_tilde(x, t) * phi_2(x), x, 0, l) == 0