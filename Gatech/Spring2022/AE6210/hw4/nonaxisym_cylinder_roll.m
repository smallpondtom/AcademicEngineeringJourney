%% AE6210 Advanced dynamics
% Author: Tomoki Koike
%% House keeping commands 
close all; clear all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

%% Parameters
global m R phi Ic Ip gamma g
m = 1;  % mass [kg]
R = 0.5;  % radius [m]
phi = deg2rad(45);  % slope angle [rad]
Ic = 11/64*m*R^2;  % moment of inertia about the CoG [kg-m^2]
Ip = 5/16*m*R^2;  % moment of inertia about the GC [kg-m^2]
gamma = 3/8;  % scale factor of distance from GC to CoG
g = 9.81;  % gravitational acceleration [m/s^2]

%% No Friction Simulation of CoG

% Simulate setup
tspan = 0:0.01:60;
opts = odeset('RelTol',1e-5,'AbsTol',1e-6);

% First of initial conditions
IC1 = [0; 0; 0; 0; (gamma*R*cos(phi)+R); 0];
[t1,x1] = ode45(@NF_CoG_roll,tspan,IC1,opts);
plot_res(t1,x1,'cog',["nf_cog_ic1_traj.png", "nf_cog_ic1_states.png"])

% Second initial conditions
IC2 = [0; 0; phi; 0.001; (gamma*R+R); 0];
[t2,x2] = ode45(@NF_CoG_roll,tspan,IC2,opts);
plot_res(t2,x2,'cog',["nf_cog_ic2_traj.png", "nf_cog_ic2_states.png"])

% Save data for later use
save nf_cog_data t1 x1 t2 x2;

%% No Friction Simulation of GC

% First of initial conditions
[t1,x1] = ode45(@NF_GC_roll,tspan,IC1,opts);
plot_res(t1,x1,'gc',["nf_gc_ic1_traj.png", "nf_gc_ic1_states.png"])

% Second initial conditions
[t2,x2] = ode45(@NF_GC_roll,tspan,IC2,opts);
plot_res(t2,x2,'gc',["nf_gc_ic2_traj.png", "nf_gc_ic2_states.png"])

% Save data for later use
save nf_gc_data t1 x1 t2 x2;

%% With friction (rolling) Simulation of CoG

% First of initial conditions
tspan = 0:0.01:60;
opts = odeset('RelTol',1e-5,'AbsTol',1e-6);

theta0 = pi/3;
IC = [0; 0.7781];
% Simulate 
[t,x] = ode45(@WF_GC_roll,tspan,IC,opts);
p = x(:,1);
pdot = x(:,2);
theta = p / R;
h = gamma*R*(cos(phi)*cos(theta) + sin(phi)*sin(theta)) + R;

figure(1);
plot(t,p);
grid on; grid minor; box on;
xlabel("$t$")
ylabel("$p$")

%% Functions

% EOM for no friction CoG roll
function dXdt = NF_CoG_roll(t, X)
    global m R phi Ic gamma g
    % x1 = c; x2 = cdot; x3 = theta; x4 = thetadot; x5 = h; x6 = hdot;
    % x1 = X(1); 
    x2 = X(2); x3 = X(3); x4 = X(4); x5 = X(5); x6 = X(6);

    % Add bounds for h(t)
    if x5 < (1-gamma)*R
        x5 = (1-gamma)*R;
    end
    
    sigma21 = sin(x3)*cos(phi) - cos(x3)*sin(phi);
    sigma22 = sin(x3)*sin(phi) - cos(x3)*cos(phi);
    
    cdot = x2;
    cddot = g*sin(phi);
    thetadot = x4;
    thetaddot = (-m*gamma^2*R^2*sigma21*sigma22*x4^2) / (Ic + m*gamma^2*R^2*sigma21^2);
    hdot = x6;

    % In contact or lose contact
    tol = 1e-4;
    chi = gamma*R*sigma22*x4^2 - g*cos(phi);
    if chi < tol
        hddot = -gamma*R*sigma22*x4^2;
    else
        hddot = -g*cos(phi);
    end
       
    dXdt = [cdot; cddot; thetadot; thetaddot; hdot; hddot];
end

% EOM for no friction GC (geometric center) roll
function dXdt = NF_GC_roll(t, X)
    global m R phi Ic gamma g
    % x1 = p; x2 = pdot; x3 = theta; x4 = thetadot
    % x1 = X(1); 
    x2 = X(2); x3 = X(3); x4 = X(4); x5 = X(5); x6 = X(6);
    
    sigma21 = sin(x3)*cos(phi) - cos(x3)*sin(phi);
    sigma22 = sin(x3)*sin(phi) - cos(x3)*cos(phi);
    
    % Add bounds for h(t)
    if x5 < (1-gamma)*R
        x5 = (1-gamma)*R;
    end

    pdot = x2;
    den = m*R^2*gamma^2 + Ic - m*R^2*gamma^2*sigma22^2;
    pddot = (m*sigma21*R^3*gamma^3*x4^2 - g*m*sin(phi)*R^2*gamma^2*sigma22^2 ...
        + g*m*sin(phi)*R^2*gamma^2 + Ic*sigma21*R*gamma*x4^2 + Ic*g*sin(phi)) / den;
    thetadot = x4;
    thetaddot = -R^2*gamma^2*m*sigma21*sigma22*x4^2 / den;
    hdot = x6;

    % In contact or lose contact
    tol = 1e-4;
    chi = gamma*R*sigma22*x4^2 - g*cos(phi);
    if chi < tol
        hddot = -gamma*R*sigma22*x4^2;
    else
        hddot = -g*cos(phi);
    end
       
    dXdt = [pdot; pddot; thetadot; thetaddot; hdot; hddot];
end

% EOM with friction 
function dXdt = WF_GC_roll(t,X)
    global g m gamma Ic R phi
    x1 = X(1); x2 = X(2);
    
    xi21 = sin(x1/R)*cos(phi) - sin(phi)*cos(x1/R);
    xi22 = cos(x1/R)*cos(phi) + sin(x1/R)*sin(phi);
    den = m + m*gamma^2 + 2*m*gamma*xi22 + Ic/R^2;

    c1 = m*gamma*xi21/R;
    c2 = 2*m*gamma^2*xi21*xi22/R;
    c3 = m*g*gamma*xi21;

    x1dot = x2;
    x2dot = (c1*x2^2 + c2*x2^2 + c3)/den;

    dXdt = [x1dot; x2dot];
end

function plot_res(t, x, flag, im_filenames)
    global gamma R phi
    if flag == "cog"
        c = x(:,1);
        cdot = x(:,2);
        theta = x(:,3);
        thetadot = x(:,4);
        h = x(:,5);
        hdot = x(:,6);

        % Trajectory 
        fig1 = figure(Renderer="painters");
            plot(c,h); grid on; grid minor; box on; 
            xlabel('$c$'); ylabel('$h$');
        % states over t
        fig2 = figure(Renderer="painters", Position=[90 90 650 800]);
        subplot(3,2,1) % c over t
            plot(t,c); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$c$');
        subplot(3,2,2) % cdot over t
            plot(t,cdot); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\dot{c}$');
        subplot(3,2,3) % h over t
            plot(t,h); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$h$');
        subplot(3,2,4) % hdot over t
            plot(t,hdot); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\dot{h}$');
        subplot(3,2,5) % theta over t
            plot(t,theta); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\theta$');
        subplot(3,2,6) % thetadot over t
            plot(t,thetadot); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\dot{\theta}$');

    elseif flag == "gc"
        p = x(:,1);
        pdot = x(:,2);
        theta = x(:,3);
        thetadot = x(:,4);
        h = x(:,5);
        hdot = x(:,6);

        % Compute sigmas
        sigma21 = sin(theta).*cos(phi) - cos(theta).*sin(phi);
        sigma22 = sin(theta).*sin(phi) + cos(theta).*cos(phi);

        % convert h(t) to q(t)
        q = h - gamma*R*sigma22;
        qdot = hdot + gamma*R*thetadot.*sigma21;

        % Trajectory 
        fig1 = figure(Renderer="painters");
            plot(p,q); grid on; grid minor; box on; 
            xlabel('$p$'); ylabel('$q$');
        % states over t
        fig2 = figure(Renderer="painters", Position=[90 90 650 800]);
        subplot(3,2,1) % p over t
            plot(t,p); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$p$');
        subplot(3,2,2) % pdot over t
            plot(t,pdot); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\dot{p}$');
        subplot(3,2,3) % q over t
            plot(t,q); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$q$');
        subplot(3,2,4) % qdot over t
            plot(t,qdot); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\dot{q}$');
        subplot(3,2,5) % theta over t
            plot(t,theta); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\theta$');
        subplot(3,2,6) % thetadot over t
            plot(t,thetadot); grid on; grid minor; box on; 
            xlabel('$t$'); ylabel('$\dot{\theta}$');

    else
        error("Wrong flag statement. Only accept 'cog' and 'gc'.");
    end

    % Save figures
    saveas(fig1,im_filenames(1));
    saveas(fig2,im_filenames(2));
end