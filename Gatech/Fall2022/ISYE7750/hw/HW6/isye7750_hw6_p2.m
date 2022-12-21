% ISYE7750 HW6 Problem 2
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% 
N = [1 2 5 10 20 100];
t = 0:0.01:5;
sigma2 = 1/12;

fig = figure(Renderer="painters");
  phi_G = exp(sigma2*t.^2/2);
  plot(t,phi_G,DisplayName="$\phi_G$")
  hold on; grid on; grid minor; box on;
  for Ni = N
    phi_Yn = (sqrt(Ni) * (exp(t/2/sqrt(Ni)) - exp(-t/2/sqrt(Ni))) ./ t).^Ni;
    plot(t,phi_Yn,DisplayName="$\phi_{Y_{"+num2str(Ni)+"}}$")
  end
  hold off; legend(Location="northwest");
  xlabel("$t$")
  ylabel("$\phi(t)$")
saveas(fig,"plots/p2-b.png")

%% 
mi = @(u,N) exp(-4*u.^2/N) .* ( (exp(2*u/N^2) - exp(-2*u/N^2)) ./ (4*u/N^2) ).^N;
ci = @(u,N) 1/12/N./u.^2;

u = 0.05:0.01:3;
Ns = [1 3 5 10];

fig = figure(Renderer="painters",Position=[60 60 800 800]);
tile = tiledlayout(2,2,"TileSpacing","compact","Padding","compact");

for N = Ns
  nexttile(tile);
  plot(u,min([mi(u,N);ci(u,N)]),':',LineWidth=2,DisplayName="bound")
  hold on; grid on; grid minor; box on;
  plot(u,ci(u,N),DisplayName="CI")
  plot(u,mi(u,N),DisplayName="MI")
  hold off; legend;
  ylim([0,3])
  title("$N="+num2str(N)+",  u\in [0.1,5]$")
end
xlabel(tile,'$t$','FontSize',10,'Interpreter','latex')
ylabel(tile,"Markov and Chebyshev Bounds",'FontSize',10,'Interpreter','latex')
saveas(fig,"plots/p2-c.png")
