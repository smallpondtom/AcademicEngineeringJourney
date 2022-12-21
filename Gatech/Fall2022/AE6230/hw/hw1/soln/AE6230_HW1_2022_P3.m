%% This script solves HW1 Problem 3

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc


%% Problem parameters

% beam length (m)
l = 0.5;

% beam bending stiffness (Nm2)
EI = 5.0;

% tip mass (kg)
m = 0.5;


%% Q2a - Natural frequency 

% equivalent stiffness constant (N/m)
k_eq = 3.0*EI/l^3; 

% natural frequency (rad/s);
omega_n = sqrt(k_eq/m);


%% Q2b - Maximum allowed excitation frequency

% maximum allowed excitation frequency (rad/s)
omega_max = omega_n*sqrt(0.1/1.1);

% ratio with respect to the natural frequency
omega_max_to_omega_n = omega_max/omega_n;


