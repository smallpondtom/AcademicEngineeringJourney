% AE6230 HW2 Problem 2
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Parameters
params.T2 = 0.5;  % [s]
params.omega_n = 20*pi;  % [rad/s]

%% (1)
syms m omega_d omega_n zeta F_0 T_1 T_2 tau t real positive
F1(tau) = F_0/T_1*tau;
h(tau) = sin(omega_n*(t-tau));
xp1(t) = int(F1*h/m/omega_n,tau,0,t);
xp1(t) = simplify(expand(xp1));

%% (2)
F2 = -F_0*(tau - T_1)/T_1;
xp2(t) = int(F2*h/m/omega_n,tau,T_1,t);
xp2(t) = simplify(expand(xp2));


F3 = -F_0/T_1*tau + (T_1+T_2)*F_0/T_1;
xp3(t) = int(F3*h/m/omega_n,tau,T_1+T_2,t);
xp3(t) = collect(simplify(expand(xp3)),[sin(omega_n*t) cos(omega_n*t)]);
xp3(t) = collect(xp3, F_0/T_1/m/omega_n^3);

F4 = F_0/T_1*tau - (2*T_1+T_2)*F_0/T_1;
xp4(t) = int(F4*h/m/omega_n,tau,2*T_1+T_2,t);
xp4(t) = collect(simplify(expand(xp4)),[sin(omega_n*t) cos(omega_n*t)]);
xp4(t) = collect(xp4, F_0/T_1/m/omega_n^3);

%% (3)

Tn = 2*pi/params.omega_n;
T1_inputs = [0.1 0.5 1.0 1.5 2.0 2.5] * Tn;

% Arrange steady state responses
xp1 = xp1 / F_0 * m * omega_n^2;
xp2 = xp2 / F_0 * m * omega_n^2;
xp3 = xp3 / F_0 * m * omega_n^2;
xp4 = xp4 / F_0 * m * omega_n^2;

% Create the summed response function
xp_seg1 = xp1;
xp_seg2 = xp1 + xp2;
xp_seg3 = xp1 + xp2 + xp3;
xp_seg4 = xp1 + xp2 + xp3 + xp4;

colors = ["#003547", "#005E54", "#C2BB00", "#E1523D", "#ED8B16", "#B096E0"];
labels = ["0.1", "0.5", "1.0", "1.5", "2.0", "2.5"] + "$T_n$";
ct = 1;

fig = figure(Renderer="painters", Position=[60 60 1200 900]);
t = tiledlayout(3,2,'TileSpacing','Compact', 'Padding','tight');
  xlabel(t,"t");
  ylabel(t,"x(t)");
  for T1 = T1_inputs
    xp = [];
    tint = [];
    
    % Substitute in the parameters
    xp_sub_seg1 = subs(xp_seg1, [T_1, omega_n], [T1, params.omega_n]);
    xp_sub_seg2 = subs(xp_seg2, [T_1, T_2, omega_n], [T1, params.T2, params.omega_n]);
    xp_sub_seg3 = subs(xp_seg3, [T_1, T_2, omega_n], [T1, params.T2, params.omega_n]);
    xp_sub_seg4 = subs(xp_seg4, [T_1, T_2, omega_n], [T1, params.T2, params.omega_n]);

    % Time intervals
    tint1 = 0:0.001:T1;
    tint2 = T1:0.001:T1+params.T2;
    tint3 = T1+params.T2:0.001:2*T1+params.T2;
    tint4 = 2*T1+params.T2:0.001:1.5;
  
    % Compute values 
    xp1_data = xp_sub_seg1(tint1);
    xp2_data = xp_sub_seg2(tint2);
    xp3_data = xp_sub_seg3(tint3);
    xp4_data = xp_sub_seg4(tint4);
  
    
    % Combine all data
    tint = [tint tint1 tint2 tint3 tint4];
    xp = [xp xp1_data xp2_data xp3_data xp4_data];
    
    % Plot
    nexttile;
    plot(tint, xp, DisplayName=labels(ct), Color=colors(ct));
    xline(T1,'--r', "$T_1$", LabelVerticalAlignment='bottom', ...
          LabelOrientation='horizontal', LabelHorizontalAlignment='right', ...
          HandleVisibility='off', Interpreter='latex', FontSize=10)
    xline(T1+params.T2,'--r', "$T_1+T_2$", LabelVerticalAlignment='bottom', ...
          LabelOrientation='horizontal', LabelHorizontalAlignment='left', ...
          HandleVisibility='off', Interpreter='latex', FontSize=10)
    xline(2*T1+params.T2,'--r', "$2T_1+T_2$", LabelVerticalAlignment='bottom', ...
          LabelOrientation='horizontal', LabelHorizontalAlignment='right', ...
          HandleVisibility='off', Interpreter='latex', FontSize=10)
    grid on; grid minor; box on; legend;
    xlim([0,1.5])
    ylim([-2,2])
    ct = ct + 1;
  end
saveas(fig,"plots/p2/p2-x(t).png")

%% (5)

delta = 0:0.001:4;
A_T1Tn = 1 + 1./(2*pi*delta) .* sin(2*pi*delta);

fig = figure(Renderer="painters");
  plot(delta, A_T1Tn)
  grid on; grid minor; box on;
  xlabel("$T_1/T_n$")
  ylabel("max amplitude")
  yline(1,'--r')
saveas(fig,"plots/p2/p2-maxamp.png")
