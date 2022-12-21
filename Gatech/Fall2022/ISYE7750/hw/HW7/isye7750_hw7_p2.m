% ISYE 7750 HW7 Problem 2
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic
clear ans;

%%
Py = [0.5 0.5];
Sigma1 = [3 -6; -6 24];
Sigma2 = [16 -6; -6 8];
mu1 = [-1; 1];
mu2 = [1; 0];

fX = @(x,k) exp(-0.5*(x-mu{k}).' * inv(Sigma{k}) * (x-mu{k})) / (2*pi*sqrt(det(Sigma{k})));
syms x_1 x_2 
x = [x_1; x_2];

G1_lhs = (x-mu1).' * inv(Sigma1) * (x-mu1) - (x-mu2).' * inv(Sigma2) * (x-mu2);
G1_rhs = -2 * log(det(Sigma1)/det(Sigma2));

G = G1_lhs - G1_rhs;
Gf = matlabFunction(G);
clear x_1 x_2 x;

% Monte Carlo iterations
N = 10000;

% random generate setup
rng(0,'twister');
lb = -200;
ub = 200;
x = [(ub-lb).*rand(N,1) + lb, (ub-lb).*rand(N,1) + lb];

%% 
fig = figure(Renderer="painters"); 
hold all; grid on; grid minor; box on;
for i = 1:N
  x1 = x(i,1);
  x2 = x(i,2);
  val = Gf(x1,x2);
  if val <= 0
    plot(x1,x2,'.b',MarkerSize=8)
  else
    plot(x1,x2,'.r',MarkerSize=8)
  end
end
xlabel("$x_1$")
ylabel("$x_2$")
% saveas(fig,"plots/p2-region.png");

%% Risk 
N = 50000;
R1 = mvnrnd(mu1,Sigma1,N);  % should be for class 1
R2 = mvnrnd(mu2,Sigma2,N);  % should be for class 2

loss = zeros(2*N,1);
for i = 1:N
  loss(i) = ~(Gf(R1(i,1),R1(i,2)) <= 0);  % check for class 1
  loss(N+i) = ~(Gf(R2(i,1),R2(i,2)) > 0);  % check for class 2
end
risk = mean(loss);
