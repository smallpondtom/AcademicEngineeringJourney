% AE6511 Hw6 Problem 6 MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
%%
% Solve the differential equations when the control is u = 1
syms c c_1 c_2 c_3 c_4 c_5 c_6 t g 
assume(c, {'real', 'positive'});
assume(c_1, 'real');
assume(c_2, 'real');
assume(c_3, 'real');
assume(c_4, 'real');
assume(c_5, 'real');
assume(c_6, 'real');
assume(t, 'real');
assume(g, {'real', 'positive'});
lambda1 = c_1;
lambda2(t) = -c_1 * t + c_2;
m(t) = -c*t + c_3;
lambda3 = int(lambda2 / m^2, t) + c_4
v = int(-g + 1/m, t) + c_5
h = int(v,t) + c_6
%%
clear;
syms t c g v_0 h_0 m_net m_0 t_s m_f T
assume(t, 'real');
assume(c, {'real', 'positive'});
assume(g, {'real', 'positive'});
assume(v_0, {'real', 'positive'});
assume(h_0, {'real', 'positive'});
assume(m_net, {'real', 'positive'});
assume(m_0, {'real', 'positive'});
assume(t_s, {'real', 'positive'});
assume(m_f, {'real', 'positive'});
assume(T, {'real', 'positive'});

% Before t_s
h_minus = -g/2*t_s^2 + v_0*t_s + h_0;
v_minus = -g*t_s + v_0;
m_minus = m_net + m_0;
% After t_s
c_3 = m_f + c*T;
c_5 = g*T + 1/c * log(c_3 - c*T);
c_6 = g*T^2/2 - c_5*T - 1/c*(T - T*log(c_3 - c*T)) - c_3/c^2 * log(c_3 - c*T);
h_plus = (-g/2*t_s^2 + c_5*t_s + 1/c*(t_s - T*log(c_3 - c*t_s)) ...
    + c_3/c^2 * log(c_3 - c*t_s) + c_6);
v_plus = -g*t_s - 1/c*log(c_3 - c*t_s) + c_5;
m_plus = -c*t_s + c_3;

% Equate the equations before the switching time and after
eqn1 = h_minus == h_plus;
eqn2 = v_minus == v_plus;
eqn3 = m_minus == m_plus;

% Solve for m_f and t_s
res =  solve([eqn2 eqn3], [t_s m_f], 'ReturnConditions',true)
%%
res.t_s
res.m_f