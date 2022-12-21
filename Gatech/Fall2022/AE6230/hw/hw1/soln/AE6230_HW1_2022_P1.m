%% This script solves HW1 Problem 1

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc


%% Problem parameters

% spring constant 1 (N/m)
k_1 = 25.0;

% spring constant 2 (N/m)
k_2 = 0.75*k_1;

% half-chord (m)
b = 0.1;

% distance 1 (m)
d_1 = b/4.0;

% distance 2 (m)
d_2 = b;

% moment of inertia (kg*m2)
J_theta = 0.0004;


%% Q1 - Natural frequency 

% equivalent torsional stiffness (Nm/rad)
k_theta = 4.0*(k_1*d_1^2+k_2*d_2^2);

% natural frequency (rad/s)
omega_n = sqrt(k_theta/J_theta); 

% natural frequency (Hz)
f_n = omega_n/2.0/pi;

% period (s)
T = 1.0/f_n;


%% Q2 - Redesign to increase omega_n by 15%

% maximum d1 (m)
d_1_max = b/2.0; k_theta_d_1_max = 4.0*(k_1*d_1_max^2+k_2*d_2^2);

% maximum d2 (m)
d_2_max = 3.0*b/2.0; k_theta_d_2_max = 4.0*(k_1*d_1^2+k_2*d_2_max^2);

% corresponding maximum natural frequencies (rad/s)
omega_n_d_1_max = sqrt(k_theta_d_1_max/J_theta);
omega_n_d_2_max = sqrt(k_theta_d_2_max/J_theta);

% corresponding maximum frequency percentage variations (%)
domega_n_d_1_max = (omega_n_d_1_max-omega_n)/omega_n*100;
domega_n_d_2_max = (omega_n_d_2_max-omega_n)/omega_n*100;

% The maximum frequency variation that can be achieved by moving the front
% springs is about 11%, which is insufficient to meet the requirement.
% Thus, the rear springs are moved by the following amount. 

% new position of the rear springs (m)
d_2_new = sqrt(((1.15*omega_n)^2*J_theta/4.0-k_1*d_1^2)/k_2); k_theta_new = 4.0*(k_1*d_1^2+k_2*d_2_new^2);

% corresponding position percentage variation (%)
dd_2_new = (d_2_new-d_2)/d_2*100;

% new natural frequency (rad/s)
omega_n_new = sqrt(k_theta_new/J_theta);

% corresponding frequency percentage variation (%)
domega_n_new = (omega_n_new-omega_n)/omega_n*100;


%% Q3 - Viscous damper design

% design logarithmic decrement (-)
delta = 0.20;

% viscous damping coefficient (Ns/m)
c_1 = J_theta*omega_n/(2.0*d_1^2)*delta/sqrt(4.0*pi^2+delta^2);

% torsional viscous damping coefficient (Nms/rad)
c_theta = 4.0*c_1*d_1^2;

% viscous damping coefficient (-)
zeta = 2.0*c_1*d_1^2/(J_theta*omega_n);

% frequency of damped motion (rad/s)
omega_d = omega_n*sqrt(1.0-zeta^2);

% frequency variation due to damping (%)
domega_d = (omega_d-omega_n)/omega_n*100;

% period of damped motion (s)
T_d = 2.0*pi/omega_d;


%% Q4 - Free response

% initial pitch angle (deg)
theta_0 = 5.0;

% time discretization (s)
t_1 = 0.0; t_2 = 5.0; dt = 0.001; t = t_1:dt:t_2;

% free response (deg)
theta = theta_0*exp(-zeta*omega_n*t).*(cos(omega_d*t)+sin(omega_d*t)*zeta/sqrt(1.0-zeta^2));

% amplitude (deg)
A_deg = theta_0/sqrt(1.0-zeta^2); A_rad = A_deg*pi/180.0;

% phase (deg)
phi_rad = atan(zeta/sqrt(1.0-zeta^2)); phi_deg = phi_rad*180.0/pi;

% plot free response
fig1 = figure(1000); hold all; set(fig1,'Position',[0 0 1200 900]);
plot(t,theta,'LineWidth',2); hold all; ax = gca; ax.FontSize = 28; yticks([-5 -2.5 0 2.5 5]);
ylabel('$\theta(t)$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex'); 
f = gcf; exportgraphics(f,'theta_free.png','Resolution',300); exportgraphics(f,'theta_free.pdf','Resolution',300)

% get peaks
[pks, locs] = findpeaks(theta);

% verify logarithmic decrement
delta_check = log(theta(locs(1))/theta(locs(2)));
