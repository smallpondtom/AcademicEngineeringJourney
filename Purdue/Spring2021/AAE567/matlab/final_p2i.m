% AAE 567 Final Exam Spring 2021 Problem 2 Part (i)
% Tomoki Koike

% Housekeeping commands
clear all; close all; clc;
%%
getA = @(n) [exp(-n/50), 1; 2, cos(n/50)];
getB = @(n) [exp(-n/50)*cos(n/50); 1];
getC = @(n) [1+exp(-n/50), 2+sin(n/50)];
getD = @(n) 1 + 0.5*sin(n/50);

% PART (i)
% Initialize cells to store matrices
A = {}; B = {}; C = {}; D = {};

% Initialize the covariance matrix Q 
Q = {}; Q{1} = zeros(2,2);

% Initialize the x-states and xhat-states
x = {}; x{1} = zeros(2,1);
xhat = {}; xhat{1} = zeros(2,1);

% Initialize the u(n) and v(n) white noise
rng(1000); u = randn(1,20);
rng(2000); v = randn(1,20);

% Initialize the output states y(n)
y = {};

for n = 0:10
    A{n+1} = getA(n);
    B{n+1} = getB(n);
    C{n+1} = getC(n);
    D{n+1} = getD(n); 
    % Compute x(n+2) which is actually x(n+1)
    x{n+2} = A{n+1}*x{n+1} + B{n+1}*u(n+1);
    % Compute y(n)
    y{n+1} = C{n+1} * x{n+1} + D{n+1}*v(n+1);
    [xhat{n+2}, Q{n+2}] = dkf(A{n+1}, B{n+1}, C{n+1}, D{n+1}, ...
                                Q{n+1}, xhat{n+1}, y{n+1});
end
%%
function [Xnew, Qnew] = dkf(Ad, Bd, Cd, Dd, Qd, xhat, y)
    % Discrete time Kalman filter 
    Del = Ad*Qd*Cd' * inv(Cd*Qd*Cd' + Dd*Dd');
    Xnew = Ad*xhat + Del*(y - Cd*xhat);
    Qnew = Ad*Qd*Ad' + Bd*Bd' - Del*Cd*Qd*Ad';
end