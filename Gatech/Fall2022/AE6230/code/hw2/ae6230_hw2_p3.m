% AE6230 HW2 Problem 3
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% (1)
syms t real
syms m b J_c k real positive
syms h_1(t) h_2(t) theta(t)

% let h1(t) = h_LE(t) and h2(t) = h_TE(t)
h1dot = diff(h_1,t);
h2dot = diff(h_2,t);
h1ddot = diff(h1dot,t);
h2ddot = diff(h2dot,t);

T = m*(h1dot + h2dot)^2/8 + J_c*(h1dot - h2dot)^2/8/b^2;  % kinetic energy
V = k*(3*h_1 + h_2)^2/32 + k*h_2^2/2;  % potential energy

% Lagrangian
L = T - V;

%% (2)
% EOM Derivation
Lq1 = diff(L,h_1)
Lq1dot = collect(simplify(expand(diff(L,h1dot))), [h1dot h2dot])
Lq1dot_dt = collect(simplify(expand(diff(Lq1dot,t))), [h1ddot h2ddot])
eqn1 = collect(simplify(expand(Lq1dot_dt - Lq1)), ...
               [h_1 h_2 h1ddot h2ddot])

Lq2 = simplify(expand(diff(L,h_2)))
Lq2dot = collect(simplify(expand(diff(L,h2dot))), [h1dot h2dot])
Lq2dot_dt = collect(simplify(expand(diff(Lq2dot,t))), [h1ddot h2ddot])
eqn2 = collect(simplify(expand(Lq2dot_dt - Lq2)), ...
               [h_1 h_2 h1ddot h2ddot])

%% (3)
eqn1_coeffs = coeffs(eqn1,[h1ddot h2ddot h_1 h_2])
eqn2_coeffs = coeffs(eqn2,[h1ddot h2ddot h_1 h_2])
eqn1_coeffs = formula(eqn1_coeffs);
eqn2_coeffs = formula(eqn2_coeffs);

M = [eqn1_coeffs(4) eqn1_coeffs(3); eqn2_coeffs(4) eqn2_coeffs(3)]
K = [eqn1_coeffs(2) eqn1_coeffs(1); eqn2_coeffs(2) eqn2_coeffs(1)]

T = [1/2 1/2; 1/2/b -1/2/b];
T = inv(T)
Mhat = expand(T.' * M * T)
Khat = expand(T.' * K * T)