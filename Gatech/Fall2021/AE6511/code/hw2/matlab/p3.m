% Problem 3 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
%%
% Declare and solve necessary conditions
syms x_1 x_2 x_3 lambda
assume(lambda, 'real');
assume(x_1, 'real');
assume(x_2, 'real');
assume(x_3, 'real');
eqn1 = 1 + lambda*x_1 == 0;
eqn2 = (lambda + 2)*x_2 + x_3 == 0;
eqn3 = x_2 + (lambda + 4)*x_3 == 0;
eqn4 = 0.5*(x_1^2 + x_2^2 + x_3^2) - 1 == 0;
%%
eqn = [eqn1, eqn2, eqn3, eqn4];
sol = solve(eqn, [x_1, x_2, x_3, lambda]);
%%
sol.x_1 = double(sol.x_1);
sol.x_2 = double(sol.x_2);
sol.x_3 = double(sol.x_3);
sol.lambda = double(sol.lambda);
%%
sol_table = struct2table(sol)
sol_array = table2array(sol_table);
%%
% Check 2nd order sufficient condition
for i = 1:6
    fprintf("Iteration %i", i);
    l = sol_array(i, 4);
    Lxx = [l, 0, 0; 0, l+2, 1; 0, 1, l+4]
    eig(Lxx)
end
%%
% The answer to the minimization problem is 
fx = x_1 + x_2^2 + x_2 * x_3 + 2*x_3^2;
subs(fx, {x_1, x_2, x_3}, {sol_array(4,1), ...
    sol_array(4,2), sol_array(4,3)})