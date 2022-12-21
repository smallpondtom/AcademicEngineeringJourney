close all; clear all; clc;
gamma=1;
A0 = [0 1; -2 -1];
DelA = [0 0; 1 0];

% Quadratic stability LMI of the problem 
A1 = A0 - gamma*DelA;
A2 = A0 + gamma*DelA;

setlmis([]);
p = lmivar(1,[2 1]);

lmiterm([1 1 1 0], 1);  % P > I : I
lmiterm([-1 1 1 p], 1, 1);  % P > I : P
lmiterm([2 1 1 p], A1, 1, 's');  % LFC#1 {lhs)
lmiterm([-2 1 1 p], 2, 1);  % LFC#1 (rhs)
lmiterm([3 1 1 p], A2, 1, 's');  % LFC#2 {lhs)
lmiterm([-3 1 1 p], 2, 1);  % LFC#2 (rhs)
lmis = getlmis;

% Results
[alpha, popt] = gevp(lmis,2);