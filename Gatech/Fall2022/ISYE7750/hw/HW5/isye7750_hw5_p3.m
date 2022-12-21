% ISYE7750 HW5 Problem 3
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Setup
load hw05p3_data.mat;

%% (a) Gradient Descent
[x_gd, iter_gd] = gdsolve(H,b,1e-6,1000);

% Check that the result is within the tolerance
delta_gd = norm(b - H*x_gd) / norm(b);

%% (b) Conjugate Descent 
[x_cg, iter_cg] = cgsolve(H,b,1e-6,1000);

% Check that the result is within the tolerance
delta_cg = norm(b - H*x_cg) / norm(b);