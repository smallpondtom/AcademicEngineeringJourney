% AE6511 Hw5 Problem 4(a) MATLAB code
% Tomoki Koike
clear all; close all; clc;  % housekeeping commands
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
%%
% BVP4C
V = 15;
x0 = [0, 0, 0.0055, -0.1121, 1];
mesh = linspace(0, 1, 10);
solinit = bvpinit(mesh, x0);
opts = bvpset('RelTol',1e-5, 'AbsTol',1e-6,'Stats','on','Nmax',10000);
sol = bvp4c(@odefcn,@bcfcn,solinit, opts, V); 

% Unpack results
T = linspace(0,1,1000);
[xopt,xdopt] = deval(sol,T);
xopt = xopt.'; xdopt = xdopt.';
tf_eval = mean(xopt(1,5));
tf_out = abs(tf_eval);
tspan = tf_out * T;
x_sol = xopt(:,1);
y_sol = xopt(:,2);
lambda1_sol = xopt(:,3);
lambda2_sol = xopt(:,4);
theta_sol = atan2(lambda2_sol,lambda1_sol);
H = (-1 + lambda1_sol .* xdopt(:,1)./tf_eval ...
    + lambda2_sol .* xdopt(:,2)/tf_eval);
%%
fig = figure("Renderer","painters","Position",[60 60 900 800]);
    % x vs t
    subplot(2,2,1)
    plot(tspan, x_sol)
    title('$x$ Over Time')
    xlabel('$t$')
    ylabel('$x$')
    grid on; grid minor; box on;
    % y vs t
    subplot(2,2,2)
    plot(tspan, y_sol)
    title('$y$ Over Time')
    xlabel('$t$')
    ylabel('$y$')
    grid on; grid minor; box on;
    % x - y 
    subplot(2,2,3)
    plot(x_sol, y_sol)
    title('$x$ vs $y$')
    xlabel('$x$')
    ylabel('$y$')
    grid on; grid minor; box on;
    % Hamiltonian 
    subplot(2,2,4)
    plot(tspan, H)
    title('Hamiltonian')
    xlabel('$t$')
    ylabel('$H$')
    ytickformat('%,.2f')
    grid on; grid minor; box on;
saveas(fig, 'p4a.png');
%%
% Plot costates 
fig = figure("Renderer","painters","Position",[60 60 900 800]);
    plot(tspan, lambda1_sol,'DisplayName','$\lambda_1$')
    hold on;
    plot(tspan, lambda2_sol,'DisplayName','$\lambda_2$')
    title('$\lambda$ Over Time')
    xlabel('$t$')
    ylabel('$\lambda_i$')
    legend('Location','best'); grid on; grid minor; box on; hold off;
saveas(fig,'p4a_lambda.png');
%%
% Plot control 
fig = figure("Renderer","painters","Position",[60 60 900 800]);
    plot(tspan, theta_sol)
    title('$\theta$ Over Time')
    xlabel('$t$')
    ylabel('$\theta$')
    ytickformat('%,.4f')
    grid on; grid minor; box on;
saveas(fig, 'p4a_theta.png');
%% Function

function dxdt = odefcn(t,x,V)
    dxdt = zeros(5,1); 
    theta = atan2(x(4),x(3));
    dxdt(1) = V * cos(theta) + 2; % x
    dxdt(2) = V * sin(theta) - 6; % y
    dxdt(3) = 0; % lambda1
    dxdt(4) = 0; % lambda2
    dxdt(5) = 0; % tf
    dxdt = dxdt * x(5);
end

function res = bcfcn(xa,xb,V)
    res = zeros(5,1);
    theta_f = atan2(xb(4),xb(3));
    res(1) = xa(1) + 20; % x(0)
    res(2) = xa(2);  % y(0)
    res(3) = xb(1) + 15; % x(tf)
    res(4) = xb(2) - 35.5; % y(tf)
    res(5) = (-1 + xb(3) * (V*cos(theta_f)+2) ...
        + xb(4)*(V*sin(theta_f)-6))*xb(5); % H(t_f)
end