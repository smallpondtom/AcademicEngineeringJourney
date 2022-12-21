% ISYE7750 HW5 Problem 2
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% (a)
% Matrices
H = [2 1; 1 2];
b = [-1; -3];

% Function f(x)
f = @(x) 0.5 * x.' * H * x - b.' * x;

% Find min{f}
xmin = 2 * inv(H + H.') * b;
fmin = f(xmin);

%% (b)
syms x_1 x_2
xsym = [x_1; x_2];
fsym = f(xsym);

%% (c)-1
fpoly = matlabFunction(fsym);
x1 = linspace(-5, 5, 1000);
x2 = linspace(-5, 5, 1000);
[X1,X2] = meshgrid(x1,x2);
F = fpoly(X1,X2);

% Points for arrows
arrow1i = [xmin(1) xmin(2)];
arrow1f = [xmin(1)+3*cosd(45) xmin(2)+3*sind(45)];

arrow2i = arrow1i;
arrow2f = [xmin(1)+3*cosd(135) xmin(2)+3*sind(135)];

fig = figure(Renderer="painters");
  contourf(X1,X2,F);
  hold on; grid on; grid minor; box on; axis equal;
  arrow(arrow1i,arrow1f, 'EdgeColor', 'r', 'FaceColor', 'r')
  arrow(arrow2i,arrow2f, 'EdgeColor', 'r', 'FaceColor', 'r')
  plot(xmin(1), xmin(2), 'r.', MarkerSize=14)
  hold off;
  xlim([-5 5])
  ylim([-5 5])
  xlabel("$x_1$")
  ylabel("$x_2$")
saveas(fig,"plots/p2/p2c_contour.png")

%% (c)-2
[V,D] = eig(H);

%% (d)
x1 = linspace(-1.8, 2.2, 1000);
x2 = linspace(-4, 0.5, 1000);
[X1,X2] = meshgrid(x1,x2);
F = fpoly(X1,X2);

[x_gd,~] = gdsolve_store(H,b,1e-6,4,[0;0]);
[x_cg,~] = cgsolve_store(H,b,1e-6,2,[0;0]);

%% GD
fig = figure(Renderer="painters");
  contourf(X1,X2,F);
  hold on; grid on; grid minor; box on; axis equal;
  plot(0,0,'.g',MarkerSize=14)
  plot(xmin(1), xmin(2), 'r.', MarkerSize=14)
  plot(x_gd(1,:),x_gd(2,:),'-g',lineWidth=1)
  hold off;
  xlabel("$x_1$")
  ylabel("$x_2$")
saveas(fig,"plots/p2/p2d-gd-func.png");

%% CG
fig = figure(Renderer="painters");
  contourf(X1,X2,F);
  hold on; grid on; grid minor; box on; axis equal;
  plot(0,0,'.g',MarkerSize=14)
  plot(xmin(1), xmin(2), 'r.', MarkerSize=14)
  plot(x_gd(1,:),x_gd(2,:),'--g',lineWidth=0.5)
  plot(x_cg(1,:),x_cg(2,:),'-r',lineWidth=1)
  hold off;
  xlabel("$x_1$")
  ylabel("$x_2$")
saveas(fig,"plots/p2/p2d-cg-func.png");

%% Functions
function [x, iter] = gdsolve_store(H, b, tol, maxiter, x0)
xk = x0;  % initial guess
rk = b - H * xk;
iter = 0;
bnorm = norm(b);
x = [xk];

while (norm(rk) / bnorm)>=tol
  q = H * rk;
  alphak = (rk.' * rk) / (rk.' * q);
  xk = xk + alphak * rk;  % update solution vector x at k+1 = k
  rk = rk - alphak * q;  % update residual vector at k+1 = k
  
  x = [x xk];
  if iter > maxiter
    break;
  end
  iter = iter + 1;  % count iteration
end

end

function [x, iter] = cgsolve_store(H, b, tol, maxiter, x0)
xk = x0;  % initial guess
rk = b - H * xk;
dk = rk;  % basis
iter = 0;
bnorm = norm(b);
x = [xk];

while (norm(rk) / bnorm)>=tol
  q = H * dk;
  p = rk.' * rk;

  alphak = p / (dk.' * q);
  xk = xk + alphak * dk;  % update solution vector x at k+1 = k
  rkp1 = rk - alphak * q;  % compute the k+1 residual vector
  
  betak = (rkp1.' * rkp1) /  p;
  dk = rkp1 + betak * dk;  % update the basis vector d at k+1 = k

  rk = rkp1;  % update residual vector at k+1 = k
  x = [x xk];
  if iter > maxiter
    break;
  end
  iter = iter + 1;  % count iteration
end

end