% AE6444 HW4 Problem 1 MATLAB 
% Tomoki Koike
close all; clear all; clc;
%%
% Define the system
syms x_1 x_2 Omega k m n l theta theta_dot
assume(n, {'integer', 'positive'});

T = 1/8*m*l^2*theta_dot^2*cos(theta)^2 + 1/8*m*l^2*Omega^2*sin(theta)^2;
V = 1/4*k*l^2 * (1 - cos(theta))^2;
L = T - V;

x1dot = x_2
x2dot = x_2^2 * tan(x_1) + Omega^2 * tan(x_1) - 2*k/m*(1-cos(x_1))*sec(x_1)*tan(x_1);
%%
% System matrix: A
a = diff(x1dot, x_1);
b = diff(x1dot, x_2);
c = diff(x2dot, x_1)
d = diff(x2dot, x_2)
A = [a, b; c, d];
%%
% Equilibrium points
x1e_1 = n*pi;
x1e_2 = acos(2*k / (2*k + m*Omega^2));
x2e = 0;
%%
% First possible solution
A1 = subs(A, [x_1, x_2], [x1e_1, x2e]);
A1_odd = subs(A1, n, 1)  % odd n value
A1_even = subs(A1, n, 2)  % even n value
%%
% Eigenvalues for first possible solution
[v_even, d_even] = eig(A1_even)
[v_odd, d_odd] = eig(A1_odd)
%%
% Second possible solution
A2 = simplify(subs(A, [x_1, x_2], [x1e_2, x2e]))
%%
% Eigenvalues for second possible solution
[v2, d2] = eig(A2)
%%
% Hamiltonian 

H = L - diff(L, theta_dot)*theta_dot;
%%
a_h = diff(diff(H, theta), theta_dot)
b_h = diff(diff(H, theta_dot), theta_dot)
c_h = -diff(diff(H, theta), theta)
d_h = -diff(diff(H, theta_dot), theta)
%%
p = a_h + d_h
q = a_h * d_h - b_h * c_h
%%
% (n\pi, 0)
subs(q, [theta, theta_dot], [1*pi, 0])
subs(q, [theta, theta_dot], [2*pi, 0])

% (<>, 0)
simplify(subs(q, [theta, theta_dot], [x1e_2, 0]))