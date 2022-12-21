% AE6230 HW4 Problem 1
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Setup
params.rhoA = 0.5;  % [kg/m]
params.l = 1;  % [m]
params.EI = 5;  % [N-m^2]

%% (1)
syms x real
syms A_1 A_2 B_1 B_2 real 
syms alpha l real positive 

X(x) = A_1*sin(alpha*x) + B_1*cos(alpha*x) + A_2*sinh(alpha*x) + B_2*cosh(alpha*x);
dX(x) = diff(X,x);
d2X(x) = diff(dX,x);
d3X(x) = diff(d2X,x);

bc1 = X(0) == 0;
bc2 = d2X(0) == 0;
bc3 = d2X(l) == 0;
bc4 = d3X(l) == 0;

coeffs = [A_1 B_1 A_2 B_2].';
bcs = [bc1; bc2; bc3; bc4];
[H,~] = equationsToMatrix(bcs,coeffs);
det(H);

tmp = subs(H*coeffs,[A_1 B_1 B_2],[1 0 0])==0;
Hs = solve(tmp(3),A_2);
Hsf = matlabFunction(Hs);
Xf = matlabFunction(X);

clear x A_1 A_2 B_1 B_2 alpha l;
clear bc1 bc2 bc3 bc4 bcs X dX d2X d3X coeffs H;

%% (2)
alpha_i = pi/4 + pi * [1 2 3 4];

%% (3)
omega_i = alpha_i.^2 * sqrt(params.EI / params.rhoA);

%% (4)
x = linspace(0.0,params.l,201);  % space discretization 
phis = cell(length(alpha_i),1);  % preallocate mode shapes
Xis = cell(length(alpha_i),1);

fig = figure(Renderer="painters",Position=[0 0 1200 900]); hold all; 
grid on; grid minor; box on;
for i = 1:length(alpha_i)   
  A1i = 1.0;
  A2i = Hsf(alpha_i(i), params.l);
  B1i = 0; B2i = 0;

  Xi = Xf(x,A1i,A2i,B1i,B2i,alpha_i(i));  % eigenfunction
  Xis{i} = Xi;
  
  % compute and store the ith mode shape
  phis{i} = Xi/max(abs(Xi));
     
  % plot ith mode shape
  plot(x,phis{i},'-','LineWidth',2);
end
xlabel("$x$ [m]")
ylabel("$\phi(x)$")
saveas(fig,"plots/p1/p1_mode-shapes.png");