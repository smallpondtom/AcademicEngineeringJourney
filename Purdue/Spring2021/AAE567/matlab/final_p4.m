% AAE 567 Final Exam Spring 2021 Problem 4
% Tomoki Koike

% Housekeeping commands
clear all; close all; clc;
%%
% Define system matrices 
A = [0 1 0 0; 0 -0.2 3 0; 0 0 0 1; 0 -0.5 30 0];
B0 = [0 0; 0.25 0; 0 0; 0 0.1];
B1 = [0; 1; 0; 5];
C = [1 0 0 0; 0 0 1 0];
D = [0.25 0; 0 0.05];

% Obtain the K gain with LQR
K = lqr(A, B1, diag([1,2,4,2]), diag([0.1]));
sym(K)

% Find L gain
rank(obsv(A,C))
rank(ctrb(A,B0))
P = are(A', C'*inv(D*D')*C, B0*B0');
sym(P)
L = P*C'*inv(D*D');
sym(L)

% Check the eigenvalues
sym([eig(A-B1*K); eig(A-L*C)])

% System matrices for the actual states
As = A;
Bs = [B0, B1];
Cs = eye(4);
Ds = zeros(size(Cs,1), size(Bs,2));

% System matrices for the steady state Kalman filter states
Akf = A - L*C;
Bkf = [L, B1];
Ckf = eye(4);
Dkf = zeros(size(Ckf,1), size(Bkf,2));
%%
% Plotting results 
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

% Simulate 
simout = sim('final_p4_ssKF.slx');

% Data rendering 
xs = simout.states.signals.values;
xkf = simout.estimations.signals.values;
t  = simout.tout;

% Plot 
fig = figure("Renderer","painters","Position",[60 60 900 1000]);
    subplot(4,1,1)
    plot(t, xs(:,1))
    grid on; grid minor; box on; hold on;
    plot(t, xkf(:,1))
    hold off;
    ylabel('$x_1$')
    
    subplot(4,1,2)
    plot(t, xs(:,2))
    grid on; grid minor; box on; hold on;
    plot(t, xkf(:,2))
    hold off;
    ylabel('$x_2$')
    
    subplot(4,1,3)
    plot(t, xs(:,3))
    grid on; grid minor; box on; hold on;
    plot(t, xkf(:,3))
    hold off;
    ylabel('$x_3$')
    
    subplot(4,1,4)
    plot(t, xs(:,4))
    grid on; grid minor; box on; hold on;
    plot(t, xkf(:,4))
    hold off;
    ylabel('$x_4$')
    xlabel('time [sec]')
saveas(fig, 'final_p4_plot.png')