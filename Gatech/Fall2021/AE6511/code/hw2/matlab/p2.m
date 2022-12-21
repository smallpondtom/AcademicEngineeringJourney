% Problem 2 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
% Declare and solve necessary conditions
syms x_1 x_2 lambda_1 lambda_2 lambda_3;
assume(lambda_1 >= 0); assume(lambda_1, 'real');
assume(lambda_2 >= 0); assume(lambda_2, 'real');
assume(x_1, 'real');
assume(x_2, 'real');
assume(lambda_3, 'real');
eqn1 = 2*x_1 + 2*lambda_1*x_1 + 3*lambda_3*x_1^3 == 0;
eqn2 = -1 + 2*lambda_1*x_2 + lambda_2 + lambda_3 == 0;
eqn3 = lambda_1 * (x_1^2 + x_2^2 - 1) == 0;
eqn4 = lambda_2 * (x_2 - 2) == 0;
eqn5 = x_1^3 + x_2 - 1 == 0;
%%
eqn = [eqn1, eqn2, eqn3, eqn4, eqn5];
sol = solve(eqn, [x_1, x_2, lambda_1, lambda_2, lambda_3]);
%%
sol.x_1 = double(sol.x_1);
sol.x_2 = double(sol.x_2);
sol.lambda_1 = double(sol.lambda_1);
sol.lambda_2 = double(sol.lambda_2);
sol.lambda_3 = double(sol.lambda_3);
%%
sol_table = struct2table(sol)
sol_array = table2array(sol_table);
%%
% Check 2nd order sufficient condition
x1 = sol_array(2, 1);
l1 = sol_array(2, 3);
l3 = sol_array(2, 5);
Lxx = [2 + 2*l1 + 6*l3*x1, 0; 0, 2*l1]
eig(Lxx)
%%
% Check 2nd order sufficient condition
x1 = sol_array(4, 1);
l1 = sol_array(4, 3);
l3 = sol_array(4, 5);
Lxx = [2 + 2*l1 + 6*l3*x1, 0; 0, 2*l1]
eig(Lxx)