function Xdot = rhs_cr3bp(t, X, mu)
% CR3BP Equation of Motion
% Function evaluates derivative of state

    % decompose state and STM
    x = X(1,1);  y = X(2,1);  z = X(3,1);
    vx = X(4,1); vy = X(5,1); vz = X(6,1);

    % calculate radii
    r1 = sqrt( (x+mu)^2 + y^2 + z^2 );
    r2 = sqrt( (x-1+mu)^2 + y^2 + z^2 );
    
    % --- STATE DERIVATIVE --- %
    % initialize double
    Xdot = zeros(6,1);
    % position-state derivative
    Xdot(1,1) = vx;
    Xdot(2,1) = vy;
    Xdot(3,1) = vz;
    % velocity-state derivative
    Xdot(4,1) = 2*vy + x - ((1-mu)/r1^3)*(mu+x) + (mu/r2^3)*(1-mu-x);
    Xdot(5,1) = -2*vx + y - ((1-mu)/r1^3)*y - (mu/r2^3)*y;
    Xdot(6,1) = -((1-mu)/r1^3)*z - (mu/r2^3)*z;
end