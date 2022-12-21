function sols = npc_period(state0,period0,mu,dperiod,nmax,tolDC)
%% Natural parameter continuation of period
%

% max number of iterations
maxiter = 30;
% tolerance setting for ode45
reltol = 1e-12;
abstol = 1e-13;

% initialize
state_iter = state0;
period_iter = period0;
num_sols = 0;

for k = 1:nmax
    fprintf("Generating family num. %i/%i\n",k,nmax)
    % construct new period
    period_iter = period_iter + dperiod;
    % construct Halo orbit
    [state,period,flag] = ...
        collinearHalo_diffCorr_fixPeriod(...
            mu, state_iter, period_iter, tolDC, maxiter, reltol, abstol);
    if flag == 0
        fprintf("Could not converge at iteration %i, period %1.4e\n",...
            k,period_iter);
        break
    end
    % check if planar
    if abs(state(3)) < 1e-14 && abs(state(6)) < 1e-14
        fprintf("Planar member at iteration %i\n",k);
        break
    end
    
    % store
    if num_sols == 0
        sols = vertcat(state,period);
    else
        sols = horzcat(sols, vertcat(state,period));
    end
    num_sols = num_sols + 1;
    
    % update
    period_iter = period;
    state_iter = state;
end

end