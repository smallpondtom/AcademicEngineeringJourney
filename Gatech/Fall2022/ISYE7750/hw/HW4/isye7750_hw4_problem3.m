% ISYE7750 HW4 Problem 3
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% 
d = 1000;
t = linspace(0,1,d);
N = [10 20 50 100 200];

gt = @(z) exp(-z.^2);
psit = @(t,k,N) gt(t - k/N);

Phit = @(s,t) exp(-100 * abs(s - t).^2);

%%

fig = figure(Renderer="painters", Position=[60 60 800 500]);
plot(0,1,'.',MarkerSize=0.1,HandleVisibility='off')
hold on; grid on; grid minor; box on;
for k = 1:length(N)
  Psit = zeros(N(k),1);
  for i = 1:N(k)
    Psit(i) = psit(1/3,i,N(k));
  end
  plot(1:N(k), Psit(1:N(k)),'o',DisplayName="$N="+num2str(N(k))+"$")
end

hold off; legend;
xlabel("$N$")
ylabel("$\Phi(t)$")
saveas(fig, "plots/p3/Phi_plots.png")

fig = figure(Renderer="painters");
plot(t, Phit(t,1/3))
grid on; grid minor; box on;
xlabel("$t$")
ylabel("$\Psi_t(s)$")
saveas(fig, "plots/p3/gaussian-radial.png")