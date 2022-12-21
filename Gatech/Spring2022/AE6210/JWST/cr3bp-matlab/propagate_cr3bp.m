function sol = propagate_cr3bp(x0, tspan, mu, reltol, abstol )
%% Propagate in CR3BP
% Convenience method for propagating in CR3BP.

options = odeset('RelTol',reltol,'AbsTol',abstol);
sol = ode113(@(t,x) rhs_cr3bp(t,x,mu), tspan, x0, options);

end