%% James Webb Space Telescope Simulation Execution
% Author: Tomoki Koike
close all; clear; clc;

global animation_on
animation_on = 0;

%% Solve simulation
jwst_solve;

%% Plot simulation results
jwst_plot;

%% Verify simulation
jwst_verf;