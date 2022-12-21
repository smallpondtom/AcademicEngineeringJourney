% AE6230 Midterm 1 Problem 3
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Plot
z1 = 0:0.001:0.5;
z2 = 0.5:0.001:2;

X = [2*abs(sin(pi*z1)) 2*ones(size(z2))];

fig = figure(Renderer="painters");
    plot([z1 z2], X)
    grid on; grid minor; box on;
    xlabel("$T_1/T_n$")
    ylabel("$x_{max}/x_s$")
    ylim([0 2.1])
saveas(fig, "resp_max_amp.png");

%% Verify
T1 = 1;
z = [0.05 0.2 0.4 0.5 0.65 0.9 1 2];
Tn = T1 ./ z;
tspan1 = 0:0.0001:T1;
tspan2 = T1:0.0001:3;

fig = figure(Renderer="painters",Position=[60 60 900 500]);
  plot(0,0,".",MarkerSize=0.01,HandleVisibility="off")
  hold on; grid on; grid minor; box on;
  ct = 1;
  for Tni = Tn
    omega_n = 2*pi / Tni;
    xhat1 = 1 - cos(omega_n * tspan1);
    xhat2 = cos(omega_n * (tspan2 - T1)) - cos(omega_n*tspan2);

    plot([tspan1 tspan2], [xhat1 xhat2], DisplayName="$z="+num2str(z(ct))+"$")
    ct = ct + 1;
  end
  hold off; legend;
  xlabel("$t$")
  ylabel("$x(t)$")
saveas(fig,"resp_diff_ratio.png")
