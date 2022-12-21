%% This script solves HW3 Problem 2

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc

% define colors
c1 = [0.0000, 0.4470, 0.7410];
c2 = [0.8500, 0.3250, 0.0980];


%% Problem parameters

% mass (kg)
m = 10.0;

% moment of inertia about E (kg*m2)
J_E = 0.08;

% chord (m)
c = 0.2;

% offset of C from E (m, positive ahead)
e = -0.2*c;

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

% excitation frequency (rad/s)
omega_0 = 15.0;

% modal viscous damping factors (-)
zeta_1 = 0.02; zeta_2 = 0.02; zeta = [zeta_1; zeta_2];

% initial and final time, time step (s)
t_i = 0.0; t_f = 20.0; dt = 0.001; t = t_i:dt:t_f; n_t = length(t);

% number of modes (same as the number of DOFs)
n_m = 2;


%% Build matrices

% build the mass matrix
M = [m -m*e; -m*e J_E];

% build the stiffness matrix
K = [k_h 0.0; 0.0 k_theta];


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

% modal matrix inverse
U_inv = U'*M;


%% Q1 - Modal excitation

% components of the modal excitation (but for the sinusoidal function)
N_0 = U'*Q_0;


%% Q2 - Magnitudes and phase delays of the modal frequency response functions

% compute the modal frequency response functions at omega_0
H = 1.0./((omega.^2-omega_0^2)+2.0j*zeta.*omega*omega_0);

% compute the magnitudes and phase delays
H_abs = abs(H); H_phase = atan2(-imag(H),real(H));


%% Q3 - Analytical steady-state response

% amplitudes of the steady-state responses of the modal coordinates
eta_0 = N_0.*H_abs;

% steady-state responses of the modal coordinates
eta = eta_0.*sin(omega_0*t-H_phase);

% recover solution
q = U*eta;


%% Stop timer for modal steady-state response

% elapsed time for modal steady-state response
t_modal_f = toc(t_modal_i);


%% Start timer for direct steady-state response

% initial time
t_direct_i = tic;


%% Numerical free response (for verification)

% the code below verifies the steady-state response against time marching,
% where the time marching solution includes the transient terms from the
% homogeneous solution

% to solve the transient response via time marching it requires assigning
% some initial conditions, which are chosen to be zero since they do not
% change the steady-state response anyway

% the plot of the time-marching vs. analytical results show that the
% time-marching solution satisfies the given ICs (differently from the
% steady-state solution) and converges to the analytical steady-state
% response once the transient terms have vanished

% set modal viscous damping matrix (accounting for unit modal mass)
C_bar = 2.0*diag(omega.*zeta);

% reverse engineer viscous damping matrix that gives the above matrix
C = U_inv'*C_bar*U_inv;

% build the state matrix including damping
A = [zeros(2) eye(2); -inv(M)*K -inv(M)*C];

% build the load vector except for time dependency
f = [0.0; 0.0; M\Q_0];

% time the march state-space equations
[t_num, y_num] = ode45(@(t_num,y_num)dydt(t_num,y_num,A,f,omega_0),t,[q_0; qdot_0],odeset('RelTol',1.0e-12)); 

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


%% Verify modal excitation

% compute excitation error
Q_0_error = max(abs(Q_0-U_inv'*N_0));


%% Verify solution

% compute solution error for q_1
q_1_error = max(max(abs(q_num(1,:)-q(1,:))));

% compute solution error for q_2
q_2_error = max(max(abs(q_num(2,:)-q(2,:))));


%% Q4 - Plot time histories

% when the mode shapes are normalized to have unit modal mass the modal 
% coordinates have units of kg^{1/2}*m for this problem

% plot time histories of the modal coordinates
fig = figure(100); hold all; set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1);
plot(t,eta(1,:),'LineWidth',2); axis([t(1) t(end)/10 -0.03 0.03]); yticks(-0.03:0.015:0.03);
ax = gca; ax.FontSize = 28; 
ylabel('$\eta_1$ (kg$^{1/2}$m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
subplot(2,1,2);
plot(t,eta(2,:),'LineWidth',2); axis([t(1) t(end)/10 -0.03 0.03]); yticks(-0.03:0.015:0.03);
ax = gca; ax.FontSize = 28; 
ylabel('$\eta_2$ (kg$^{1/2}$m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'eta_forced_harmonic.pdf','Resolution',300);

% plot time histories of the original coordinates
fig = figure(200); set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1); hold all;
plot(t,q(1,:),'LineWidth',2); axis([t(1) t(end)/10 -0.01 0.01]); yticks(-0.01:0.005:0.01);
ax = gca; ax.FontSize = 28; hold all; 
set(gca, 'YDir','reverse');
ylabel('$h_E$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
subplot(2,1,2); hold all;
plot(t,rad2deg(q(2,:)),'-','LineWidth',2); axis([t(1) t(end)/10 -1.0 1.0]); yticks(-1.0:0.5:1.0);
ax = gca; ax.FontSize = 28; 
ylabel('$\theta$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'q_forced_harmonic.pdf','Resolution',300);

% verity time histories of the original coordinates
fig = figure(300); set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1); hold all;
plot(t,q(1,:),'LineWidth',2); 
plot(t,q_num(1,:),'--','LineWidth',2); 
ax = gca; ax.FontSize = 28; 
set(gca, 'YDir','reverse'); yticks(-0.02:0.01:0.02);
ylabel('$h_E$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
hleg = legend('Analytical steady-state response','Numerical response'); hleg.NumColumns = 2;
subplot(2,1,2); hold all;
plot(t,rad2deg(q(2,:)),'-','LineWidth',2); 
plot(t,rad2deg(q_num(2,:)),'--','Color',c2,'LineWidth',2);  
ax = gca; ax.FontSize = 28; yticks(-1.0:0.5:1.0);
ylabel('$\theta$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'q_forced_harmonic_check.pdf','Resolution',300);


%% State-space model for numerical integration

% state velocity function
function ydot = dydt(t,y,A,f,omega_0)

    % compute state velocity
    ydot = A*y+f*sin(omega_0*t);

end