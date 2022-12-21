% ISYE7750 HW4 Problem 2
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Prep
f_true = @(t) sin(12 .* (t + 0.2))./(t + 0.2);
tval = 0:0.001:1;
d = length(tval);

f = f_true(tval);

load hw04p2_data.mat
fig = figure(Renderer="painters");
  plot(T,y,'o')
  hold on; grid on; grid minor; box on;
  plot(tval, f,'-')
  hold off;
  xlabel("$t$")
  ylabel("$f(t)$")
% saveas(fig, "plots/p2-original.png");

%% (a)-1

% kernel regression
k = @(s,t,sigma) exp(-abs(t - s).^2 / 2 / sigma^2);

% Parameters
sigma = 0.5;
delta = 0.004;

% Create the kernel matrix 
K = zeros(M,M);
for i = 1:M
  for j = 1:M
    K(i,j) = k(T(i),T(j),sigma);
  end
end

% Compute the expansion coefficients
alpha_hat = (K + delta * eye(M)) \ y;

% Find estimate
f_hat = zeros(d,1);
f_hat_tm = zeros(M,1);
for i = 1:M
  f_hat = f_hat + alpha_hat(i) * transpose(k(tval, T(i), sigma));
  f_hat_tm = f_hat_tm + alpha_hat(i) * k(T, T(i), sigma);
end

fig = figure(Renderer="painters", Position=[60 60 900 600]);
  plot(T,y,'.',DisplayName="data", MarkerSize=25)
  hold on; grid on; grid minor; box on;
  plot(tval, f_true(tval), DisplayName="$f_{true}$")
  plot(tval, f_hat, DisplayName="$\hat{f}$")
  hold off; legend;
  xlabel("$t$")
  ylabel("$f(t)$")
% saveas(fig, "plots/p2/p2-fhat_and_ftrue.png");

%% (a)-2
% Compute the sample error
SE_arr = zeros(M,1);
for i = 1:M
  SE_arr(i) = abs(y(i) - f_hat_tm(i))^2;
end
SE = sum(SE_arr)^0.5;

% Compute the generalization error
f_hat_func = @(t,T,sigma) 0;
for i = 1:M
  f_hat_func = @(t,T,sigma) f_hat_func(t,T,sigma) + alpha_hat(i) * k(t, T(i), sigma);
end
GE = integral(@(t) abs(f_true(t) - f_hat_func(t,T,sigma)),0,1);

%% (b)
error_table = table;
sigmas = [0.5, 0.2, 1/20, 1/50, 1/100, 1/200];
error_table.sigma = sigmas.';

SE_values = zeros(1,length(sigmas));
GE_values = zeros(1,length(sigmas));

fig = figure(Renderer="painters", Position=[60 60 900 600]);
  plot(T,y,'.',DisplayName="data", MarkerSize=25)
  hold on; grid on; grid minor; box on;
  plot(tval, f_true(tval), DisplayName="$f_{true}$")
  xlabel("$t$")
  ylabel("$f(t)$")

ct = 1;
for sigma = sigmas

  % Create the kernel matrix 
  K = zeros(M,M);
  for i = 1:M
    for j = 1:M
      K(i,j) = k(T(i),T(j),sigma);
    end
  end
  
  % Compute the expansion coefficients
  alpha_hat = (K + delta * eye(M)) \ y;
  
  % Find estimate
  f_hat = zeros(d,1);
  f_hat_tm = zeros(M,1);
  for i = 1:M
    f_hat = f_hat + alpha_hat(i) * transpose(k(tval, T(i), sigma));
    f_hat_tm = f_hat_tm + alpha_hat(i) * k(T, T(i), sigma);
  end
  
  % Plotting
  plot(tval, f_hat, DisplayName="$\sigma="+num2str(sigma)+"$")
  
  % Compute the sample error
  SE_arr = zeros(M,1);
  for i = 1:M
    SE_arr(i) = abs(y(i) - f_hat_tm(i))^2;
  end
  SE = sum(SE_arr)^0.5;
  SE_values(ct) = SE;
  
  % Compute the generalization error
  f_hat_func = @(t,T,sigma) 0;
  for i = 1:M
    f_hat_func = @(t,T,sigma) f_hat_func(t,T,sigma) + alpha_hat(i) * k(t, T(i), sigma);
  end
  GE = integral(@(t) abs(f_true(t) - f_hat_func(t,T,sigma)),0,1);
  GE_values(ct) = GE;

  ct = ct + 1;
end

hold off; legend;
saveas(fig, "plots/p2/p2-b.png");

error_table.se = SE_values.';
error_table.ge = GE_values.';
error_table