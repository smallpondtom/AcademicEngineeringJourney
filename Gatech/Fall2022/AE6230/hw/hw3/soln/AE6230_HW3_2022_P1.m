%% This script solves HW3 Problem 1

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc

% define colors
c1 = [0.0000, 0.4470, 0.7410];
c2 = [0.8500, 0.3250, 0.0980];


%% Problem parameters

% concentrated masses (kg)
m_w = 750.0; m_f = 5.0*m_w;

% bending stiffness (Nm^2)
EI = 5.0e6;

% half-wing length (m)
l = 10.0;

% modal viscous damping coefficients (-)
zeta_1 = 0.0; zeta_2 = 0.04; zeta_3 = zeta_2; zeta = [zeta_1; zeta_2; zeta_3];

% initial displacements (m)
q_1_0 = 0.5; q_2_0 = 0.0; q_3_0 = 0.0; q_0 = [q_1_0; q_2_0; q_3_0];

% initial velocities (m/s)
qdot_1_0 = 0.0; qdot_2_0 = 0.0; qdot_3_0 = 0.0; qdot_0 = [qdot_1_0; qdot_2_0; qdot_3_0];

% initial and final time, time step (s)
t_i = 0.0; t_f = 20.0; dt = 0.001; t = t_i:dt:t_f; n_t = length(t);

% number of modes (same as the number of DOFs)
n_m = 3;


%% Build matrices

% build the mass matrix
M = diag([m_f m_w m_w]);

% build the stiffness matrix
K = 3.0*EI/(l^3)*[2.0 -1.0 -1.0; -1.0 1.0 0.0; -1.0 0.0 1.0];


%% Start timer for modal transient response

% initial time
t_modal_i = tic;


%% Q1 - Undamped natural frequencies

% compute eigenvalues and eigenvectors
[U, Omega2] = eig(K,M); omega2 = diag(Omega2); 

% compute natural frequencies (rad/s and Hz)
omega = sqrt(omega2); freq = omega/(2.0*pi);


%% Q2 - Mode shapes normalized to have unit maximum displacement

% loop the eigenvectors
for i = 1:n_m
    
    % normalize for unit maximum displacement
    if abs(min(U(:,i))) > max(U(:,i))
        U(:,i) = U(:,i)/min(U(:,i));
    else
        U(:,i) = U(:,i)/max(U(:,i));
    end

end


%% Q4 - Modal matrix inverse

% modal mass matrix (NOT an identity matrix with this normalization)
M_bar = U'*M*U;

% modal stiffness matrix (NOT the Omega2 matrix with this normalization)
K_bar = U'*K*U;

% modal matrix inverse
U_inv = inv(M_bar)*U'*M;

% note that we need to add one extra matrix multiplication to account for
% the fact that U'*M*U is a diagonal, but not identity matrix

% however, there is no modal truncation in this problem, so the modal
% matrix inverse could have also been computed using standard inversion
% techniques


%% Q5 - Initial conditions for the modal coordinates

% initial modal displacements
eta_0 = U_inv*q_0;

% initial modal velocities
etadot_0 = U_inv*qdot_0;


%% Q6 - Analytical free response

% the free response is computed for a general case, but several terms are
% zero for this problem due to the zero initial velocities and the symmetry
% of the initial displacement with respect to the centerline

% allocate the vector of modal coordinates
eta = zeros(n_m,n_t);

% compute the free response for the first modal coordinate (rigid-body mode)
eta(1,:) = etadot_0(1)*t+eta_0(1);

% compute the damped modal frequencies
omega_d = omega.*sqrt(1.0-zeta.^2);

% auxiliary vector 1
A = eta_0(2:end);

% auxiliary vector 2
B = (etadot_0(2:end)+zeta(2:end).*omega(2:end).*eta_0(2:end))./omega_d(2:end);

% compute the free response for the last two modal coordinates (elastic modes)
eta(2:end,:) = exp(-zeta(2:end).*omega(2:end)*t).*(A.*cos(omega_d(2:end)*t)+B.*sin(omega_d(2:end)*t));

% recover solution
q = U*eta;


%% Stop timer for modal transient response

% elapsed time for modal transient response
t_modal_f = toc(t_modal_i);


%% Start timer for direct transient response

% initial time
t_direct_i = tic;


%% Numerical free response (for verification and to check computational time)

% set modal viscous damping matrix
C_bar = 2.0*diag(diag(M_bar).*omega.*zeta);

% reverse engineer viscous damping matrix that gives the above matrix
C = U_inv'*C_bar*U_inv;

% build the state matrix including damping
A = [zeros(n_m) eye(n_m); -inv(M)*K -inv(M)*C];

% time the march state-space equations
[t_num, y_num] = ode45(@(t_num,y_num)dydt(t_num,y_num,A),t,[q_0; qdot_0],odeset('RelTol',1.0e-12)); 

% extract numerical q
q_num = y_num(:,1:n_m)';


%% Stop timer for direct transient response

% elapsed time for direct transient response
t_direct_f = toc(t_direct_i);


%% Verify modal matrices

% compute eigenvalue matrix error
Omega2_error = max(max(abs(Omega2-inv(M_bar)*K_bar)));


%% Verify modal initial conditions

% compute initial displacements error
q_0_error = max(abs(q_0-U*eta_0));

% compute initial velocities error
qdot_0_error = max(abs(qdot_0-U*etadot_0));


%% Verify solution

% compute solution error for q_1
q_1_error = max(max(abs(q_num(1,:)-q(1,:))));

% compute solution error for q_2
q_2_error = max(max(abs(q_num(2,:)-q(2,:))));

% compute solution error for q_3
q_3_error = max(max(abs(q_num(3,:)-q(3,:))));


%% Q3 - Mode shapes plots

% loop the mode shapes
for i = 1:n_m
    
    fig = figure(i); set(fig,'Position',[0 0 1200 900]); hold all; 
    
    % positions of the masses (m) 
    h_f = U(1,i); h_wl = U(2,i); h_wr = U(3,i);    
    
    % plot mode shape
    plot([0.0, +l],[h_f h_wr],'o-','Color',c1,'LineWidth',3,'MarkerSize',8,'MarkerFaceColor',c1);
    plot([0.0, -l],[h_f h_wl],'o-','Color',c1,'LineWidth',3,'MarkerSize',8,'MarkerFaceColor',c1);
    
    % plot rigid-body component
    plot([-l, l],[U(1,i) U(1,i)],'k--','LineWidth',1);
    
    % plot undeformed configuration
    plot([0.0, +l],[0.0 0.0],'o-','Color','k','LineWidth',3,'MarkerSize',8,'MarkerFaceColor','k');
    plot([0.0, -l],[0.0 0.0],'o-','Color','k','LineWidth',3,'MarkerSize',8,'MarkerFaceColor','k');
    
    ax = gca; ax.FontSize = 32; axis equal; axis([-12 12 -4 4]); 
    xlabel('Spanwise position (m)'); ylabel('Vertical position (m)');
    fig = gcf; exportgraphics(fig,strcat('mode_',num2str(i),'.pdf'),'Resolution',300)
    
end


%% Q7 - Time histories plots

% when the mode shapes are normalized to have unit maximum displacement the
% modal coordinates are non-dimensional if the units are kept with the mode
% shapes

% alternatively, we could make the mode shapes nondimensional and keep the
% units with the modal coordinates

% plot time histories of the modal coordinates
fig = figure(100); hold all; set(fig,'Position',[0 0 1200 900]); 
plot(t,eta(1,:),'LineWidth',2); 
plot(t,eta(2,:),'LineWidth',2);
plot(t,eta(3,:),'LineWidth',2);
ax = gca; ax.FontSize = 28; axis([t(1) t(end) -0.4 0.4]); yticks(-0.4:0.1:0.4);
hleg = legend('$\eta_1$','$\eta_2$','$\eta_3$','Interpreter','latex'); set(hleg,'Location','Best');
ylabel('$\eta$ (-)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'eta_free.pdf','Resolution',300);

% plot time histories of the original coordinates
fig = figure(200); hold all; set(fig,'Position',[0 0 1200 900]); 
plot(t,q(1,:),'LineWidth',2); 
plot(t,q(2,:),'LineWidth',2);
plot(t,q(3,:),'--','LineWidth',2); 
plot([t(1) t(end)],[eta_0(1) eta_0(1)],'k--');
ax = gca; ax.FontSize = 28; axis([t(1) t(end) 0.0 0.8]); yticks(0.0:0.1:0.8);
ylabel('$q$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
hleg = legend('$q_1$','$q_2$','$q_3$','Interpreter','latex'); set(hleg,'Location','Best');
f = gcf; exportgraphics(f,'q_free.pdf','Resolution',300);

% verity time histories of the original coordinates
fig = figure(300); set(fig,'Position',[0 0 1200 900]); 
subplot(3,1,1); hold all;
plot(t,q(1,:),'LineWidth',2); 
plot(t,q_num(1,:),'--','LineWidth',2); 
plot([t(1) t(end)],[eta_0(1) eta_0(1)],'k--');
ax = gca; ax.FontSize = 28; axis([t(1) t(end) 0.0 0.6]); yticks(0.0:0.15:0.6);
ylabel('$q_1$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
hleg = legend('Analytical','Numerical'); hleg.NumColumns = 2; set(hleg,'Location','Best');
subplot(3,1,2); hold all;
plot(t,q(2,:),'-','LineWidth',2); 
plot(t,q_num(2,:),'--','Color',c2,'LineWidth',2); 
plot([t(1) t(end)],[eta_0(1) eta_0(1)],'k--');
ax = gca; ax.FontSize = 28; axis([t(1) t(end) 0.0 0.8]); yticks(0.0:0.2:0.8);
ylabel('$q_2$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
subplot(3,1,3); hold all;
plot(t,q(3,:),'-','LineWidth',2); 
plot(t,q_num(3,:),'--','Color',c2,'LineWidth',2); 
plot([t(1) t(end)],[eta_0(1) eta_0(1)],'k--');
ax = gca; ax.FontSize = 28; axis([t(1) t(end) 0.0 0.8]); yticks(0.0:0.2:0.8);
ylabel('$q_3$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'q_free_check.pdf','Resolution',300);


%% State-space model for numerical integration

% state velocity function
function ydot = dydt(~,y,A)

    % compute state velocity
    ydot = A*y;

end