% AE6444 HW4 Problem 2 MATLAB 
% Tomoki Koike
close all; clear all; clc;
%%
syms mu u(t) x_1 x_2
assume(mu, 'positive');

% System
x1dot = x_2;
x2dot = -2*mu*x_2 - x_1 - x_1^3;

% System matrix: A
a = diff(x1dot, x_1);
b = diff(x1dot, x_2);
c = diff(x2dot, x_1)
d = diff(x2dot, x_2)
A = [a, b; c, d]

% Equilibrium points 
x1e = 0;
x2e = 0;

% A matrix for equilibrium point
A1 = subs(A, [x_1 x_2], [x1e x2e])

% Eigenvalues and eigenvectors
[V, D] = eig(A1)
%%
% System
x1dot = x_2;
x2dot = -2*mu*x_2 - x_1 + x_1^3;

% System matrix: A
a = diff(x1dot, x_1);
b = diff(x1dot, x_2);
c = diff(x2dot, x_1)
d = diff(x2dot, x_2)
A = [a, b; c, d]

% Equilibrium points 
x1e_1 = -1;
x2e_1 = 0;
x1e_2 = 0;
x2e_2 = 0;
x1e_3 = 1;
x2e_3 = 0;

% A matrix for equilibrium point
A1 = subs(A, [x_1 x_2], [x1e_1 x2e_1])
A2 = subs(A, [x_1 x_2], [x1e_2 x2e_2])
A3 = subs(A, [x_1 x_2], [x1e_3 x2e_3])

% Eigenvalues and eigenvectors
[V1, D1] = eig(A1)
[V2, D2] = eig(A2)
[V3, D3] = eig(A3)
%%
% System
x1dot = x_2;
x2dot = -2*mu*x_2 + x_1 - x_1^3;

% System matrix: A
a = diff(x1dot, x_1);
b = diff(x1dot, x_2);
c = diff(x2dot, x_1)
d = diff(x2dot, x_2)
A = [a, b; c, d]

% Equilibrium points 
x1e_1 = -1;
x2e_1 = 0;
x1e_2 = 0;
x2e_2 = 0;
x1e_3 = 1;
x2e_3 = 0;

% A matrix for equilibrium point
A1 = subs(A, [x_1 x_2], [x1e_1 x2e_1])
A2 = subs(A, [x_1 x_2], [x1e_2 x2e_2])
A3 = subs(A, [x_1 x_2], [x1e_3 x2e_3])

% Eigenvalues and eigenvectors
[V1, D1] = eig(A1)
[V2, D2] = eig(A2)
[V3, D3] = eig(A3)
%%
% System
x1dot = x_2;
x2dot = -2*mu*x_2 + x_1 + x_1^3;

% System matrix: A
a = diff(x1dot, x_1);
b = diff(x1dot, x_2);
c = diff(x2dot, x_1)
d = diff(x2dot, x_2)
A = [a, b; c, d]

% Equilibrium points 
x1e = 0;
x2e = 0;

% A matrix for equilibrium point
A1 = subs(A, [x_1 x_2], [x1e x2e])

% Eigenvalues and eigenvectors
[V, D] = eig(A1)