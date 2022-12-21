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

% beam bending stifness (N*m2)
EI = 50.0;

% beam mass per unit length (kg*m)
rhoA = 0.25;

% excitation amplitude (Nm/m)
F_0 = 1.0;

% excitation application point (m)
x_0 = l/2.0;

% number of modes to be retained
N = [1, 2, 3, 4, 5, 6, 7, 8];

% indices of modes 
i = 1:N(end);

% initial and final time, time step (s)
t_i = 0.0; t_f = 0.1; dt = 0.00005; t = t_i:dt:t_f; n_t = length(t);


%% Q2 - Tabulate quantities to implement the steady-state response

% eigenvalues (1/m)
alpha = i*pi/l; alpha = alpha';

% natural frequencies (rad/s)
omega = alpha.^2*sqrt(EI/rhoA);

% natural frequencies (Hz)
freq = omega/(2.0*pi);

% modal masses, constant for all modes
m = rhoA*l/2.0; 

% amplitudes of modal forces (N)
N_0 = F_0*sin(i*pi*x_0/l); N_0 = N_0';

% summary table
table = [alpha omega N_0 N_0./(m.*omega)];


%% Q3 - Vertical displacement at x = l/2

% time-histories of the modal coordinates
eta = N_0./(omega*m).*sin(omega*t);

% allocate matrix to store the displacement for varying number of modes
v = zeros(length(N),n_t);

% open plot
fig1 = figure(100); hold all; set(fig1,'Position',[0 0 1200 900]); 
fig2 = figure(200); hold all; set(fig2,'Position',[0 0 1200 900]); 

% loop the maximum number of modes
for j = 1:2:length(N)
   
    % the even modes are omitted directly because they do not contribute to
    % the response anyway (the load is applied at a node of those modes)
    
    % loop the modes
    for n = 1:2:N(j)
        
        % sum current contribution
        v(j,:) = v(j,:)+sin(n*pi/2.0)*eta(n,:);
        
    end
    
    % note that each curve in the plot is NOT an individual modal
    % contribution but the overall result for the first N modes      
    
    % plot current solution
    figure(100); plot(t,v(j,:),'-','LineWidth',2);
    figure(200); plot(t,v(j,:),'-','LineWidth',2);
    
end

% export plot
figure(100); ax = gca; ax.FontSize = 28; axis([t(1) t(end) -0.08 0.08]); yticks(-0.08:0.04:0.08);
ylabel('$v(l/2,t)$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'v_mid_impulsive.pdf','Resolution',300);

% export zoom
figure(200); ax = gca; ax.FontSize = 28; axis([0.04 0.07 0.0 0.08]); yticks(0.0:0.02:0.08);
hleg = legend('$N = 1$ and $N = 2$','$N = 3$ and $N = 4$','$N = 5$ and $N = 6$','$N = 7$ and $N = 8$','Interpreter','latex'); 
set(hleg,'Location','NorthWest'); 
ylabel('$v(l/2,t)$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'v_mid_impulsive_zoom.pdf','Resolution',300);