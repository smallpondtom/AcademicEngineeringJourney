% Problem 7 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
% Define symbolic values
syms x_1 x_2 x_3 m g epsilon 
assume(m, {'real', 'positive'});
assume(g, {'real', 'positive'});
assume(epsilon, {'real', 'positive'});

% Define Lagrangian parameters
syms lambda_1 lambda_2 mu
assume(lambda_1, 'real');
assume(lambda_2, 'real');
assume(mu, {'real', 'positive'});

% Define symbolic functions 
syms f(x_1, x_2) g_1(x_1,x_2,x_3) g_2(x_1,x_2,x_3)
syms T(x_1) D(x_1,x_3) L(x_1,x_3)
f(x_1,x_2) = x_1 * sin(x_2);
g_1(x_1,x_2,x_3) = T(x_1)*cos(x_3 + epsilon) - D(x_1,x_3) - m*g*sin(x_2);
g_2(x_1,x_2,x_3) = T(x_1)*sin(x_3 + epsilon) + L(x_1,x_3) - m*g*cos(x_2);
%%
syms l(x_1, x_2, x_3, mu, lambda_1, lambda_2)
l(x_1, x_2, x_3, mu, lambda_1, lambda_2) = (mu*f(x_1,x_2) + ...
    lambda_1*g_1(x_1,x_2,x_3) + lambda_2*g_2(x_1,x_2,x_3));

% 1st order derivative of the Lagrangian
l_x = [diff(L, x_1); diff(L, x_2); diff(L, x_3)]
%%
% Solving optimization problem
options = optimoptions('fmincon','Display','iter', ...
    'Algorithm','interior-point');
problem.options = options;
problem.solver = 'fmincon';
problem.objective = @(x) -x(1)*sin(x(2));
problem.x0 = [100,0.1,0.1];
problem.nonlcon = @nl_constraints;
[x,fval,exitflag,output,lambda,grad,hessian] = fmincon(problem);
%%
function [c, ceq] = nl_constraints(x)
    epsilon = 0.0349;
    
    % dimensionless equations of thrust, drag, and lift
    T = @(x) 0.2476 - 0.04312*x(1) + 0.008392*x(1)^2;
    D = @(x) (0.07351 - 0.08617*x(3) + 1.996*x(3)^2)*x(1)^2;
    L = @(x) (0.1667 + 6.231*x(3) - 21.65*max(0, x(3) - 0.2094)^2)*x(1)^2;

    c = [];
    ceq = [T(x)*cos(x(3) + epsilon) - D(x) - sin(x(2));
           T(x)*sin(x(3) + epsilon) + L(x) - cos(x(2))];
end