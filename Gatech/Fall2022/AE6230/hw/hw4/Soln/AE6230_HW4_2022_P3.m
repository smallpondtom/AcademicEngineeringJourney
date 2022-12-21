%% This script solves HW4 Problem 3

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc

% color-blind-friedly colors
c1 = [0.0000, 0.4470, 0.7410];
c2 = [0.8500, 0.3250, 0.0980];


%% Problem parameters

% beam length (m)
l = 1.0;

% beam torsion stifness (N*m2)
GJ = 5.0;

% beam moment of inertia per unit length (kg*m)
rhoIp = 0.005;

% modal viscous damping factor (-)
zeta = 0.02;

% excitation amplitude (Nm/m)
r_0 = 1.0;

% excitation frequency (rad/s)
omega_0 = 125.0;

% number of modes to be retained
N = [1, 2, 3, 4];

% indices of modes 
i = 1:N(end);

% initial and final time, time step (s)
t_i = 0.0; t_f = 0.2; dt = 0.0001; t = t_i:dt:t_f; n_t = length(t);


%% Q3 - Tabulate all quantities to implement the steady-state response

% eigenvalues (1/m)
alpha = (2*i-1)*pi/(2.0*l); alpha = alpha';

% natural frequencies (rad/s)
omega = alpha*sqrt(GJ/rhoIp); 

% natural frequencies (Hz)
freq = omega/(2.0*pi);

% modal masses, constant for all modes
m = rhoIp*l/2.0; 

% amplitudes of modal forces (Nm)
N_0 = 2.0*r_0*l./((2*i-1)*pi); N_0 = N_0';

% modal frequency response functions at omega_0
H = 1.0./((omega.^2-omega_0^2)+2.0j*zeta*omega*omega_0); H = H/m; 

% magnitudes and phase delays of the modal frequency response functions
H_abs = abs(H); H_phase = atan2(-imag(H),real(H));

% create summary table
table = [alpha omega m*ones(N(end),1) N_0 H_abs N_0.*H_abs H_phase rad2deg(H_phase)];


%% Q4 - Tip twist angle for one, three, and five modes

% amplitudes of the steady-state responses of the modal coordinates
eta_0 = N_0.*H_abs;

% steady-state responses of the modal coordinates
eta = eta_0.*sin(omega_0*t-H_phase);

% allocate matrix to store the tip twist angle for varying number of modes
theta_tip = zeros(length(N),n_t);

% open plot
fig1 = figure(100); hold all; set(fig1,'Position',[0 0 1200 900]); 
fig2 = figure(200); hold all; set(fig2,'Position',[0 0 1200 900]); 

% loop the maximum number of modes
for j = 1:length(N)
   
    % loop the modes
    for n = 1:N(j)
        
        % sum current contribution
        theta_tip(j,:) = theta_tip(j,:)+(-1)^(n+1)*eta(n,:);
        
    end
    
    % note that each curve in the plot is NOT an individual modal
    % contribution but the overall result for the first N modes    
    
    % plot current solution
    figure(100); plot(t,rad2deg(theta_tip(j,:)),'-','LineWidth',2);
    figure(200); plot(t,rad2deg(theta_tip(j,:)),'-','LineWidth',2);
    
end

% export plot
figure(100); ax = gca; ax.FontSize = 28; axis([t(1) t(end) -2 2]); yticks(-2:1:2);
ylabel('$\theta(l,t)$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'theta_tip_harmonic.pdf','Resolution',300);

% export zoom
figure(200); ax = gca; ax.FontSize = 28; axis([0.075 0.1 0.8 2.0]); yticks(0.8:0.3:2);
hleg = legend('$N = 1$','$N = 2$','$N = 3$','$N = 4$','Interpreter','latex'); 
set(hleg,'Location','NorthWest'); 
ylabel('$\theta(l,t)$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'theta_tip_harmonic_zoom.pdf','Resolution',300);