% AE6511 Hw4 Problem 4 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
syms A B t x t_f
p = A*exp(t) + B*exp(-t); 
%%
X(t) = -diff(p);
phi = 1/2 * (x - 1)^2;
%%
eqn1 = subs(p, t, t_f) == subs(subs(diff(phi, x), x, X), t, t_f)
eqn2 = subs(X, t, t_f) == subs(X, t, 0)
%%
sol = solve([eqn1 eqn2], [A B])
sol.A
sol.B
%%
A2 = subs(sol.A, t_f, 2)
B2 = subs(sol.B, t_f, 2)

X = subs(X, [A, B], [A2 B2]);
p = subs(p, [A B], [A2 B2]);
%%
TC = 1/2*(X(2) - 1)^2 
RC = 1/2 * int(X^2 + p^2, t, 0, 2)
J = TC + RC