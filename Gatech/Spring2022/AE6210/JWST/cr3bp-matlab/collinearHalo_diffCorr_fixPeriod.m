function [state,period,flag] = ...
    collinearHalo_diffCorr_fixPeriod(mu, state0, period0, tolDC, maxiter, reltol, abstol)
% Function applies differential correction to state0 to generate 
% periodic halo orbit about collinear libratin point
% Yuri Shimane, 2022/02/15
% ======================================================= %
% INPUT
%   mu : cr3bp mass parameter
%   X0_DC : 6x1 array of guessed initial state of halo, must be on xz-plane
%   period0 : initial guess for period
%   tolDC : tolerance on residuals on at period/2
%   maxiter : (default: 6) # of DC iteration allowed
%   reltol : (default: 1e-5) relative tolerance for ode45
%   abstol : (default: 1e-7) absolute tolerance for ode45
%   maxiter : (default: 6) # of DC iteration allowed
%
% OUTPUT
%   state : 6x1 array of initial state for Halo
%   period : period
%   flag : 1 if successful, 0 if not
% ======================================================= %
%fprintf("Correcting via single-shooting...\n");

% ODE options
options = odeset('RelTol',reltol,'AbsTol',abstol);

% initialize free-variable vector
X_DC = [state0(1); state0(3); state0(5)];

% initialize flag
flag = 0;

% iterate newton-raphson method
for i = 1:maxiter
    
    % propagate
    state0_stm = vertcat(state0, reshape(eye(6),36,1));
    [~, dynmat] = ode45(@(t,x) rhs_cr3bp_stm(t,x,mu), ...
        [0 period0/2], state0_stm, options);
    svf = dynmat(end,1:6);
    stm = reshape(dynmat(end,7:42),6,6)';
    
    % Residual
    F = [svf(2); svf(4); svf(6)];
    
    % break if tolerance is cleared
    residual = norm(F);
    %fprintf("  Iteration %2.0f : |F| = %1.4e\n",i,residual);
    if residual < tolDC
        %fprintf("  Requested tol = %1.4e cleared at iter. %i!\n",tolDC,i)
        flag = 1;
        break
    end
    
    % construct Jacobian Jacobian
    DF = [stm(2,1) stm(2,3) stm(2,5);...
          stm(4,1) stm(4,3) stm(4,5);...
          stm(6,1) stm(6,3) stm(6,5);];
    
    % Newton-Raphson update
    X_DC_new = X_DC - inv(DF)*F;
    
    % update state-vector
    state0 = [X_DC_new(1,1); 0; X_DC_new(2,1); 0; X_DC_new(3,1); 0];
    
    % update X_DC
    X_DC = X_DC_new;
end

% assign outputs
state = state0;
period = period0;

end
