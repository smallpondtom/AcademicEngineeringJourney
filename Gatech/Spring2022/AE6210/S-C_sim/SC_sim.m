%% AE6210 Advanced Dynamics
% Spacecraft Attitude Dynamics Simulation
% Tomoki Koike

%% Housekeeping commands 
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Setup

params.q = 0.1;
params.I = 700;
params.J = 400;
params.Omega = 0.125;

opts = odeset('RelTol',1e-8,'AbsTol',1e-10);

% Initial conditions
w10 = 0.1;
w20 = 0.01;
w30 = 0.05;

% Orientation angles
phi0 = deg2rad(10);
the0 = deg2rad(45);
psi0 = deg2rad(-10);

% DCM
C0 = [cos(phi0)*cos(the0), cos(phi0)*sin(the0)*sin(psi0)-cos(psi0)*sin(phi0), cos(phi0)*sin(the0)*cos(psi0)+sin(psi0)*sin(phi0);
     sin(phi0)*cos(the0), sin(phi0)*sin(the0)*sin(psi0)+cos(psi0)*cos(phi0), sin(phi0)*sin(the0)*cos(psi0)-sin(psi0)*cos(phi0);
     -sin(the0), cos(the0)*sin(psi0), cos(the0)*cos(psi0)];

% Euler Parameters
e40 = sqrt(1 + C0(1,1) + C0(2,2) + C0(3,3))/2;
e10 = (C0(3,2) - C0(2,3))/4/e40;
e20 = (C0(1,3) - C0(3,1))/4/e40;
e30 = (C0(2,1) - C0(1,2))/4/e40;

IC.dcm = [w10;w20;w30;C0(1,1);C0(1,2);C0(1,3);C0(2,1);C0(2,2);C0(2,3);C0(3,1);C0(3,2);C0(3,3)];
IC.orient = [w10;w20;w30;phi0;the0;psi0];
IC.euler = [w10;w20;w30;e10;e20;e30;e40];

tspan = [0,60];

%% Direction Cosine Matrix

[t.dcm,res.dcm] = ode78(@(t,x) DCM(t,x,params),tspan,IC.dcm,opts);

% Plot
% Angular Velocities
fig = figure(Renderer="painters",Position=[10 10 800 700]);
    plot(t.dcm,res.dcm(:,1),'-r',DisplayName="$\omega_1$")
    hold on; grid on; grid minor; box on;
    plot(t.dcm,res.dcm(:,2),'-g',DisplayName="$\omega_2$")
    plot(t.dcm,res.dcm(:,3),'-b',DisplayName="$\omega_3$")
    hold off; legend;
    xlabel("time [s]")
    ylabel("Ang. Vel. [rad/s]")
saveas(fig,"plots/dcm_omegas.png");

% DCMs
fig = figure(Renderer="painters",Position=[10 10 800 700]);
    subplot(3,3,1)
    plot(t.dcm,res.dcm(:,4),'-',DisplayName="$C_{11}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,2)
    plot(t.dcm,res.dcm(:,5),DisplayName="$C_{12}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,3)
    plot(t.dcm,res.dcm(:,6),DisplayName="$C_{13}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,4)
    plot(t.dcm,res.dcm(:,7),DisplayName="$C_{21}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,5)
    plot(t.dcm,res.dcm(:,8),DisplayName="$C_{22}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,6)
    plot(t.dcm,res.dcm(:,9),DisplayName="$C_{23}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,7)
    plot(t.dcm,res.dcm(:,10),DisplayName="$C_{31}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,8)
    plot(t.dcm,res.dcm(:,11),DisplayName="$C_{32}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(3,3,9)
    plot(t.dcm,res.dcm(:,12),DisplayName="$C_{33}$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    % Give common xlabel, ylabel and title to your figure
    han=axes(fig,'visible','off'); 
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,"DCM");
    xlabel(han,"time [s]");
saveas(fig,"plots/dcm_dcms.png")

%% Orientation Angle (Body-Three 3-2-1)

[t.orient,res.orient] = ode78(@(t,x) OA(t,x,params),tspan,IC.orient,opts);

% Plot
% Angular Velocities
fig = figure(Renderer="painters",Position=[10 10 800 700]);
    plot(t.orient,res.orient(:,1),'-r',DisplayName="$\omega_1$")
    hold on; grid on; grid minor; box on;
    plot(t.orient,res.orient(:,2),'-g',DisplayName="$\omega_2$")
    plot(t.orient,res.orient(:,3),'-b',DisplayName="$\omega_3$")
    hold off; legend;
    xlabel("time [s]")
    ylabel("Ang. Vel. [rad/s]")
saveas(fig,"plots/orient_omegas.png");

% Orientation Angles
fig = figure(Renderer="painters",Position=[10 10 800 700]);
    subplot(3,1,1)
    plot(t.orient,res.orient(:,4),'-',DisplayName="$\phi$")
    grid on; grid minor; box on; legend; ylim([-2*pi,2*pi])
    subplot(3,1,2)
    plot(t.orient,res.orient(:,5),DisplayName="$\theta$")
    grid on; grid minor; box on; legend; ylim([-2*pi,2*pi])
    subplot(3,1,3)
    plot(t.orient,res.orient(:,6),DisplayName="$\psi$")
    grid on; grid minor; box on; legend; ylim([-2*pi,2*pi])
    % Give common xlabel, ylabel and title to your figure
    han=axes(fig,'visible','off'); 
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,"Orientation Angles");
    xlabel(han,"time [s]");
saveas(fig,"plots/orient_angles.png")

%% Euler Parameters 

[t.euler,res.euler] = ode78(@(t,x) EP(t,x,params),tspan,IC.euler,opts);

% Plot
% Angular Velocities
fig = figure(Renderer="painters",Position=[10 10 800 700]);
    plot(t.euler,res.euler(:,1),'-r',DisplayName="$\omega_1$")
    hold on; grid on; grid minor; box on;
    plot(t.euler,res.euler(:,2),'-g',DisplayName="$\omega_2$")
    plot(t.euler,res.euler(:,3),'-b',DisplayName="$\omega_3$")
    hold off; legend;
    xlabel("time [s]")
    ylabel("Ang. Vel. [rad/s]")
saveas(fig,"plots/euler_omegas.png");

% Orientation Angles
fig = figure(Renderer="painters",Position=[10 10 800 700]);
    subplot(4,1,1)
    plot(t.euler,res.euler(:,4),'-',DisplayName="$\epsilon_1$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(4,1,2)
    plot(t.euler,res.euler(:,5),DisplayName="$\epsilon_2$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(4,1,3)
    plot(t.euler,res.euler(:,6),DisplayName="$\epsilon_3$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    subplot(4,1,4)
    plot(t.euler,res.euler(:,7),DisplayName="$\epsilon_4$")
    grid on; grid minor; box on; legend; ylim([-1.1,1.1])
    % Give common xlabel, ylabel and title to your figure
    han=axes(fig,'visible','off'); 
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    ylabel(han,"Euler Parameters");
    xlabel(han,"time [s]");
saveas(fig,"plots/euler_angles.png")

save simres.mat res t

%% Verification

H.dcm = vecnorm([params.I*res.dcm(:,1), params.J*res.dcm(:,2), params.I*res.dcm(:,3)],2,2);
H.orient = vecnorm([params.I*res.orient(:,1), params.J*res.orient(:,2), params.I*res.orient(:,3)],2,2);
H.euler = vecnorm([params.I*res.euler(:,1), params.J*res.euler(:,2), params.I*res.euler(:,3)],2,2);

fig = figure(Renderer="painters",Position=[10 10 800 700]);
    plot(t.dcm,H.dcm,'or',DisplayName="$H_{DCM}$")
    hold on; grid on; grid minor; box on;
    plot(t.orient,H.orient,'sg',DisplayName="$H_{OA}$")
    plot(t.euler,H.euler,'*b',DisplayName="$H_{EP}$")
    hold off; legend;
    xlabel("time [s]")
    ylabel("Ang. Momentmum [kg-m2/s]")
saveas(fig,"plots/H.png");

%% Functions 

% DCM Dynamic & Kinematic Differential Equations 
function Dx = DCM(t,x,params)
    Dx = zeros(12,1);
    % Unpack parameters
    q = params.q; I = params.I; J = params.J; W = params.Omega;
    % Unpack states 
    w1 = x(1); w2 = x(2); w3 = x(3);  % omega
    c11 = x(4); c12 = x(5); c13 = x(6); 
    c21 = x(7); c22 = x(8); c23 = x(9);
    c31 = x(10); c32 = x(11); c33 = x(12);  % DCM
    
    % Dynamic 
    Dx(1) = q*w3 + (I-J)/I * (3*W^2*c32*c33 - w2*w3);
    Dx(2) = 0;
    Dx(3) = -q*w1 - (I-J)/I * (3*W^2*c31*c32 - w1*w2);
    % Kinematic
    Dx(4) = c12*(w3-c23*W) - c13*(w2-q-c22*W);
    Dx(5) = -c11*(w3-c23*W) + c13*(w1-c21*W);
    Dx(6) = c11*(w2-q-c22*W) - c12*(w1-c21*W);
    Dx(7) = c22*w3 - c23*(w2-q);
    Dx(8) = -c21*w3 + c23*w1;
    Dx(9) = c21*(w2-q) - c22*w1;
    Dx(10) = c32*(w3-c23*W) - c33*(w2-q-c22*W);
    Dx(11) = -c31*(w3-c23*W) + c33*(w1-c21*W);
    Dx(12) = c31*(w2-q-c22*W) - c32*(w1-c21*W);
end

% Orientation Angle Dynamic & Kinematic Differential Equation
function Dx = OA(t,x,params)
    Dx = zeros(6,1);
    % Unpack parameters
    q = params.q; I = params.I; J = params.J; W = params.Omega;
    % Unpack states 
    w1 = x(1); w2 = x(2); w3 = x(3);  % omega
    phi = x(4); the = x(5); psi = x(6);  % angles

    % Dynamic 
    Dx(1) = q*w3 + (I-J)/I * (3*W^2*cos(the)^2*sin(psi)*cos(psi) - w2*w3);
    Dx(2) = 0;
    Dx(3) = -q*w1 + (I-J)/I * (3*W^2*sin(the)*cos(the)*sin(psi) + w1*w2);
    % Kinematic
    G = [0, sin(psi)*sec(the), cos(psi)*sec(the);
         0, cos(psi), -sin(psi);
         1, sin(psi)*tan(the), cos(psi)*tan(the)];
    C21 = sin(phi)*cos(the);
    C22 = sin(phi)*sin(the)*sin(psi)+cos(psi)*cos(phi);
    C23 = sin(phi)*sin(the)*cos(psi)-sin(psi)*cos(phi);
    Dx(4:end) = G * [w1-C21*W; w2-q-C22*W; w3-C23*W];
end

% Euler parameters Dynamic & Kinematic Differential Equations
function Dx = EP(t,x,params)
    Dx = zeros(7,1);
    % Unpack parameters
    q = params.q; I = params.I; J = params.J; W = params.Omega;
    % Unpack states 
    w1 = x(1); w2 = x(2); w3 = x(3);  % omega
    e1 = x(4); e2 = x(5); e3 = x(6); e4 = x(7);  % euler parameters

    % Dynamic 
    Dx(1) = q*w3 + (I-J)/I * (6*W^2*(e2*e3+e1*e4)*(1-2*e1^2-2*e2^2) - w2*w3);
    Dx(2) = 0;
    Dx(3) = -q*w1 - (I-J)/I * (12*W^2*(e3*e1-e2*e4)*(e2*e3+e1*e4) - w1*w2);
    % Kinematic
    Dx(4) = w3*e2/2 + (q-W-w2)*e3/2 + w1*e4/2;
    Dx(5) = -w3*e1/2 + w1*e3/2 + (w2-q-W)*e4/2;
    Dx(6) = (w2+W-q)*e1/2 - w1*e2/2 + w3*e4/2;
    Dx(7) = -w1*e1/2 + (W+q-w2)*e2/2 - w3*e3/2;
end