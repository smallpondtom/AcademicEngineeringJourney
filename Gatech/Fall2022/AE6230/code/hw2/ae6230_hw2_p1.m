% AE6230 HW2 Problem 1
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Parameters
params.F0 = 1;  % [N]
params.T = 0.2;  % [s]
params.omega0 = 2*pi/params.T;  % [rad/s]
params.omega_n = 5*params.omega0;  % [rad/s]
params.zeta = 0.05;
params.k = 10;  % [N/m]

%% (a)
syms T F_0 k t p l zeta omega_0 omega_n real
assume(T > 0); assume(F_0 > 0); assume(p > 0);

% piecewise function
F1 = 2*F_0/T*t;
F2 = -2*F_0/T*t + 2*F_0;
F(t) = piecewise((0 <= t) & (t <= T/2), F1, (T/2 <= t) & (t <= T), F2);
F(t) = subs(F, [F_0,T], [params.F0,params.T]);

% Fourier Series
a0 = int(F1/T,t,0,T/2) + int(F2/T,t,T/2,T);
integrand1 = exp(1i*p*omega_0*t) * F1;
integrand2 = exp(1i*p*omega_0*t) * F2;
a1 = simplify(expand(int(integrand1 / T, t, 0, T/2)));
a2 = simplify(expand(int(integrand2 / T, t, T/2, T)));
a_k = expand(a1 + a2);
simplify(a_k);
a_k = rewrite(a_k, "sincos");
alpha(p) = 2*real(a_k);
beta(p) = 2*imag(a_k);

%% (b)
c(p) = sqrt(alpha^2 + beta^2);
c(p) = subs(c, [F_0, T, omega_0], [params.F0, params.T, params.omega0]);
pts = 1:12;
fig = figure(Renderer="painters");
    stem([0 pts],[subs(a0,F_0,params.F0) c(pts)])
    xlabel("$p$")
    ylabel("discrete frequency spectrum")
    grid on; grid minor; box on; 
saveas(fig, "plots/p1_b.png");

%% (c) 
pts = 1:20;
fig = figure(Renderer="painters");
    stem([0 pts],[subs(a0,F_0,params.F0) c(pts)])
    grid on; grid minor; box on; hold on;
    plot([pts(1) pts(end)], [0.05*params.F0, 0.05*params.F0], '--r')
    plot([pts(1) pts(end)], [0.025*params.F0, 0.025*params.F0], '--r')
    plot([pts(1) pts(end)], [0.005*params.F0, 0.005*params.F0], '--r')
    hold off
    xlabel("$p$")
    ylabel("discrete frequency spectrum")
% saveas(fig, "plots/p1_b.png");

fig = figure(Renderer="painters");
    stem([0 pts],[subs(a0,F_0,params.F0) c(pts)])
    grid on; grid minor; box on; hold on;
    plot([pts(1) pts(end)], [0.05*params.F0, 0.05*params.F0], '--r')
    plot([pts(1) pts(end)], [0.025*params.F0, 0.025*params.F0], '--r')
    plot([pts(1) pts(end)], [0.005*params.F0, 0.005*params.F0], '--r')
    hold off
    xlabel("$p$")
    ylabel("discrete frequency spectrum")
    ylim([0, 0.06])

%% (d)
F_f(t,p) = a0 + symsum(alpha(l)*cos(l*omega_0*t),l,1,p) + ... 
  symsum(beta(l)*sin(l*omega_0*t),l,1,p);
F_f(t,p) = subs(F_f, [F_0,T,omega_0], [params.F0,params.T,params.omega0]);

tspan = 0:0.01:params.T;

fig = figure(Renderer="painters", Position=[60 60 700 500]);
    plot(tspan, F(tspan), '--k', DisplayName="original")
    grid on; grid minor; box on; hold on;
    plot(tspan, F_f(tspan,3), '-r', DisplayName="$p=3$")
    plot(tspan, F_f(tspan,5), '-g', DisplayName="$p=5$")
    plot(tspan, F_f(tspan,11), '-b', DisplayName="$p=11$")
    hold off; legend;
    xlabel("$t$ [s]")
    ylabel("$F(t)$")
saveas(fig, "plots/p1_d.png");

%% (e)
omega = p * omega_0;
Hi(p) = ( (1 - omega^2/omega_n^2)^2 + (2*zeta*omega/omega_n)^2 )^-0.5;
Hi(p) = subs(Hi, [omega_n, zeta], [params.omega_n, params.zeta]);

d(p) = Hi * c;
d(p) = subs(d, [F_0, T, omega_0], [params.F0, params.T, params.omega0]);

pts = 1:12;
fig = figure(Renderer="painters");
    stem([0 pts],[subs(a0,F_0,params.F0)/params.k d(pts)])
    xlabel("$p$")
    ylabel("discrete frequency spectrum")
    grid on; grid minor; box on; 
saveas(fig, "plots/p1_e.png");

%% (f) 
theta(p) = atan2( (2*zeta*omega/omega_n) , (1 - omega^2/omega_n^2) );

x_alpha(p) = alpha(p) * Hi(p) * cos(omega*t - theta(p));
x_beta(p) = beta(p) * Hi(p) * sin(omega*t - theta(p));
xp(t,p) = F_0/2/k + symsum(x_alpha(l) + x_beta(l), l, 1, p);
xp(t,p) = subs(xp, [F_0, T, omega_0, omega_n, zeta, k], ...
               [params.F0, params.T, params.omega0, params.omega_n, ...
                params.zeta, params.k]);

tspan = 0:0.01:params.T;

fig = figure(Renderer="painters", Position=[60 60 700 500]);
    plot(tspan, xp(tspan,3), '-r', DisplayName="$p=3$")
    grid on; grid minor; box on; hold on;
    plot(tspan, xp(tspan,5), '-g', DisplayName="$p=5$", LineWidth=2)
    plot(tspan, xp(tspan,11), '-b', DisplayName="$p=11$")
    hold off; legend;
    xlabel("$t$ [s]")
    ylabel("$x_p(t)$")
saveas(fig, "plots/p1_f.png");