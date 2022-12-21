%% Simulation 
% Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
warning('off');

%% Setup 

M = 1;
R = 1;  % disk radius
g = 9.81;  % gravitational acceleration
I = M*R/4 * diag([1,1,2]);

% Initial conditions (Lagrange's)
q10 = deg2rad(10);
q20 = deg2rad(2);
q30 = deg2rad(45);
q40 = 5;
q50 = 1;

qd10 = 0.01;
qd20 = -0.1;
qd30 = 0.02;
qd40 = 0.4;
qd50 = 0.1;

IC.lagr = [q10;q20;q30;q40;q50;qd10;qd20;qd30;qd40;qd50];

% Initial conditions (Kane's)
u10 = -qd20;
u20 = qd10*cos(q20);
u30 = qd10*sin(q20) + qd30;
u40 = qd40;
u50 = qd50;

IC.kane = [q10;q20;q30;q40;q50;u10;u20;u30;u40;u50];

% Initial condition (Newton Euler)
IC.nwel = IC.kane;

%% Simulation

% Setup
% opts = odeset('RelTol',1e-3,'AbsTol',1e-5,Events=@diskTumbleEvents);  % tolerance
opts = odeset('RelTol',1e-3,'AbsTol',1e-5);  % tolerance
tspan = [0,10];

% Run
% [t.kane,res.kane] = ode45(@(t,z) disk_kane(t,z,R,g),tspan,IC.kane,opts);  % Kane
[t.lagr,res.lagr] = ode45(@(t,z) disk_lagrange(t,z,R,g),tspan,IC.lagr,opts);  % Lagrange
[t.nwel,res.nwel] = ode45(@(t,z) disk_newtonEuler(t,z,R,g),tspan,IC.nwel,opts);  % Newton-Euler

% Convert lagrange q1dot q2dot and q3dot to u1 u2 u3
temp = res.lagr(:,6);
res.lagr(:,6) = -res.lagr(:,7);
res.lagr(:,7) = temp.*cos(res.lagr(:,2));
res.lagr(:,8) = temp.*sin(res.lagr(:,2)) + res.lagr(:,8);

%% Verification

% Energy
% Lagrange 
q1 = res.lagr(:,1); q2 = res.lagr(:,2); 
u1 = res.lagr(:,6); u2 = res.lagr(:,7); u3 = res.lagr(:,8);
u4 = res.lagr(:,9); u5 = res.lagr(:,10);
v1 = -R*u2.*tan(q2) + u4.*cos(q1) + u5.*sin(q1);
v2 = -u4.*sin(q1).*sin(q2) + u5.*cos(q1).*sin(q2);
v3 = R*u1 + u4.*sin(q1).*cos(q2) - u5.*cos(q1).*cos(q2);
J = zeros(length(t.lagr),1);
for i = 1:1:length(t.lagr)
    wAC = [u1(i);u2(i);u3(i)];
    J(i) = 0.5*M*(v1(i)^2 + v2(i)^2 + v3(i)^2) + 0.5*(wAC.')*I*wAC ...
        - M*g*R*(1 - cos(q2(i)));
end
energy.lagr = J;

% Newton-Euler
q1 = res.nwel(:,1); q2 = res.nwel(:,2); 
u1 = res.nwel(:,6); u2 = res.nwel(:,7); u3 = res.nwel(:,8);
u4 = res.nwel(:,9); u5 = res.nwel(:,10);
v1 = -R*u2.*tan(q2) + u4.*cos(q1) + u5.*sin(q1);
v2 = -u4.*sin(q1).*sin(q2) + u5.*cos(q1).*sin(q2);
v3 = R*u1 + u4.*sin(q1).*cos(q2) - u5.*cos(q1).*cos(q2);
J = zeros(length(t.nwel),1);
for i = 1:length(t.nwel)
    wAC = [u1(i);u2(i);u3(i)];
    J(i) = 0.5*M*(v1(i)^2 + v2(i)^2 + v3(i)^2) + 0.5*(wAC.')*I*wAC ...
        - M*g*R*(1 - cos(q2(i)));
end
energy.nwel = J;

% Kane
% q1 = res.kane(:,1); q2 = res.kane(:,2); 
% u1 = res.kane(:,6); u2 = res.kane(:,7); u3 = res.kane(:,8);
% u4 = res.kane(:,9); u5 = res.kane(:,10);
% v1 = -R*u2.*tan(q2) + u4.*cos(q1) + u5.*sin(q1);
% v2 = -u4.*sin(q1).*sin(q2) + u5.*cos(q1).*sin(q2);
% v3 = R*u1 + u4.*sin(q1).*cos(q2) - u5.*cos(q1).*cos(q2);
% J = zeros(length(t.kane),1);
% for i = 1:length(t.kane)
%     wAC = [u1(i);u2(i);u3(i)];
%     J(i) = 0.5*M*(v1(i)^2 + v2(i)^2 + v3(i)^2) + 0.5*(wAC.')*I*wAC ...
%         - M*g*R*(1 - cos(q2(i)));
% end
% energy.kane = J;

fig = figure(Renderer="opengl",Position=[60 60 600 500]);
    plot(t.lagr,energy.lagr,'o',DisplayName='Lagrange')
    hold on; grid on; grid minor; box on;
%     plot(t.kane,energy.kane,'^',DisplayName='Kane')
    plot(t.nwel,energy.nwel,'x',DisplayName='Newton Euler')
    hold off; legend(Location="best");
    xlabel('$t$ [s]')
    ylabel('Energy')
saveas(fig,"plots/energy.png")

%% Plot

ylabels = ["$q_1$", "$q_2$", "$q_3$", "$q_4$", "$q_5$",...
           "$u_1$", "$u_2$", "$u_3$", "$u_4$", "$u_5$"];

fig = figure(Renderer="opengl",Position=[60 60 1000 900]);
    for i = 1:10
        subplot(5,2,i)
        plot(t.lagr,res.lagr(:,i),'o',DisplayName="Lagrange")
        hold on; grid on; grid minor; box on;
%         plot(t.kane,res.kane(:,i),'^',DisplayName="Kane")
        plot(t.nwel,res.nwel(:,i),'x',DisplayName="Newton Euler")
        hold off; legend(Location="best");
        ylabel(ylabels(i))
    end
    han=axes(fig,'visible','off'); 
    han.XLabel.Visible='on';
    xlabel(han,'$t$ [s]');
saveas(fig,"plots/2method_states.png");
    
    
%% Additional Function

function [value,isterminal,direction] = diskTumbleEvents(t,z)
    value = abs(z(2)) - pi/2;     % disk falls down
    isterminal = 1;   % Stop the integration
    direction = 0;   % Negative direction only
end







