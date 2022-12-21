%% AAE 567 HW2 Problem3

% Housekeeping commands
clear all; close all; clc;

% Given system matrices 
A = [0, 1; -2, -3];
C = [2, 1];

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
[U,S,V] = svd(P);
Sp = 1./S;
Sp(Sp == inf) = 0;
Pi =  V * Sp * U';
x0 = Pi * int(eA'*C'*f, 0, inf);

% d
temp = C*eA*x0;
d2 = int((f - temp)^2, 0, inf);
d = sqrt(d2);