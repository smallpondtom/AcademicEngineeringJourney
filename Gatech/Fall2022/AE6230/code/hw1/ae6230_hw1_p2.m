% AE6230 HW1 Problem 2
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Parameters

wn = 50;
z = 0.04;
M0 = 0.1;
w = 0.5*wn;
J = 0.0004;

%% P1

r = 0:0.001:4;
k = wn^2*J;
Hiw = 1/k * ((1 - r.^2).^2 + 4*z^2*r.^2).^(-0.5);
phi = atan2(2*z*r, 1-r.^2);

% Plot the results 
fig = figure(Renderer="painters", Position=[60 60 600 400]);
    plot(r, Hiw)
    xlabel("$\omega_n/\omega$")
    ylabel("Amplification factor")
    grid on; grid minor; box on; 
saveas(fig, "p2_1_ampfac.png");

fig = figure(Renderer="painters", Position=[60 60 600 400]);
    plot(r, phi)
    xlabel("$\omega_n/\omega$")
    ylabel("Phase [rad]")
    grid on; grid minor; box on; 
saveas(fig, "p2_1_phase.png");

%% P2

T = 1/w;
tspan = 10*T:0.001:10*T+0.5;
r = w/wn;
k = wn^2*J;
Hiw = 1/k * ((1 - r.^2).^2 + 4*z^2*r.^2).^(-0.5);
phi = atan2(2*z*r,1-r.^2);
res1 = M0 * Hiw * sin(w * tspan - phi);

fig = figure(Renderer="painters", Position=[60 60 900 700]);
    plot(tspan, res1)
    xlabel("$t$ [s]")
    ylabel("$\theta$ [rad]")
    grid on; grid minor; box on; 
saveas(fig, "p2_2b_response.png");

%% P3

den = (wn^2 - w^2)^2 + (4*z^2*wn^2*w^2);
B1 = M0/J * (wn^2 - w^2) / den;
B2 = -M0/J * (2*z*wn*w) / den;

% B = M0/J * ((wn^2-w^2)^2 + (2*z*wn*w)^2)^(-0.5);
% phi = atan2(2*z*wn*w, wn^2-w^2);

% B1 = M0*Hiw*cos(phi)
% B2 = -M0*Hiw*sin(phi)

res2 = B1 * sin(w * tspan) + B2 * cos(w * tspan);
% res2 = B .* sin(w * tspan - phi);


fig = figure(Renderer="painters", Position=[60 60 900 700]);
    plot(tspan, res2)
    xlabel("$t$ [s]")
    ylabel("$\theta$ [rad]")
    grid on; grid minor; box on; 
saveas(fig, "p2_3b_response.png");

%% P3

syms t real
syms theta(t)
syms zeta omega_n omega M_0 J_theta real
assume(zeta<1 & zeta>0)

thetadot = diff(theta,t);
thetaddot = diff(thetadot,t);
ode = thetaddot + 2*zeta*omega_n*thetadot + omega_n^2*theta == M_0/J_theta * sin(omega*t);
cond1 = theta(0) == 0;
cond2 = thetadot(0) == 0;
cond = [cond1 cond2];
thetaSol(t) = dsolve(ode,cond);
thetaSol(t) = simplify(thetaSol)
thetaSol(t) = subs(thetaSol, [omega_n, omega, M_0, J_theta, zeta], [wn,w,M0,J,z])
thetaSol(t) = simplify(expand(thetaSol))
thetaSol(t) = collect(thetaSol, exp(-2*t))

%% Plot
tspan = 0:0.001:4;

fig = figure(Renderer="painters", Position=[60 60 700 400]);
    plot(tspan, thetaSol(tspan))
    xlabel("$t$ [s]")
    ylabel("$\theta$ [rad]")
    grid on; grid minor; box on; hold on;
    plot(tspan, B1 * sin(w * tspan) + B2 * cos(w * tspan), '--')
    hold off; legend(["full response", "steady state"])
saveas(fig, "p2_3d_fullresponse.png");




