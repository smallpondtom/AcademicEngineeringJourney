% ISYE7750 HW4 Problem 4
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% (a)
A = [1.01 0.99; 0.99 0.98];
[V,D] = eig(A);

%% (b)
xb = A \ [1;1];

%% (c)
xc = A \ [1.1;1];
e = [0.1; 0];
tmp1 = norm(xc-xb)^2;
tmp2 = norm(A \ e)^2;

%% (d)
syms e_1 e_2 
e = [e_1; e_2];
B = inv(A);
eqn1 = (B(1,1)*e_1 + B(1,2)*e_2)^2 + (B(2,1)*e_1 + B(2,2)*e_2)^2 == (e_1^2 + e_2^2) / D(1,1)^2;
eqn2 = e_1^2 + e_2^2 == 1;
max_noise_vec = solve([eqn1 eqn2],[e_1, e_2]);
double(max_noise_vec.e_1);
double(max_noise_vec.e_2);

%% (e)
syms e_1 e_2
e = [e_1; e_2];
eqn1 = (B(1,1)*e_1 + B(1,2)*e_2)^2 + (B(2,1)*e_1 + B(2,2)*e_2)^2 == (e_1^2 + e_2^2) / D(2,2)^2;
eqn2 = e_1^2 + e_2^2 == 1;
min_noise_vec = solve([eqn1 eqn2],[e_1, e_2]);
double(min_noise_vec.e_1);
double(min_noise_vec.e_2);

%% (f)
D_f = inv(D)^2;
mse = trace(D_f);

%% (g)
err = [];
for i = 1:10000
  e = randn(2,1);
  xe = A \ ([1;1] + e);
  err_i = norm(xe - xb)^2;
  err = [err err_i];
end
mse_mc = mean(err);

fig = figure(Renderer="painters",Position=[60 60 800 600]);
  plot(1:10000,err,'rx',MarkerSize=10)
  hold on; grid on; grid minor; box on;
  yline(mse_mc,'-b','mean',LineWidth=3.0,LabelHorizontalAlignment='left',FontSize=15)
  yline(mse, '--g', 'MSE', LineWidth=3.0,LabelHorizontalAlignment='right',FontSize=15)
  hold off;
  xlabel("Trials")
  ylabel("Squared Errors")
saveas(fig, "plots/p4/mse.png")