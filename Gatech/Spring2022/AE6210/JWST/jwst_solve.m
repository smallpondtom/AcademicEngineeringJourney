%% James Webb Space Telescope Simulation Solver
% Author: Tomoki Koike

close all; clear; clc;
addpath("cr3bp-matlab");

% Setup
jwst_setup;

% Find initial conditions
generate_halo;

% JWST
yr = 31449600;  % 1 year
tspan = 0:60:yr;
IC = x0_lpo;
IC(1:3) = IC(1:3)*param.Lstar;
IC(4:6) = IC(4:6)*param.Vstar;
IC(1) = IC(1); % + orbit.eta2 * orbit.r12;
opts = odeset('RelTol',1e-12,'AbsTol',1e-13);

% Simulate JWST w.r.t Sun
[t,Xj] = ode45(@(t,X) jwst_orbit(t,X,orbit),tspan,IC,opts);

x_j  = Xj(:,1);
y_j  = Xj(:,2);
vx_j = Xj(:,4);
vy_j = Xj(:,5);

orbit.sol.sunJWST.t = t;
orbit.sol.sunJWST.x_j  = Xj(:,1);
orbit.sol.sunJWST.y_j  = Xj(:,2);
orbit.sol.sunJWST.z_j  = Xj(:,3);
orbit.sol.sunJWST.vx_j = Xj(:,4);
orbit.sol.sunJWST.vy_j = Xj(:,5);
orbit.sol.sunJWST.vz_j = Xj(:,6);
orbit.sol.sunJWST.r = [Xj(:,1) Xj(:,2) Xj(:,3)];
orbit.sol.sunJWST.r1 = [Xj(:,1)+orbit.eta2*orbit.r12 Xj(:,2) Xj(:,3)];
orbit.sol.sunJWST.r2 = [Xj(:,1)-orbit.eta1*orbit.r12 Xj(:,2) Xj(:,3)];
% shift from barycenter to Sun
orbit.sol.sunJWST.x_j  = orbit.sol.sunJWST.r1(:,1);

% Correct the values to inertial frame from Sun-Earth frame 
Omega = orbit.Omega;
idx = 1;  % index
xi = zeros(size(x_j));
yi = zeros(size(y_j));
vxi = zeros(size(vx_j));
vyi = zeros(size(vy_j));
for ti = transpose(t)
    xi(idx) = cos(Omega*ti)*x_j(idx) - sin(Omega*ti)*y_j(idx);
    yi(idx) = sin(Omega*ti)*x_j(idx) + cos(Omega*ti)*y_j(idx);
    vxi(idx) = cos(Omega*ti)*vx_j(idx) - sin(Omega*ti)*vy_j(idx);
    vxi(idx) = sin(Omega*ti)*vx_j(idx) + cos(Omega*ti)*vy_j(idx);
    idx = idx + 1;
end
orbit.sol.sunJWST.xi = xi;
orbit.sol.sunJWST.yi = yi;
orbit.sol.sunJWST.vxi = vxi;
orbit.sol.sunJWST.vyi = vyi;

% Simulate Earth
if isfile('earth_orbit.mat')
    load('earth_orbit.mat');
else
    [t,Xe] = ode45(@(t,X) earth_orbit(t,X,mu1),tspan,[r12;0;0;0;ve;0],opts);
    save earth_orbit Xe
end
orbit.sol.earthJWST.x_e  = Xe(:,1);
orbit.sol.earthJWST.y_e  = Xe(:,2);
orbit.sol.earthJWST.z_e  = Xe(:,3);
orbit.sol.earthJWST.vx_e = Xe(:,4);
orbit.sol.earthJWST.vy_e = Xe(:,5);
orbit.sol.earthJWST.vz_e = Xe(:,6);

save simres orbit

%% Fuctions
function dX = jwst_orbit(t,X,param)
    % Unpack states
    x = X(1); y = X(2); z = X(3);
    vx = X(4); vy = X(5); vz = X(6);
    
    % Unpack parameters
    Omega = param.Omega;
    mu1 = param.mu1;
    mu2 = param.mu2;
    eta1 = param.eta1;
    eta2 = param.eta2;
    r12 = param.r12;
    r23 = param.r23;

    % Distance from Sun and Earth
    r1 = sqrt( (x+eta2*r12)^2 + y^2 + z^2);
    r2 = sqrt( (x-eta1*r12)^2 + y^2 + z^2);
    % r2 = r23;

    % Forces
    Fx = -mu1/r1^3 * (x + eta2*r12) - mu2/r2^3 * (x - eta1*r12);
    Fy = -mu1/r1^3 * y - mu2/r2^3 * y;
    Fz = -mu1/r1^3 * z - mu2/r2^3 * z;

    % Equations of motion
    xdot = vx;
    ydot = vy;
    zdot = vz;
    xddot = 2*Omega*vy + Omega^2*x + Fx;
    yddot = -2*Omega*vx + Omega^2*y + Fy;
    zddot = Fz;

    dX = [xdot;ydot;zdot;xddot;yddot;zddot];
end

function dX = earth_orbit(t,X,mu)
    % Unpack states
    x = X(1); y = X(2); z = X(3);
    vx = X(4); vy = X(5); vz = X(6);
    % Equations of motion
    xdot = vx;
    ydot = vy;
    zdot = vz;
    xddot = -mu * x / (x^2 + y^2)^1.5;
    yddot = -mu * y / (x^2 + y^2)^1.5;
    zddot = 0;
    dX = [xdot; ydot; zdot; xddot; yddot; zddot];
end