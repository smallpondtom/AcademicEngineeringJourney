%% AAE 567 HW2 Problem1

% Housekeeping commands
clear all; close all; clc;

% Given system matrices 
A = [0, 1; -2, -3];
C = [1, 2];

% Observability matrix 
res = checkObservability(A,C);
disp(res.check);
disp(res.Qo);

% Exponential of A
syms t 
eA = expm(A*t);
P = int(eA'*C'*C*eA, 0, inf);

% x_0
f = exp(-t);
x0 = inv(P) * int(eA'*C'*f, 0, inf);

% d
temp = C*eA*x0;
d2 = int((f - temp)^2, 0, inf);