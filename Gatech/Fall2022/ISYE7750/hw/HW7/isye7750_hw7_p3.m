% ISYE 7750 HW7 Problem 3
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic
clear ans;

%% (a)
load hw07p3data.mat

% Monte Carlo iterations
N = 20000;

% random generate setup
rng(0,'twister');
lb = -15;
ub = 15;
x = [(ub-lb).*rand(N,1) + lb, (ub-lb).*rand(N,1) + lb];

%%
fig = figure(Renderer="painters"); 
hold all; grid on; grid minor; box on;
for i = 1:N
  x1 = x(i,1);
  x2 = x(i,2);
  D1 = min(vecnorm(X1 - [x1; x2]));
  D2 = min(vecnorm(X2 - [x1; x2]));
  if D1 < D2
    plot(x1,x2,'.b',MarkerSize=8)
  else
    plot(x1,x2,'.r',MarkerSize=8)
  end
end
xlabel("$x_1$")
ylabel("$x_2$")
saveas(fig,"plots/p3-region.png");

%% Risk 
Sigma1 = [3 -6; -6 24];
Sigma2 = [16 -6; -6 8];
mu1 = [-1; 1];
mu2 = [1; 0];

N = 50000;
R1 = mvnrnd(mu1,Sigma1,N);  % should be for class 1
R2 = mvnrnd(mu2,Sigma2,N);  % should be for class 2

loss = zeros(2*N,1);
for i = 1:N
  D11 = min(vecnorm(X1 - R1(i)));
  D21 = min(vecnorm(X2 - R1(i)));
  loss(i) = ~(D11 < D21);  % check for class 1

  D12 = min(vecnorm(X1 - R2(i)));
  D22 = min(vecnorm(X2 - R2(i)));
  loss(N+i) = ~(D12 > D22);  % check for class 2
end
risk = mean(loss);