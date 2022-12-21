%% AE6210 Advanced Dynamics HW1 
% Tomoki Koike

%% House keeping commands 
close all; clear all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Simulate Hubble about Earth

% Constants
r_e = 6378;  % radius of Earth [km]
g_e = 9.80665;  % gravitational acceleration of Earth [km/s]
r_h = r_e+538;  % Hubble's distance from the Earth [km]
mu_e = 3.9860e5;  % standard gravitational parameter [km^3s^-2]
v0 = sqrt(mu_e/r_h);  % initial velocity of Hubble

% Simulate setup
tspan = 0:60*100;
IC = [r_h 0 0 v0];
opts = odeset('RelTol',1e-7,'AbsTol',1e-8);

% Simulate 
[t,z] = ode45(@(t,z) hubbleOrbit1(t,z,mu_e),tspan,IC,opts);
x = z(:,1);
y = z(:,2);
vx = z(:,3);
vy = z(:,4);

% Plot results

fig1 = figure(Renderer="painters");
    plot(x,y);
    grid on; grid minor; box on; axis equal; hold on;
    rectangle(Position=[-r_e,-r_e,2*r_e,2*r_e],FaceColor=[0 .5 .5], ...
        EdgeColor=[0 .5 .5],Curvature=[1 1])
    hold off;
    xlabel('$x$')
    ylabel('$y$')

%% Verification

% Specific orbital energy conservation
En = (vx.^2 + vy.^2) / 2 - mu_e ./ sqrt(x.^2 + y.^2);

fig2 = figure(Renderer="painters");
    plot(t,En,'.r')
    grid on; grid minor; box on; 
    xlabel('$t$')
    ylabel('$\epsilon$')

%% Function

function zdot = hubbleOrbit1(t,z,mu)
    % Unpack states
    x = z(1); y = z(2); vx = z(3); vy = z(4);
    % Equations of motion
    xdot = vx;
    ydot = vy;
    vxdot = -mu * x / (x^2 + y^2)^1.5;
    vydot = -mu * y / (x^2 + y^2)^1.5;
    zdot = [xdot; ydot; vxdot; vydot];
end
