%% AE6210 HW8 Matlab Code
% Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Setup

% Parameters
params.M = 5;
params.L = 1;
params.theta_y0 = deg2rad(20);
params.theta_z0 = deg2rad(-10);
params.Omega_y = 1.5;
params.Omega_z = 0.8;

% Tolerance
opts = odeset('RelTol',1e-8,'AbsTol',1e-10);

% Initial conditions
% LEO -> altitude 1500 km -> radius 7871 km from the center of the Earth
x0 = 5681; % km 
y0 = 3161;
z0 = 4437;
% Orientation angles
phi0 = deg2rad(45);
theta0 = deg2rad(-84);
psi0 = deg2rad(6);
% Velocities
vx0 = 2;
vy0 = 4;
vz0 = 1;
% Angular Velocities
wx0 = 0.45;
wy0 = 0.03;
wz0 = -0.020;

IC = [x0;y0;z0;phi0;theta0;psi0;vx0;vy0;vz0;wx0;wy0;wz0];
tspan = [0,300];
[t,res] = ode45(@(t,z) spaceRobot(t,z,params),tspan,IC,opts);

%% Plot

fig = figure(Renderer="painters",Position=[60 60 900 800]);
    plot(t,res(:,1),DisplayName="$x$")
    hold on; grid on; grid minor; box on;
    plot(t,res(:,2),DisplayName="$y$")
    plot(t,res(:,3),DisplayName="$z$")
    hold off; legend;
    xlabel('time [s]')
    ylabel('distance [km]')
saveas(fig,'plots/position.png')

fig = figure(Renderer="painters",Position=[60 60 900 800]);
    plot(t,res(:,4),DisplayName="$\phi$")
    hold on; grid on; grid minor; box on;
    plot(t,res(:,5),DisplayName="$\theta$")
    plot(t,res(:,6),DisplayName="$\psi$")
    hold off; legend;
    xlabel('time [s]')
    ylabel('angle [rad]')
saveas(fig,'plots/orientation.png')

fig = figure(Renderer="painters",Position=[60 60 900 800]);
    plot(t,res(:,7),DisplayName="$v_x$")
    hold on; grid on; grid minor; box on;
    plot(t,res(:,8),DisplayName="$v_y$")
    plot(t,res(:,9),DisplayName="$v_z$")
    hold off; legend;
    xlabel('time [s]')
    ylabel('velocity [m/s]')
saveas(fig,'plots/velocity.png')

fig = figure(Renderer="painters",Position=[60 60 900 800]);
subplot(3,1,1)
    plot(t,res(:,10),DisplayName="$\omega_x$")
    grid on; grid minor; box on; legend;
subplot(3,1,2)
    plot(t,res(:,11),DisplayName="$\omega_y$")
    grid on; grid minor; box on; legend;
subplot(3,1,3)
    plot(t,res(:,12),DisplayName="$\omega_z$")
    grid on; grid minor; box on; legend;
    % Give common xlabel, ylabel and title to your figure
    han=axes(fig,'visible','off'); 
    han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    yl = ylabel(han,'Angular Velocity [rad/s]');
    yl.Position(1) = -0.07; % change horizontal position of ylabel
    xlabel(han,'time [s]');
saveas(fig,'plots/angVelocity.png')

%% Verification

% MoI
ml = params.M * params.L^2;
I1 = ml * diag([1/125, 13/125, 13/125]);
I2 = ml * diag([1/12, 0, 1/12]);
I3 = ml * diag([1/12, 1/12, 0]);
I = I1 + I2 + I3;

% Angular Momentum
L = zeros(length(t),3);
for i = 1:length(t)
    L(i,:) = I * res(i,10:12)';
end

fig = figure(Renderer="painters",Position=[60 60 900 800]);
subplot(3,1,1)
    plot(t,L(:,1),DisplayName="$L_x$")
    grid on; grid minor; box on; legend;
subplot(3,1,2)
    plot(t,L(:,2),DisplayName="$L_y$")
    grid on; grid minor; box on; legend;
subplot(3,1,3)
    plot(t,L(:,3),DisplayName="$L_z$")
    grid on; grid minor; box on; legend;
    % Give common xlabel, ylabel and title to your figure
    han=axes(fig,'visible','off'); 
    han.Title.Visible='on';
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    yl = ylabel(han,'Angular Momentum [kg-$m^2$/s]');
    yl.Position(1) = -0.07; % change horizontal position of ylabel
    xlabel(han,'time [s]');
saveas(fig,'plots/angMomentum.png')

fprintf("Variance of Lx: %.4e\n",var(L(:,1)));
fprintf("Variance of Ly: %.4e\n",var(L(:,2)));
fprintf("Variance of Lz: %.4e\n",var(L(:,3)));


%% Functions 

function dzdt = spaceRobot(t,z,params)
    % Unpack parameters
    ty0 = params.theta_y0; Wy = params.Omega_y;
    tz0 = params.theta_z0; Wz = params.Omega_z;

    % Prescribed angles of the arms
    ty = ty0*sin(Wy*t);
    tz = tz0*(1 - cos(Wz*t));
    % dty = ty0*Wy*cos(Wy*t);
    dtz = tz0*Wz*sin(Wz*t);
    ddtz = tz0*Wz^2*cos(Wz*t);

    % Generalized coordinates
    % xB, yB, zB 
    % q1 = z(1); q2 = z(2); q3 = z(3);
    % roll, pitch, yaw
    % q4 = z(4); 
    q5 = z(5); q6 = z(6);

    % Generalized velocities
    % Velocity of CoM
    u1 = z(7); u2 = z(8); u3 = z(9);
    % Angular velocity
    q4dot = z(10); q5dot = z(11); q6dot = z(12);
    u4 = q4dot*cos(q5)*cos(q6) + q5dot*sin(q6);
    u5 = -q4dot*cos(q5)*sin(q6) + q5dot*cos(q6);
    u6 = q4dot*sin(q5) + q6dot;

    % Preallocate output
    dzdt = zeros(12,1);

    % Kinematic differential equations
    dzdt(1:6) = [u1; u2; u3; u4; u5; u6];
    
    % Some additional variables
    beta = 5*sin(tz)+1;
    gamma = 1-cos(tz);
    delta = 1-cos(ty);
    
    % Dynamical differential equations
    E = zeros(3,3);
    E(1,1) = beta^2/400 - 131/750;
    E(1,2) = beta*gamma/80;
    E(1,3) = sin(ty)*gamma/16;
    E(2,1) = beta*(gamma-delta)/80;
    E(2,2) = gamma*(gamma-delta)/16 + 281/1500*delta;
    E(2,3) = beta*sin(ty)/80;
    E(3,1) = 0;
    E(3,2) = 0;
    E(3,3) = gamma^2/16 - beta^2/300 - gamma*delta/16 - 281/1500;

    dzdt(7:9) = 0;
    dzdt(10) = beta*dtz/80*(2*cos(tz)*u4 + 2*sin(tz)*u5 + sin(ty)*u6) + sin(ty)*sin(tz)*dtz/8*u6 ...
        + sin(ty)*gamma/16*u4*u5 + beta^2/400*u5*u6 - beta*gamma/80*u6*u4 ...
        + sin(ty)*beta/80*(u4^2 + u6^2) + sin(ty)/16*(2*sin(tz)*dtz^2 - cos(tz)*ddtz);
    dzdt(11) = (gamma-delta)*dtz/8*(cos(tz)*u4 + sin(tz)*u5) + sin(tz)/16*(gamma*dtz - 2*cos(tz)*dtz)*u6 ...
        + sin(ty)*beta/80*u4*u5 + beta*(gamma-delta)/80*u5*u6 + (19/1500 - gamma*(gamma-delta)/16)*u6*u4 ...
        + sin(ty)*gamma/16*(u5^2 + u6^2) + sin(ty)*(cos(tz)*dtz^2 + sin(tz)*ddtz)/16;
    dzdt(12) = 1/80*(dtz*beta*(gamma-delta) + 10*sin(tz)*dtz*(gamma-delta) - 5*dtz*beta*gamma + 10*cos(tz)*dtz*beta)*u6 ...
        + (gamma^2/16 - beta^2/400 - gamma*delta/16 - 19/1500)*u4*u5 + beta/80*((gamma-delta)*u4^2 - gamma*u5^2 - delta*u6^2) ...
        + beta/80*(2*cos(tz)*dtz^2 + sin(tz)*ddtz) + (2*sin(tz)*dtz^2 - cos(tz)*ddtz)*(gamma-delta)/16;
    
    dzdt(10:12) = E * dzdt(10:12);

end