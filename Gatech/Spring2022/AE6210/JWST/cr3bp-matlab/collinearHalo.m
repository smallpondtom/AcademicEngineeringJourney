function [X0_halo,Thalo,flag] = ...
    collinearHalo(mu,Lstar,phi,lp,northsouth,Az_km,tolDC)
% Create halo via 3rd order initial guess followed by 
% differential correction. 
% Yuri Shimane, 2022/02/15
% =============================================== %
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
%   state : 6x1 array of initial state for Halo
%   period : period
%   flag : 1 if successful, 0 if not
% ======================================================= %

% analytical 3rd order solution
[X0_analytical,T_analytical,~,~,~] = ...
    collinearHalo_3rdOrderGuess(mu,Lstar,phi,lp,northsouth,Az_km);

% Differential-correction
% max number of iterations
maxiter = 50;
% tolerance setting for ode45
reltol = 1e-12;
abstol = 1e-13;
% run DC algorithm
[X0_halo,Thalo,flag] = ...
    collinearHalo_diffCorr_fixPeriod(mu,X0_analytical,T_analytical,...
                                tolDC,maxiter,reltol,abstol);

end