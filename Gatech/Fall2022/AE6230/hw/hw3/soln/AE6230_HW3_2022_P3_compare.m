%% This script compares the responses for Problem 3

% Cristina Riso, criso@gatech.edu

% run the P3 solution script for the two design cases before running this one
% to plot the responses for the two values of e on top of each other

clearvars
close all
clc

%% Load results

% load cases
data1 = load('forced_step_case_1.mat');
data2 = load('forced_step_case_2.mat');


%% Plot time histories on top of each other

% plot time histories of the modal coordinates
fig = figure(100); set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1); hold all;
plot(data1.t,data1.eta(1,:),'LineWidth',2); 
plot(data2.t,data2.eta(1,:),'LineWidth',2); 
axis([data1.t(1) data1.t(end) 0.0 0.06]); ax = gca; ax.FontSize = 28; yticks(0.0:0.01:0.06);
ylabel('$\eta_1$ (kg$^{1/2}$m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
hleg = legend('$e=-0.2c$','$e=-0.05c$','Interpreter','latex');
subplot(2,1,2); hold all;
plot(data1.t,data1.eta(2,:),'LineWidth',2); 
plot(data2.t,data2.eta(2,:),'LineWidth',2); 
axis([data1.t(1) data1.t(end) 0.0 0.006]); ax = gca; ax.FontSize = 28; yticks(0.0:0.001:0.006); 
ylabel('$\eta_2$ (kg$^{1/2}$m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'eta_forced_step_compare.pdf','Resolution',300);

% plot time histories of the original coordinates
fig = figure(200); set(fig,'Position',[0 0 1200 900]); 
subplot(2,1,1); hold all;
plot(data1.t,data1.q(1,:),'LineWidth',2); 
plot(data2.t,data2.q(1,:),'LineWidth',2); 
axis([data1.t(1) data1.t(end) -0.02 0.0]); ax = gca; ax.FontSize = 28; hold all; yticks(-0.02:0.004:0.0);
set(gca, 'YDir','reverse');
ylabel('$h_E$ (m)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
subplot(2,1,2); hold all;
plot(data1.t,rad2deg(data1.q(2,:)),'LineWidth',2); 
plot(data2.t,rad2deg(data2.q(2,:)),'LineWidth',2); 
axis([data1.t(1) data1.t(end) -0.3 1.2]); ax = gca; ax.FontSize = 28; yticks(-0.3:0.3:1.2);
ylabel('$\theta$ (deg)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex');
f = gcf; exportgraphics(f,'q_forced_step_compare.pdf','Resolution',300);