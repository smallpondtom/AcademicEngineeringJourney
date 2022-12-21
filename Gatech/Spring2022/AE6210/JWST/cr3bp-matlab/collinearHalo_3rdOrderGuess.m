function [X0,T,x_analytic_synodic,y_analytic_synodic,z_analytic_synodic] ... 
    = collinearHalo_3rdOrderGuess(mu,Lstar,phi,lp,northsouth,Az_km)
%(mu,Lstar,northsouth,lp,Az_km,phi)
% Function computes 3rd order analytical initial state vector for
% halo orbit about collinear lagrange point
% Yuri Shimane, 2020/03/14
% ================================================================ %
% INPUT
%   mu : cr3bp mass parameter
%   Lstar : canonical length-scale, in km
%   phi : phase, should be 0 or pi
%   lp : collinear libration point, 1, 2, or 3
%   northsouth : side of family (n), 1 or 3
%   Az_km : z-direction amplitude, in km
%   tolDC : tolDC : tolerance on residuals at period/2
% 
% OUTPUT 
%   X0 : 3rd order solution state-vector at t=0
%   T : 3rd order solution period
%   x_analytic_synodic, y_analytic_synodic, z_analytic_synodic : 
%       3rd order position vectors over one period (x,y,z)
% ================================================================ %
fprintf("Generating 3rd-order initial guess of Halo...\n");

% construct Lagrangain point matrix
LP = lagrangePoints(mu);

% Richardson-3rd order approximated solution
% ... Values are in libration frame (re-scaled with gammaL)
if lp == 1
    gammaL = abs((1-mu) - LP(lp,1));
elseif lp == 2
    gammaL = abs((1-mu) - LP(lp,1));
elseif lp == 3
    gammaL = abs(mu - LP(lp,1));
end

% ... compute c2, c3, c4 for the chosen libration point
c2 = legendre_cn(2,mu,gammaL,lp);
c3 = legendre_cn(3,mu,gammaL,lp);
c4 = legendre_cn(4,mu,gammaL,lp);

% ... compute lambda
lambda = linear_cr3bp_lambda(c2);
% ... compute Delta
Delta = lambda^2 - c2;
% ... compute k
k = 2*lambda/(lambda^2 + 1 - c2);
% ... legendre coefficients
[a21,a22,a23,a24,a31,a32,b21,b22,b31,b32,d21,d31,d32,...
          d1,d2,a1,a2,s1,s2,l1,l2] = legendre_coefficients(c2,c3,c4,lambda,k);
      
% ... amplitude constraint
% Az: non-dimensionalized (to synodic frame) and rescaled (to libration frame)
Az = Az_km/(Lstar*gammaL);
% Ax: constrained horizontal amplitude (non-dim, rescaled as well)
Ax = sqrt((- Delta - l2*Az^2)/l1);
Ay = k*Ax;
fprintf('   Altitudes Ax = %6.3f [km], \n             Ay = %6.3f [km] \n             Az = %6.3f [km]\n',...
            Ax*Lstar*gammaL, Ay*Lstar*gammaL, Az*Lstar*gammaL);

% ... period of halo orbit
omega1 = 0;
omega2 = s1*(Ax)^2 + s2*(Az)^2;
omega = 1 + omega1 + omega2;
T = 2*pi()/(lambda*omega);  % -- non-dimensionalized by 1/Tstar

% Construct Third order solution
% third-order time parameter
time_tau = omega * linspace(0,T,500)';  % time variable for 3rd order solution
% switching function
deltan = 2 - northsouth;
% initialize
x_analytic_Lframe = zeros(length(time_tau),1);
y_analytic_Lframe = zeros(length(time_tau),1);
z_analytic_Lframe = zeros(length(time_tau),1);
xdot_analytic_Lframe = zeros(length(time_tau),1);
ydot_analytic_Lframe = zeros(length(time_tau),1);
zdot_analytic_Lframe = zeros(length(time_tau),1);
% third order solution in L-frame
for i = 1:length(time_tau)
    % positions in Lframe
    x_analytic_Lframe(i,1) = ...
        a21 * Ax^2 + a22 * Az^2 - Ax*cos(lambda*time_tau(i,1) + phi) ...
       + (a23*Ax^2 - a24*Az^2)*cos(2*(lambda*time_tau(i,1) + phi)) ...
       + (a31*Ax^3 - a32*Ax*Az^2)*cos(3*(lambda*time_tau(i,1) + phi));
    
    y_analytic_Lframe(i,1) = k*Ax*sin(lambda*time_tau(i,1) + phi) ... 
        + (b21*Ax^2 - b22*Az^2)*sin(2*(lambda*time_tau(i,1) + phi)) ...
        + (b31*Ax^3 - b32*Ax*Az^2) * sin(3*(lambda*time_tau(i,1) + phi));
    
    z_analytic_Lframe(i,1) = deltan * Az*cos(lambda*time_tau(i,1) + phi) ...
        + deltan*d21*Ax*Az*(cos(2*(lambda*time_tau(i,1) + phi)) - 3) ...
        + deltan*(d32*Az*Ax^2 - d31*Az^3)*cos(3*(lambda*time_tau(i,1) + phi));
    
    % velocities
    xdot_analytic_Lframe(i,1) = ( lambda*Ax*sin(lambda*time_tau(i,1) + phi) ...
       + (a23*Ax^2 - a24*Az^2)*2*lambda*sin(2*(lambda*time_tau(i,1) + phi)) ...
       - (a31*Ax^3 - a32*Ax*Az^2)*3*lambda*sin(3*(lambda*time_tau(i,1) + phi)) );
    
    ydot_analytic_Lframe(i,1) = k*Ax*lambda*omega*cos(lambda*time_tau(i,1) + phi) ... 
        + (b21*Ax^2 - b22*Az^2)*2*lambda*omega*cos(2*(lambda*time_tau(i,1) + phi)) ...
        + (b31*Ax^3 - b32*Ax*Az^2) * 3*lambda*omega*cos(3*(lambda*time_tau(i,1) + phi));
    
    zdot_analytic_Lframe(i,1) = ( - deltan * Az*lambda*sin(lambda*time_tau(i,1) + phi) ...
        - deltan*d21*Ax*Az*2*lambda*sin(2*(lambda*time_tau(i,1) + phi)) ...
        - deltan*(d32*Az*Ax^2 - d31*Az^3)*3*lambda*sin(3*(lambda*time_tau(i,1) + phi)) );
end

% ... third order analytical solution in synodic frame
x_analytic_synodic = gammaL * x_analytic_Lframe + LP(lp,1);
y_analytic_synodic = gammaL * y_analytic_Lframe;
z_analytic_synodic = gammaL * z_analytic_Lframe;
xdot_analytic_synodic = gammaL * xdot_analytic_Lframe;
ydot_analytic_synodic = gammaL * ydot_analytic_Lframe;
zdot_analytic_synodic = gammaL * zdot_analytic_Lframe;

% ... third order initial state-vector relative to barycenter
X0 = [x_analytic_synodic(1,1);...
      y_analytic_synodic(1,1);...
	  z_analytic_synodic(1,1);...
	  xdot_analytic_synodic(1,1);...
	  ydot_analytic_synodic(1,1);...
	  zdot_analytic_synodic(1,1)];


end


function out = legendre_cn(n,mu,gammaL,Lpoint)
% function comutes Legendre constant c_n for CR3BP system in colinear
% system
% FORMAT : out = legendre_cn(n,mu,gammaL)
% INPUT :
%   n : >1 (?)
%   mu : CR3BP system mu
%   gammaL : distance to L point of interest
%   Lpoint : 1, 2, or 3
% NOTE : Validated using Richardson (1980)
% Yuri Shimane, 2020/03/05
% ============================================================== 

if Lpoint == 1
    out = (1/gammaL^3) * (mu + (-1)^n * (1-mu)*gammaL^(n+1) / (1 - gammaL)^(n+1));
elseif Lpoint ==2
    out = (1/gammaL^3) * ((-1)^n*mu + (-1)^n * (1-mu)*gammaL^(n+1) / (1 + gammaL)^(n+1));
elseif Lpoint ==3
    out = (1/gammaL^3) * (1 -mu + mu*gammaL^(n+1) / (1 + gammaL)^(n+1));
end

end


function [lambda_val, lambda_realarr, lambda_imagarr] = linear_cr3bp_lambda(c2)
% funtion computes roots of characteristic equation for coupled motion in
% XY plane
% FORMAT: [lambda, lambda_realarr, lambda_imagarr] = linear_cr3bp_lambda(c2)
% Yuri Shimane, 2020/03/07
% ========================================================== %

% initialize
lambda_val = [];

syms lambda 
f = lambda^4 + (c2-2)*lambda^2 - (c2 - 1)*(1 + 2*c2);
% solve function
S = solve(f,0);
j = 1; k = 1;
for i = 1:4
    if imag(double(S(i,1))) == 0
        lambda_realarr(j,1) = double(S(i,1));
        j = j+1;
        % return value of lambda
        lambda_val = abs(lambda_realarr(1,1));
    else
        lambda_imagarr(k,1) = double(S(i,1));
        k = k+1;
    end
end

end