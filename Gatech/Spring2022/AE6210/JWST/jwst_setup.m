%% James Webb Space Telescope Simulation Setup
% Author: Tomoki Koike
close all; clear; clc;

% Numbering convention -> 1: Sun, 2: Earth, 3: JWST

% Radii
R2 = 6378;  % radius of Earth [km]
R1 = 695700;  % radius of Sun [km]

% Distance
r12 = 149.6e6;  % distance of Earth from Sun [km]
r23 = 1.5e6;  % distance of JWST from Earth [km]

% Standard Gravitational Parameter [km^3 s^-2]
mu1 = 132712e6;
mu2 = 3.9860e5;
mu = mu1 + mu2;

% Inertial angular velocity
Omega = sqrt(mu / r12^3);

% x positions relative to Center of mass (barycenter)
eta1 = mu1 / mu;
eta2 = mu2 / mu;
x1 = -eta2 * r12;
x2 = eta1 * r12;

% Pack parameters
orbit.r12 = r12;
orbit.r23 = r23;
orbit.mu1 = mu1;
orbit.mu2 = mu2;
orbit.Omega = Omega;
orbit.eta1 = eta1;
orbit.eta2 = eta2;