% AE6230 HW4 Problem 2
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% (1)
syms x real positive
syms l i theta_bar pi real positive

t = 1/l * sin((2*i-1)*pi*x / 2 / l) * theta_bar * x / l;
int(t,x,[0 l]);
clear;

%% (3)
l = 1;
GJ = 5.0;  % [N-m^2]
rhoIp = 0.005;   % [kg-m]
theta_bar = 1;

x = 0:0.001:1;

theta = 0;
for i = 1:100
  tmp = 8*theta_bar*(-1)^(i+1)*sin((2*i-1)*pi*x/2/l) / pi^2 / (2*i-1)^2;
  theta = theta + tmp;
end

fig = figure(Renderer="painters");
plot(x,theta_bar*x/l,'--r',LineWidth=2,DisplayName="$\theta_0(x)$")
hold on; grid on; grid minor; box on;
plot(x,theta,'-b',DisplayName="N=100")
hold off; legend("Location","northwest")
xlabel("$x$")
ylabel("$\theta(x,0)$")
saveas(fig,"plots/p2/initial_cond_check.png")