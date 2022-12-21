% AE6230 HW1 Problem 1
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Parameters

k1 = 25;
k2 = 0.75*k1;
b = 0.1;
d1 = b/4;
d2 = b;
J = 0.0004;

%% P1(b)

wn = sqrt(4*(k1*d1^2 + k2*d2^2)/J);
fprintf("wn: %f \n",wn);

%% P2

d1new = sqrt( (1.15^2 * (k1*d1^2 + k2*d2^2) - k2*d2^2) / k1 );
fprintf("d1new: %f = %f*b \n", d1new, d1new/b);

d2new = sqrt( (1.15^2 * (k1*d1^2 + k2*d2^2) - k1*d1^2) / k2 );
fprintf("d2new: %f = %f*b \n", d2new, d2new/b);

%% P3

gamma = J * (k1*d1^2 + k2*d2^2);
c1min = sqrt(0.04/1.04) * gamma / d1;
fprintf("c1min: %f \n", c1min)

zeta = c1min * d1 / gamma;
fprintf("zeta: %f \n", zeta);

wd = wn * sqrt(1 - zeta^2);
fprintf("wd: %f \n",wd);

w_diff = (wn - wd) / wn * 100;
fprintf("w_diff: %f \n", w_diff);

%% P4

theta0 = deg2rad(5);
thetadot0 = 0;
A = zeta*wn
B = (zeta*wn*theta0 + thetadot0)/wd

% Plot the response
tspan = 0:0.001:5;
res = exp(-A*tspan) .* (theta0*cos(wd*tspan) + B*sin(wd*tspan));

fig = figure(Renderer="painters", Position=[60 60 700 400]);
    plot(tspan, res)
    xlabel("$t$ [s]")
    ylabel("$\theta$ [rad]")
    grid on; grid minor; box on; 
saveas(fig, "p4_response.png");

