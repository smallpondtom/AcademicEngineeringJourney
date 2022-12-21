% ISYE7750 HW5 Problem 1
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Setup
% Legendre Polynomials in [0, 1]
lpoly = @(p,z) sqrt(2)*sqrt((2*p+1)/2)*legendreP(p, 2*z-1);

% True function
ftrue = @(t) sin(12.*(t+0.2))./(t+0.2);

% Import data
load hw05p1_clusterdata.mat
data.T = T;
data.y = y;
clear T y

%% (a)
% Find the solution to least square problem
A = [lpoly(0,data.T), lpoly(1,data.T), lpoly(2,data.T), lpoly(3,data.T)];
what = (A.' * A) \ A.' * data.y;
SE = norm(data.y - A*what);  % sampling error

% Solution nonlinear regression
nr = @(t) 0;
for i = 0:3
  nr = @(t) nr(t) + what(i+1) * lpoly(i,t);
end

% Solution for [0,1]
tspan = 0:0.001:1;
soln_a = nr(tspan);

% Plot results
fig = figure(Renderer="painters");
  plot(data.T,data.y,'o')
  hold on; grid on; grid minor; box on;
  plot(tspan, soln_a)
  hold off
  xlabel("$T$")
  ylabel("$y$")
saveas(fig,"plots/p1a.png");

%% (b)
% Compute the generalized error
GE = sqrt(integral(@(t) (ftrue(t) - nr(t)).^2, 0, 1));

%% (c)
p = [5 10 15 20 25];  % order of polynomials
% values to report
se = [];  
ge = [];
sigma_min = [];
sigma_max = [];

% Preallocate structure to store weights 
ct = 1;  % counter
for pi = p
  % Create A matrix
  A = [];
  for j = 0:pi
    A = [A lpoly(j,data.T)];
  end

  % Compute the weights
  what = (A.' * A) \ A.' * data.y;

  % Compute sample error
  SE = norm(data.y - A*what);
  se = [se SE];

  % Solution nonlinear regression
  nr = @(t) 0;
  for i = 0:pi
    nr = @(t) nr(t) + what(i+1) * lpoly(i,t);
  end

  % Compute the generalized error
  GE = sqrt(integral(@(t) (ftrue(t) - nr(t)).^2, 0, 1));
  ge = [ge GE];

  % SVD
  [U,S,V] = svd(A);
  sigma_min = [sigma_min min(min(S(S>0)))];
  sigma_max = [sigma_max max(max(S))];

  % Plot the sample values and solution overlaid
  fig = figure(Renderer="painters");
    plot(data.T,data.y,'o',HandleVisibility='off')
    hold on; grid on; grid minor; box on;
    plot(tspan, nr(tspan),DisplayName="N="+num2str(pi+1))
    hold off; legend;
    xlabel("$T$")
    ylabel("$y$")
  saveas(fig,"plots/p1c_N="+num2str(pi+1)+".png");
end

% Plot the sample error and generalized error w.r.t to the orders
fig = figure(Renderer="painters");
  plot(p+1, se, '-xr', MarkerSize=10, DisplayName="SE")
  hold on; grid on; grid minor; box on;
  plot(p+1, ge, '-ob', MarkerSize=10, DisplayName="GE")
  hold off; legend;
  xlabel("$N$")
  ylabel("Error")
saveas(fig,"plots/p1c_errors.png");

%% (d)
% Create A matrix
pi = 24;

A = [];
for j = 0:pi
  A = [A lpoly(j,data.T)];
end

% Compute the weights
what = (A.' * A) \ A.' * data.y;

% Compute sample error
SE = norm(data.y - A*what);

% Solution nonlinear regression
nr = @(t) 0;
for i = 0:pi
  nr = @(t) nr(t) + what(i+1) * lpoly(i,t);
end

% Compute the generalized error
GE = sqrt(integral(@(t) (ftrue(t) - nr(t)).^2, 0, 1));

% SVD
[U,S,V] = svd(A,'econ');
sig = diag(S);

% Plot singular values
fig = figure(Renderer="painters");
  plot(sig,'-o')
  grid on; grid minor; box on;
  xlabel("entry, $i = 1,..,N$")
  ylabel("$\sigma$")
saveas(fig,"plots/p1d_sigma.png");

% Truncate SVD and recompute solution
R = 23;
Vt = V(:,1:R);
St = S(1:R,1:R);
Ut = U(:,1:R);
what_t = Vt * inv(St) * Ut.' * data.y;

% Compute sample error
SE_t = norm(data.y - A*what_t);

% Solution nonlinear regression
nr_t = @(t) 0;
for i = 0:pi
  nr_t = @(t) nr_t(t) + what_t(i+1) * lpoly(i,t);
end

% Compute the generalized error
GE_t = sqrt(integral(@(t) (ftrue(t) - nr_t(t)).^2, 0, 1));

% Plot results
fig = figure(Renderer="painters");
  plot(data.T,data.y,'o',HandleVisibility='off')
  hold on; grid on; grid minor; box on;
  plot(tspan,nr(tspan), DisplayName="original")
  plot(tspan,nr_t(tspan), DisplayName="truncated")
  plot(tspan,ftrue(tspan), '--', DisplayName="$f_{true}$")
  hold off; legend;
  xlabel("$T$")
  ylabel("$y$")
saveas(fig,"plots/p1d-ls.png");

%% (e)

% Truncate SVD and recompute solution
Rs = 5:25;
ge_t = [];
se_t = [];

for R = Rs
  Vt = V(:,1:R);
  St = S(1:R,1:R);
  Ut = U(:,1:R);
  what_t = Vt * inv(St) * Ut.' * data.y;
  
  % Compute sample error
  SE_t = norm(data.y - A*what_t);
  se_t = [se_t SE_t];
  
  % Solution nonlinear regression
  nr_t = @(t) 0;
  for i = 0:pi
    nr_t = @(t) nr_t(t) + what_t(i+1) * lpoly(i,t);
  end
  
  % Compute the generalized error
  GE_t = sqrt(integral(@(t) (ftrue(t) - nr_t(t)).^2, 0, 1));
  ge_t = [ge_t GE_t];
end 

% Plot the sample error and generalized error w.r.t to the orders
fig = figure(Renderer="painters");
  plot(Rs, se_t, '-xr', MarkerSize=10, DisplayName="SE")
  hold on; grid on; grid minor; box on;
  plot(Rs, ge_t, '-ob', MarkerSize=10, DisplayName="GE")
  hold off; legend;
  xlabel("$N$")
  ylabel("Error")
saveas(fig,"plots/p1e_errors.png");

%% (f)
% Create A matrix
pi = 24;

A = [];
for j = 0:pi
  A = [A lpoly(j,data.T)];
end
[~,N] = size(A);

% Delta for ridge regression
delta = 0.01;

% Compute the weights
what_r = (A.' * A + delta * eye(N)) \ A.' * data.y;

% Compute sample error
SE = norm(data.y - A*what_r);

% Solution nonlinear regression
nr = @(t) 0;
for i = 0:pi
  nr = @(t) nr(t) + what_r(i+1) * lpoly(i,t);
end

% Compute the generalized error
GE = sqrt(integral(@(t) (ftrue(t) - nr(t)).^2, 0, 1));

% Plot results
fig = figure(Renderer="painters");
  plot(data.T,data.y,'o',HandleVisibility='off')
  hold on; grid on; grid minor; box on;
  plot(tspan,nr(tspan), DisplayName="ridge reg")
  plot(tspan,ftrue(tspan), '--', DisplayName="$f_{true}$")
  hold off; legend;
  xlabel("$T$")
  ylabel("$y$")
saveas(fig,"plots/p1f-ls.png");

%%
D = [linspace(0,0.0001,10) linspace(0.00011,0.001,10) linspace(0.0011,0.01,10) linspace(0.011,0.1,10) linspace(0.11,10,20)];
ge = [];
se = [];

for delta = D
  % Compute the weights
  what_r = (A.' * A + delta * eye(N)) \ A.' * data.y;
  
  % Compute sample error
  SE = norm(data.y - A*what_r);
  se = [se SE];
  
  % Solution nonlinear regression
  nr = @(t) 0;
  for i = 0:pi
    nr = @(t) nr(t) + what_r(i+1) * lpoly(i,t);
  end
  
  % Compute the generalized error
  GE = sqrt(integral(@(t) (ftrue(t) - nr(t)).^2, 0, 1));
  ge = [ge GE];
end 

%%
% Plot the sample error and generalized error w.r.t to the orders
fig = figure(Renderer="painters",Position=[60 60 800 300]);
  plot(D, se, '-xr', MarkerSize=10, DisplayName="SE")
  hold on; grid on; grid minor; box on;
  plot(D, ge, '-ob', MarkerSize=10, DisplayName="GE")
  hold off; legend;
  xlabel("$\delta$")
  ylabel("Error")
saveas(fig,"plots/p1f_errors.png");

%%
fig = figure(Renderer="painters",Position=[60 60 800 300]);
  plot(D(1:31), se(1:31), '-xr', MarkerSize=10, DisplayName="SE")
  hold on; grid on; grid minor; box on;
  plot(D(1:31), ge(1:31), '-ob', MarkerSize=10, DisplayName="GE")
  hold off; legend;
  xlabel("$\delta$")
  ylabel("Error")
  xlim([0,0.011])
saveas(fig,"plots/p1f_errors_closeup.png");

%%
fig = figure(Renderer="painters",Position=[60 60 800 300]);
  plot(D(1:20), se(1:20), '-xr', MarkerSize=10, DisplayName="SE")
  hold on; grid on; grid minor; box on;
  plot(D(1:20), ge(1:20), '-ob', MarkerSize=10, DisplayName="GE")
  hold off; legend;
  xlabel("$\delta$")
  ylabel("Error")
saveas(fig,"plots/p1f_errors_closeup2.png");