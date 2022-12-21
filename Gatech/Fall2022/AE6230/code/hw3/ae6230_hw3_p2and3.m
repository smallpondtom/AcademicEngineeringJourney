% AE6230 HW3 Problem 2 & 3
% Author: Tomoki Koike
% Reference: Dr. Cristina Riso "AE6230_Fall2022_L17_MDOF_Free_TypicalSection.m"

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Setup
m = 10.0;  % [kg]
J_E = 0.08;  % [kg-m^2]
c = 0.2;  % [m]
e = -0.2*c;  % offset of C from E (m, positive ahead) [m]
x_E = 0.4*c;  % position of E from the LE (m, positive backward) [m]
k_h = 1000.0;  % [N/m]
k_theta = 200.0;  % [N-m/rad]

% initial displacements (m and rad)
q0 = [-0.02; deg2rad(5.0)]; 

% initial velocities (m/s and rad/s)
qdot0 = zeros(2,1);

M = [m -m*e; -m*e J_E];  % inertia matrix
K = [k_h 0.0; 0.0 k_theta];  % stiffness matrix
[~,n] = size(M);

% Excitations
Q0 = [-10; 1.5];
omega0 = 15;  % [rad/s]
syms t real positive
Q = Q0 * sin(omega0 * t);

% modal viscous damping factors
zeta = [0.02; 0.02];


%% Problem 2
%% (1)
% compute eigenvalues and eigenvectors
[U, Lambda] = eig(K,M); 
lambda = diag(Lambda); 

% compute natural frequencies 
omega = sqrt(lambda);

% Eigenvector normalization to have unit modal mass
for i = 1:n
    U(:,i) = U(:,i)/sqrt(U(:,i)'*M*U(:,i));
end

% modal mass matrix (must be an identity matrix with this normalization)
Mbar = U'*M*U;

% modal stiffness matrix (must be the Omega2 matrix with this normalization)
Kbar = U'*K*U;

% modal matrix inverse
Uinv = U'*M;

% initial modal displacements
eta0 = Uinv*q0;

% initial modal velocities
etadot0 = Uinv*qdot0;

% Compute the modal excitation
N(t) = U.' * Q;

%% (2)
Hamp = @(wi,w0,zi) 1/sqrt((wi^2 - w0^2)^2 + 4*zi^2*w0^2);
phang = @(wi,w0,zi) atan2(2*zi*w0, wi^2 - w0^2);

H1 = Hamp(omega(1),omega0,zeta(1));
H2 = Hamp(omega(2),omega0,zeta(2));
theta1 = phang(omega(1),omega0,zeta(1));
theta2 = phang(omega(2),omega0,zeta(2));

%% (3)
eta1(t) = U(:,1).' * Q0 * H1 * sin(omega0*t - theta1);
eta2(t) = U(:,2).' * Q0 * H2 * sin(omega0*t - theta2);
q(t) = U(:,1)*eta1 + U(:,2)*eta2;
q = matlabFunction(q);

%% (4)
tspan = 0:0.001:2;
qval = q(tspan);
fig = figure(Renderer="painters",Position=[60 60 900 400]);
tile = tiledlayout(2,1,TileSpacing="tight",Padding="tight");
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

xlabel(tile,'$t$','FontSize',10,'Interpreter','latex')
ylabel(tile,'$q(t), \eta(t)$','FontSize',10,'Interpreter','latex')
saveas(fig,"plots/p2/response.png")

%% Problem 3
%% (1)
alpha = 1.0;
beta = 1e-5;
zeta = (alpha + beta*omega.^2)/2./omega;

%% (2)
omegad = omega .* sqrt(1 - zeta.^2);

%% (3)
Pt = @(t,w,wd,z) (1 - exp(-z*w*t)*(cos(wd*t) + z/sqrt(1-z^2)*sin(wd*t)))/wd^2;
eta21(t) = U(:,1).'*Q0*Pt(t,omega(1),omegad(1),zeta(1));
eta22(t) = U(:,2).'*Q0*Pt(t,omega(2),omegad(2),zeta(2));
q2(t) = U(:,1)*eta21(t) + U(:,2)*eta22(t);
q2 = matlabFunction(q2);

%% (4)
tspan = 0:0.001:10;
q2val = q2(tspan);
fig = figure(Renderer="painters",Position=[60 60 900 400]);
tile = tiledlayout(2,1,TileSpacing="tight");
  nexttile(1);
  plot(tspan,eta21(tspan),DisplayName="$\eta_1$")
  hold on; grid on; grid minor; box on;
  plot(tspan,q2val(1,:),DisplayName="$q_1$")
  hold off; legend;

  nexttile(2);
  plot(tspan,eta22(tspan),DisplayName="$\eta_2$")
  hold on; grid on; grid minor; box on; 
  plot(tspan,q2val(2,:),DisplayName="$q_2$")
  hold off; legend;

xlabel(tile,'$t$','FontSize',10,'Interpreter','latex')
ylabel(tile,'$q(t), \eta(t)$','FontSize',10,'Interpreter','latex')
saveas(fig,"plots/p3/response1.png")

%% (5)
e = -0.05*c;  % offset of C from E (m, positive ahead) [m]

M = [m -m*e; -m*e J_E];  % inertia matrix
K = [k_h 0.0; 0.0 k_theta];  % stiffness matrix

% compute eigenvalues and eigenvectors
[U, Lambda] = eig(K,M); 
lambda = diag(Lambda); 

% compute natural frequencies 
omega = sqrt(lambda);

% Eigenvector normalization to have unit modal mass
for i = 1:n
    U(:,i) = U(:,i)/sqrt(U(:,i)'*M*U(:,i));
end

% modal mass matrix (must be an identity matrix with this normalization)
Mbar = U'*M*U;

% modal stiffness matrix (must be the Omega2 matrix with this normalization)
Kbar = U'*K*U;

% modal matrix inverse
Uinv = U'*M;

% initial modal displacements
eta0 = Uinv*q0;

% initial modal velocities
etadot0 = Uinv*qdot0;

zeta = (alpha + beta*omega.^2)/2./omega;
omegad = omega .* sqrt(1 - zeta.^2);

eta31(t) = U(:,1).'*Q0*Pt(t,omega(1),omegad(1),zeta(1));
eta32(t) = U(:,2).'*Q0*Pt(t,omega(2),omegad(2),zeta(2));
q3(t) = U(:,1)*eta31(t) + U(:,2)*eta32(t);
q3 = matlabFunction(q3);

q3val = q3(tspan);
fig = figure(Renderer="painters",Position=[60 60 900 400]);
tile = tiledlayout(2,1,TileSpacing="tight");
  nexttile(1);
  plot(tspan,eta31(tspan),DisplayName="$\eta_1$")
  hold on; grid on; grid minor; box on;
  plot(tspan,q3val(1,:),DisplayName="$q_1$")
  hold off; legend;

  nexttile(2);
  plot(tspan,eta32(tspan),DisplayName="$\eta_2$")
  hold on; grid on; grid minor; box on; 
  plot(tspan,q3val(2,:),DisplayName="$q_2$")
  hold off; legend;

xlabel(tile,'$t$','FontSize',10,'Interpreter','latex')
ylabel(tile,'$q(t), \eta(t)$','FontSize',10,'Interpreter','latex')
saveas(fig,"plots/p3/response2.png")