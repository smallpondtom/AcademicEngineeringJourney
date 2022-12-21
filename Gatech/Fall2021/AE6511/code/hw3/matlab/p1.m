% AE6511 Hw3 Problem 1 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
syms a x(t) 

F = -a^2 * x^2 + diff(x, t)^2
J = int(F, t, 0, 1)
%%
syms m
assume(m, {'real', 'positive'})
subs(J, x, t*(1-t))
subs(J, x, t^m * (1-t))
subs(J, x, sin(pi*t))