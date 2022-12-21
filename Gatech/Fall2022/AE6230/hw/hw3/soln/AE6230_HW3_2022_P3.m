%% This script solves HW3 Problem 3

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc

% define colors
c1 = [0.0000, 0.4470, 0.7410];
c2 = [0.8500, 0.3250, 0.0980];


%% Choose design

% flag to pick the design to be analyzed
%
% 1 -> e = -0.2c
% 2 -> e = -0.05 c
design_case = 1;


%% Problem parameters

% mass (kg)
m = 10.0;

% moment of inertia about E (kg*m2)
J_E = 0.08;

% chord (m)
c = 0.2;

% offset of C from E (m, positive ahead)
switch design_case
    case 1
        e = -0.2*c;
    case 2
        e = -0.05*c;
end

% position of E from the LE (m, positive backward)
x_E = 0.4*c;

% plunge stiffness (N/m)
k_h = 1000.0;

% pitch stiffness (Nm/rad)
k_theta = 200.0;

% initial displacements (m and rad)
q_0 = zeros(2,1); 

% initial velocities (m/s and rad/s)
qdot_0 = zeros(2,1);

% excitation components (N and N/m)
Q_0 = [-10.0; 1.5];

% proportional damping coefficients (-)
alpha = 1.0; beta = 0.00001;

% initial and final time, time step (s)
t_i = 0.0; t_f = 10.0; dt = 0.001; t = t_i:dt:t_f; n_t = length(t);

% number of modes (same as the number of DOFs)
n_m = 2;


%% Build matrices

% build the mass matrix
M = [m -m*e; -m*e J_E];

% build the stiffness matrix
K = [k_h 0.0; 0.0 k_theta];

% build the proportional damping matrix
C = alpha*M+beta*K;


%% Start timer for modal transient response

% initial time
t_modal_i = tic;


%% Eigenvalues and eigenvectors using eig

% compute eigenvalues and eigenvectors
[U, Omega2] = eig(K,M); omega2 = diag(Omega2); 

% compute natural frequencies (rad/s and Hz)
omega = sqrt(omega2); freq = omega/(2.0*pi);


%% Eigenvector normalization to have unit modal mass

% loop the eigenvectors
for i = 1:n_m
    
    % normalize for unit modal mass
    U(:,i) = U(:,i)/sqrt(U(:,i)'*M*U(:,i));

end


%% Modal mass and stiffness matrices

% modal mass matrix (must be an identity matrix with this normalization)
M_bar = U'*M*U;

% modal stiffness matrix (must be the Omega2 matrix with this normalization)
K_bar = U'*K*U;

% modal damping matrix (must be diagonal)
C_bar = U'*C*U;

% modal matrix inverse
U_inv = U'*M;


%% Modal excitation

% components of the modal excitation (but for the sinusoidal function)
N_0 = U'*Q_0;


%% Q1 - Modal viscous damping factors

% compute the modal viscous damping factors
zeta = 0.5*(alpha./omega+beta.*omega);


%% Q2 - Damped modal frequencies

% compute the damped modal frequencies
omega_d = omega.*sqrt(1.0-zeta.^2);


%% Q3 - Analytical steady-state response

% static responses of the modal coordinates
eta_0 = N_0./(omega.^2);

% auxiliary vector
B = zeta.*omega./omega_d;

% forced responses of the modal coordinates
eta = eta_0.*(1.0-exp(-zeta.*omega.*t).*(cos(omega_d*t)+B.*sin(omega_d*t)));

% recover solution
q = U*eta;


%% Stop timer for modal steady-state response

% elapsed time for modal steady-state response
t_modal_f = toc(t_modal_i);


%% Start timer for direct steady-state response

% initial time
t_direct_i = tic;


%% Numerical free response (for verification)

% build the state matrix including damping
A = [zeros(2) eye(2); -inv(M)*K -inv(M)*C];

% build the load vector except for time dependency
f = [0.0; 0.0; M\Q_0];

% time the march state-space equations
[t_num, y_num] = ode45(@(t_num,y_num)dydt(t_num,y_num,A,f),t,[q_0; qdot_0],odeset('RelTol',1.0e-12)); 

% extract numerical q
q_num = y_num(:,1:n_m)';


%% Stop timer for direct transient response

% elapsed time for direct transient response
t_direct_f = toc(t_direct_i);


%% Verify modal matrices

% compute modal mass matrix error
M_bar_error = max(max(abs(eye(2)-M_bar)));

% compute modal stiffness matrix error
K_bar_error = max(max(abs(Omega2-K_bar)));

% compute modal damping matrix error
C_bar_error = max(max(abs(diag(2.0*zeta.*omega)-C_bar)));


%% Verify modal excitation

% compute excitation error
Q_0_error = max(abs(Q_0-U_inv'*N_0));


%% Verify solution

% compute solution error for q_1
q_1_error = max(max(abs(q_num(1,:)-q(1,:))));

% compute solution error for q_2
q_2_error = max(max(abs(q_num(2,:)-q(2,:))));


%% Save results for comparison

% save database 
save(strcat('forced_step_case_',num2str(design_case),'.mat'));


%% Q4 - Plot time histories

% when the mode shapes are normalized to have unit modal mass the modal 
% coordinates have units of kg^{1/2}*m for this problem

% plot time histories of the modal coordinates
fig = figure(100); set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1); hold all;
plot(t,eta(1,:),'LineWidth',2); 
plot([t(1) t(end)],[eta_0(1) eta_0(1)],'k--');
axis([t(1) t(end) 0.0 0.06]); ax = gca; ax.FontSize = 28; yticks(0.0:0.01:0.06);
ylabel('$\eta_1$ (kg$^{1/2}$m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
subplot(2,1,2); hold all;
plot(t,eta(2,:),'LineWidth',2); 
plot([t(1) t(end)],[eta_0(2) eta_0(2)],'k--');
axis([t(1) t(end) 0.0 0.006]); ax = gca; ax.FontSize = 28; yticks(0.0:0.001:0.006); 
ylabel('$\eta_2$ (kg$^{1/2}$m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,strcat('eta_forced_step_case_',num2str(design_case),'.pdf'),'Resolution',300);

% plot time histories of the original coordinates
fig = figure(200); set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1); hold all;
plot(t,q(1,:),'LineWidth',2); 
plot([t(1) t(end)],[eta_0(1)*U(1,1)+eta_0(2)*U(1,2) eta_0(1)*U(1,1)+eta_0(2)*U(1,2)],'k--');
axis([t(1) t(end) -0.02 0.0]); ax = gca; ax.FontSize = 28; hold all; yticks(-0.02:0.004:0.0);
set(gca, 'YDir','reverse');
ylabel('$h_E$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
subplot(2,1,2); hold all;
plot(t,rad2deg(q(2,:)),'-','LineWidth',2); 
plot([t(1) t(end)],[rad2deg(eta_0(1)*U(2,1)+eta_0(2)*U(2,2)) rad2deg(eta_0(1)*U(2,1)+eta_0(2)*U(2,2))],'k--');
axis([t(1) t(end) -0.3 1.2]); ax = gca; ax.FontSize = 28; yticks(-0.3:0.3:1.2);
ylabel('$\theta$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,strcat('q_forced_step_case_',num2str(design_case),'.pdf'),'Resolution',300);

% verity time histories of the original coordinates
fig = figure(300); set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1); hold all;
plot(t,q(1,:),'LineWidth',2); 
plot(t,q_num(1,:),'--','LineWidth',2); 
axis([t(1) t(end) -0.02 0.0]); ax = gca; ax.FontSize = 28; yticks(-0.02:0.004:0.0);
set(gca, 'YDir','reverse');
ylabel('$h_E/c$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
hleg = legend('Analytical','Numerical'); hleg.NumColumns = 2;
subplot(2,1,2); hold all;
plot(t,rad2deg(q(2,:)),'-','LineWidth',2); 
plot(t,rad2deg(q_num(2,:)),'--','Color',c2,'LineWidth',2);  
axis([t(1) t(end) -0.3 1.2]); ax = gca; ax.FontSize = 28; yticks(-0.3:0.3:1.2);
ylabel('$\theta$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,strcat('q_forced_step_check_case_',num2str(design_case),'.pdf'),'Resolution',300);


%% State-space model for numerical integration

% state velocity function
function ydot = dydt(~,y,A,f)

    % compute state velocity
    ydot = A*y+f;

end