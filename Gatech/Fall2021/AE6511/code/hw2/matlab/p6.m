% Problem 6 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
syms x_1 x_2 x_3
f = (400*x_1 + 360*(200 - x_1) + 550*x_2 ...
    + 470*(360 - x_2) + 600*x_3 + 500*(340 - x_3));
f_s = simplify(f)
%%
% Initialize LP problem
x1 = optimvar('x1');
x2 = optimvar('x2');
x3 = optimvar('x3');
prob = optimproblem('Objective', 40*x1 + 80*x2 + 100*x3 + 411200, ...
    'ObjectiveSense', 'minimize');
prob.Constraints.c1 = x1 + x2 + x3 == 500;
prob.Constraints.c2 = x1 >= 0;
prob.Constraints.c3 = x2 >= 0;
prob.Constraints.c4 = x3 >= 0;
prob.Constraints.c5 = 200 - x1 >= 0;
prob.Constraints.c6 = 360 - x2 >= 0;
prob.Constraints.c7 = 340 - x3 >= 0;
options = optimoptions(prob);
options.Display = 'iter';
%%
% Solve
[sol, fval, exitflag, output] = solve(prob, 'Options', options, ...
    'Solver','linprog')