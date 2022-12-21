% Problem 5 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
% Solving using fmincon
f = @(x) -5*x(1) -x(2);
x0 = [1, 1];
A = [-1, 0; 3, 1; 1, -2];
b = [0; 11; 2];
x = fmincon(f, x0, A, b)