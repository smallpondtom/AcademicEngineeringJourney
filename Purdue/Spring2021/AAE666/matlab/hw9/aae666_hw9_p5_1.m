% Houskeeping commands 
clear all; close all; clc;
%%
% The system matrix A 
syms k_I
assume(k_I, {'real', 'positive'});
A = [0, 1, 0; -1, -2, -k_I; 1, 0, 0];
%%
ev = eig(A)
ev_real = real(ev)
%%
inc = 0.0001;
for ki = 1.999:inc:2.1
    ev_real_vals = double(subs(ev_real, k_I, ki));
    if any(ev_real_vals > 0)
        break 
    end
end
format long;
disp(ki-inc);
format;