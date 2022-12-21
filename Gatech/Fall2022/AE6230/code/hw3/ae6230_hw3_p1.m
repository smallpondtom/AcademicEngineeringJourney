% AE6230 HW3 Problem 1
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Setup
mw = 750;  % [kg]
mf = 5*mw;
l = 10;  % [m]
EI = 5e+6;  % [N-m^2]

%% (a)
% System matrices
M = diag([mf mw mw]);
K = 3*EI/l^3 * [2 -1 -1; -1 1 0; -1 0 1];
[m,n] = size(M);

% Compute the eigenvalues and the eigenvectors
[Uhat,Lambda] = eig(K,M);
omega = sqrt(diag(Lambda));
omega(1) = 0;

%% (b)
U = zeros(size(Uhat));

for i = 1:n
  U(:,i) = Uhat(:,i)/norm(Uhat(:,i),"inf");
end

%% (c) 

fig = figure(Renderer="painters",Position=[60 60 900 400]);
  plot([-l l],[0 0],'-k')
  hold on; grid on; grid minor; box on;
  plot(0,0,'or',MarkerSize=30)
  plot(-l,0,'og',MarkerSize=15)
  plot(l,0,'ob',MarkerSize=15)
  arrow([0 0],[0 U(1,1)],'EdgeColor', 'r', 'FaceColor', 'r')
  arrow([-l 0],[-l U(2,1)],'EdgeColor', 'g', 'FaceColor', 'g')
  arrow([l 0],[l U(3,1)],'EdgeColor', 'b', 'FaceColor', 'b')
  plot([-l 0 l], [U(2,1) U(1,1) U(3,1)], '--k')
  hold off;
  xlabel('$x$')
  ylabel('$y$')
  xlim([-l-1,l+1])
  ylim([-5,5])
saveas(fig,"plots/p1/modeshape1.png")

fig = figure(Renderer="painters",Position=[60 60 900 400]);
  plot([-l l],[0 0],'-k')
  hold on; grid on; grid minor; box on;
  plot(0,0,'or',MarkerSize=30)
  plot(-l,0,'og',MarkerSize=15)
  plot(l,0,'ob',MarkerSize=15)
  arrow([0 0],[0 U(1,2)],'EdgeColor', 'r', 'FaceColor', 'r')
  arrow([-l 0],[-l U(2,2)],'EdgeColor', 'g', 'FaceColor', 'g')
  arrow([l 0],[l U(3,2)],'EdgeColor', 'b', 'FaceColor', 'b')
  plot([-l 0 l], [U(2,2) U(1,2) U(3,2)], '--k')
  hold off;
  xlabel('$x$')
  ylabel('$y$')
  xlim([-l-1,l+1])
  ylim([-5,5])
saveas(fig,"plots/p1/modeshape2.png")

fig = figure(Renderer="painters",Position=[60 60 900 400]);
  plot([-l l],[0 0],'-k')
  hold on; grid on; grid minor; box on;
  plot(0,0,'or',MarkerSize=30)
  plot(-l,0,'og',MarkerSize=15)
  plot(l,0,'ob',MarkerSize=15)
  arrow([0 0],[0 U(1,3)],'EdgeColor', 'r', 'FaceColor', 'r')
  arrow([-l 0],[-l U(2,3)],'EdgeColor', 'g', 'FaceColor', 'g')
  arrow([l 0],[l U(3,3)],'EdgeColor', 'b', 'FaceColor', 'b')
  plot([-l 0 l], [U(2,3) U(1,3) U(3,3)], '--k')
  hold off;
  xlabel('$x$')
  ylabel('$y$')
  xlim([-l-1,l+1])
  ylim([-5,5])
saveas(fig,"plots/p1/modeshape3.png")

%% (4)
Uinv = inv(U);

%% (5)
q0 = [0.5;0;0];
qdot0 = [0;0;0];
eta0 = Uinv * q0;
eta0(2) = 0;
etadot0 = Uinv * qdot0;

% Verify
syms t positive real
syms A_1 A_c2 A_c3 B_1 A_s2 A_s3 real

eta1(t) = A_1 * t + B_1;
eta2(t) = A_c2 * cos(omega(2)*t) + A_s2 * sin(omega(2)*t);
eta3(t) = A_c3 * cos(omega(3)*t) + A_s3 * sin(omega(3)*t);
q(t) = U(:,1)*eta1 + U(:,2)*eta2 + U(:,3)*eta3;
qdot(t) = diff(q,t);
eqn1 = q(0) == [0.5; 0; 0];
eqn2 = qdot(0) == [0; 0; 0];
ic_sol = solve([eqn1 eqn2], [A_1 A_c2 A_c3 B_1 A_s2 A_s3]);

Ac2 = sign(ic_sol.A_c2)*sqrt(ic_sol.A_c2^2+ic_sol.A_s2^2);
phi2 = atan2(-ic_sol.A_s2, ic_sol.A_c2);
Ac3 = sign(ic_sol.A_c3)*sqrt(ic_sol.A_c3^2+ic_sol.A_s3^2);
phi3 = atan2(-ic_sol.A_s3, ic_sol.A_c3);

%% (6)
zeta = [0; 0.04; 0.04];
omegad = omega .* sqrt(1 - zeta);
eta = @(t,z,w,wd,e0,ed0) exp(-z*w*t)*(e0*cos(wd*t)+(ed0+z*w*e0)/wd*sin(wd*t));
eta1(t) = 5/14;
eta2(t) = eta(t,zeta(2),omega(2),omegad(2),eta0(2),etadot0(2));
eta3(t) = eta(t,zeta(3),omega(3),omegad(3),eta0(3),etadot0(3));

% q1(t) = U(1,1)*eta1 + U(1,2)*eta2 + U(1,3)*eta3;
% q2(t) = U(2,1)*eta1 + U(2,2)*eta2 + U(2,3)*eta3;
% q3(t) = U(3,1)*eta1 + U(3,2)*eta2 + U(3,3)*eta3;
q(t) = U(:,1)*eta1 + U(:,2)*eta2 + U(:,3)*eta3;
q = matlabFunction(q);

%% (7)
tspan = 0:0.01:20;
qval = q(tspan);
fig = figure(Renderer="painters",Position=[60 60 900 400]);
t = tiledlayout(3,1,TileSpacing="tight",Padding="tight");
  nexttile(1);
  plot(tspan,eta1(tspan),DisplayName="$\eta_1$")
  hold on; grid on; grid minor; box on;
  plot(tspan,qval(1,:),DisplayName="$q_1$")
  hold off; legend;

  nexttile(2);
  plot(tspan,eta2(tspan),DisplayName="$\eta_2$")
  hold on; grid on; grid minor; box on; 
  plot(tspan,qval(2,:),DisplayName="$q_2$")
  hold off; legend;

  nexttile(3);
  plot(tspan,eta3(tspan),DisplayName="$\eta_3$")
  hold on; grid on; grid minor; box on;
  plot(tspan,qval(3,:),DisplayName="$q_3$")
  hold off; legend;

xlabel(t,'$t$','FontSize',10,'Interpreter','latex')
ylabel(t,'$q(t), \eta(t)$','FontSize',10,'Interpreter','latex')
saveas(fig,"plots/p1/response.png")