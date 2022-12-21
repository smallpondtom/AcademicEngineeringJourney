%% This script solves HW1 Problem 2

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc


%% Problem parameters

% moment of inertia (kg*m2)
J_theta = 0.0004;

% natural frequency (rad/s)
omega_n = 50.0;

% viscous damping factor (-)
zeta = 0.04;

% amplitude of applied moment (Nm)
M_0 = 0.1;

% frequency ratio (-)
omega_to_omega_n = 0.5;

% excitation frequency (rad/s)
omega = omega_to_omega_n*omega_n;


%% Q1 - Frequency response plots 

% torsional stiffness constant (Nm/rad)
k_theta = J_theta*omega_n^2;

% frequency ratio 
r = 0.0:0.01:4.0;

% frequency response (rad/Nm)
H = 1.0./((1.0-r.^2)+2.0*zeta*1j*r); H = H/k_theta;

% amplitude (rad/Nm) and phase lag (rad)
H_abs = abs(H); phi = atan2(-imag(H),real(H));

% plot amplitude
semilogy(r,H_abs,'LineWidth',2); hold all;
fig1 = figure(1); set(fig1,'Position',[0 0 1200 900]); ax = gca; ax.FontSize = 28; 
ylabel('$|H(i\omega)|$ (rad/Nm)','Interpreter','latex'); xlabel('$\omega/\omega_n$ (-)','Interpreter','latex'); 

% plot phase lag
fig2 = figure(2); set(fig2,'Position',[0 0 1200 900]); 
plot(r,phi*180/pi,'LineWidth',2); hold all; ax = gca; ax.FontSize = 28; 
axis([r(1) r(end) 0 180.0]); yticks([0 45.0 90.0 135.0 180.0]); yticklabels({'0','45','90','135','180'});  
ylabel('$\phi(\omega)$ (deg)','Interpreter','latex'); xlabel('$\omega/\omega_n$ (-)','Interpreter','latex'); 


%% Q2 - Steady-state response using complex response method 

% extract frequency response value (rad/Nm)
H_resp = H(r==omega_to_omega_n);

% compute magnitude (rad/Nm) and phase lag (rad and deg)
H_resp_abs = abs(H_resp); phi_resp = atan2(-imag(H_resp),real(H_resp)); phi_resp_deg = phi_resp*180.0/pi;

% plot values on top of the frequency response plots
figure(1); semilogy(omega_to_omega_n,H_resp_abs,'ko','MarkerFaceColor','k','MarkerSize',8); 
f = gcf; exportgraphics(f,'H_magnitude.png','Resolution',300); exportgraphics(f,'H_magnitude.pdf','Resolution',300)
figure(2); plot(omega_to_omega_n,phi_resp*180.0/pi,'ko','MarkerFaceColor','k','MarkerSize',8); 
f = gcf; exportgraphics(f,'H_phase.png','Resolution',300); exportgraphics(f,'H_phase.pdf','Resolution',300)

% period of steady-state response (s)
T = 2.0*pi/omega;

% time discretization (s)
t_1 = 0.0; t_2 = 4.0; dt = 0.002; t = t_1:dt:t_2;

% excitation (Nm)
M = M_0*sin(omega*t);

% steady-state response (rad)
theta = M_0*H_resp_abs*sin(omega*t-phi_resp);

% plot steady-state response (in deg)
fig3 = figure(3); set(fig3,'Position',[0 0 1200 900]);
yyaxis left; plot(t,theta*180.0/pi,'LineWidth',2); ylabel('$\theta(t)$ (deg)','Interpreter','latex'); axis([10.0*T 10.0*T+0.5 -12 12]); yticks([-12 -6 0 6 12]); hold all; ax = gca; ax.FontSize = 28; 
yyaxis right; plot(t,M,'LineWidth',2); ylabel('$M(t)$ (Nm)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex'); 
f = gcf; exportgraphics(f,'theta_forced_steady_state.png','Resolution',300); exportgraphics(f,'theta_forced_steady_state.pdf','Resolution',300)


%% Q3a and Q3b - Steady-state response using time-domain method 

% coefficient B1 (rad)
B_1 = -M_0/k_theta*2.0*zeta*omega_to_omega_n/((1.0-omega_to_omega_n^2)^2+(2.0*zeta*omega_to_omega_n)^2);

% coefficient B2 (rad)
B_2 = M_0/k_theta*(1.0-omega_to_omega_n^2)/((1.0-omega_to_omega_n^2)^2+(2.0*zeta*omega_to_omega_n)^2);

% steady-state response for verification (rad)
theta_check = B_1*cos(omega*t)+B_2*sin(omega*t);

% plot steady-state responses for verification
fig4 = figure(4); set(fig4,'Position',[0 0 1200 900]); hold all;
plot(t,theta*180.0/pi,'LineWidth',2); plot(t(1:2:end),theta_check(1:2:end)*180.0/pi,'x--','LineWidth',2);
ylabel('$\theta(t)$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex'); axis([10.0*T 10.0*T+0.5 -12 12]); yticks([-12 -6 0 6 12]); ax = gca; ax.FontSize = 28; 
hleg = legend('Complex response method','Time-domain method','NumColumns',2); set(hleg,'Location','NorthEast');
f = gcf; exportgraphics(f,'theta_forced_steady_state_check.png','Resolution',300); exportgraphics(f,'theta_forced_steady_state_check.pdf','Resolution',300)


%% Q3c and Q3d - Transient response using time-domain method

% coefficient A1 (rad)
A_1 = -B_1;

% coefficient A_2 (rad)
A_2 = -1.0/sqrt(1.0-zeta^2)*(zeta*B_1+omega_to_omega_n*B_2);

% frequency of damped motion (rad/s)
omega_d = omega_n*sqrt(1-zeta^2);

% transient response (rad)
theta_transient = exp(-zeta*omega_n*t).*(A_1*cos(omega_d*t)+A_2*sin(omega_d*t));

% total response (rad)
theta_total = theta_transient+B_1*cos(omega*t)+B_2*sin(omega*t);

% plot total response 
fig5 = figure(5); set(fig5,'Position',[0 0 1200 900]); hold all;
plot(t,theta_total*180/pi,'LineWidth',2); plot(t,theta_transient*180/pi,'LineWidth',2); 
plot([t(1) t(end)],[-M_0*H_resp_abs*180/pi -M_0*H_resp_abs*180/pi],'k--','LineWidth',1); plot([t(1) t(end)],[M_0*H_resp_abs*180/pi M_0*H_resp_abs*180/pi],'k--','LineWidth',1);
hleg = legend('Complete solution','Decaying terms','NumColumns',2); set(hleg,'Location','NorthEast');
ylabel('$\theta(t)$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');axis([t(1) t(end) -12 12]); yticks([-12 -6 0 6 12]); hold all; ax = gca; ax.FontSize = 28; 
f = gcf; exportgraphics(f,'theta_forced_total.png','Resolution',300); exportgraphics(f,'theta_forced_total.pdf','Resolution',300)

% zoom on a particular period
fig6 = figure(6); set(fig6,'Position',[0 0 1200 900]); hold all;
plot(t,theta_total*180/pi,'LineWidth',2); plot(t(1:2:end),theta(1:2:end)*180/pi,'x--','LineWidth',2); 
plot([t(1) t(end)],[-M_0*H_resp_abs*180/pi -M_0*H_resp_abs*180/pi],'k--','LineWidth',1); plot([t(1) t(end)],[M_0*H_resp_abs*180/pi M_0*H_resp_abs*180/pi],'k--','LineWidth',1);
hleg = legend('Complete solution','Steady-state solution','NumColumns',2); set(hleg,'Location','NorthEast');
ylabel('$\theta(t)$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');axis([10.0*T (10.0*T+0.5) -12 12]); yticks([-12 -6 0 6 12]); hold all; ax = gca; ax.FontSize = 28; 
f = gcf; exportgraphics(f,'theta_forced_total_zoom.png','Resolution',300); exportgraphics(f,'theta_forced_total_zoom.pdf','Resolution',300)