% AE 6230 Final Problem 1
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic
clear ans;

%% Setup
m = 10.0;  % [kg]
J_E = 0.08;  % [kg-m^2]
c = 0.2;  % [m]
e = -0.2*c;  % offset of C from E (m, positive ahead) [m]
x_E = 0.4*c;  % position of E from the LE (m, positive backward) [m]
k_h = 1000.0;  % [N/m]
k_theta = 200.0;  % [N-m/rad]

% initial displacements (m and rad)
q0 = [-0.01; deg2rad(2)]; 

% initial velocities (m/s and rad/s)
qdot0 = zeros(2,1);

M = [m -m*e; -m*e J_E];  % inertia matrix
K = [k_h 0.0; 0.0 k_theta];  % stiffness matrix
[~,n] = size(M);

% modal viscous damping factors
zeta = [0.02; 0.02];

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

% damping natural frequencies
omegad = omega .* sqrt(1 - zeta.^2);

% Modal equations
etai = @(i,t) (exp(-zeta(i)*omega(i)*t) .* (eta0(i)*cos(omegad(i)*t) + ...
  (etadot0(i) + zeta(i)*omega(i)*eta0(i))/omegad(i) * sin(omegad(i)*t) ) );

% response
qt_j = @(j,t) U(j,1)*etai(1,t) + U(j,2)*etai(2,t);


% Plotting
tspan = 0:0.0005:5;
fig = figure(Renderer="painters",Position=[60 60 900 400]);
tile = tiledlayout(2,2,TileSpacing="compact",Padding="compact");

nexttile(1);
plot(tspan,etai(1,tspan),DisplayName="$\eta_1$")
hold on; grid on; grid minor; box on; legend;
ylabel("$\eta (t)$")

nexttile(2);
plot(tspan,etai(2,tspan),DisplayName="$\eta_2$")
hold on; grid on; grid minor; box on; legend;

nexttile(3);
plot(tspan,qt_j(1,tspan),DisplayName="$q_1$")
hold on; grid on; grid minor; box on; legend;
ylabel("$q(t)$")

nexttile(4);
plot(tspan,qt_j(2,tspan),DisplayName="$q_2$")
hold on; grid on; grid minor; box on; legend;

xlabel(tile,'$t$','FontSize',10,'Interpreter','latex')
saveas(fig,"plots/p1/responses.png")