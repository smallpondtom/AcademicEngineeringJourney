% AE6511 Hw6 Problem 7 MATLAB code
% Tomoki Koike 
clear all; close all; clc;  % housekeeping commands
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
%%
% Define the matrices
syms s t alpha T
assume(alpha > 1);
R1 = -alpha;
R2 = 1;
A = 1;
B = 1;
x0 = 0;
xf = 0;
%%
A_tilde = -sqrt(1 - alpha);
W_tilde(t) = int(expm(A_tilde*s)*B*inv(R2)*B.'*expm(A_tilde.'*s),s,0,t)
%%
z0 = expm(A_tilde.'*T)*inv(W_tilde(T))*(expm(A_tilde.'*T)*x0 - xf)
%%
syms s(t)
dsolve(diff(s,t) == s^2 + 1)
%%
t = linspace(0,pi,100);
plot(t, 1 + tan(t - pi/4))