function Xdot = rhs_cr3bp_stm(t, X, mu)
% CR3BP Equation of Motion with STM
% Function evaluates derivative of state

    % decompose state and STM
    x = X(1,1);  y = X(2,1);  z = X(3,1);
    vx = X(4,1); vy = X(5,1); vz = X(6,1);
%     stm = zeros(6,6);
%     for row = 1:6
%         for col = 1:6
%             stm(row,col) = X(6+col+(row-1)*6, 1);
%         end
%     end
    stm = reshape(X(7:42,1),6,6)';
    % calculate radii
    r1 = sqrt( (x+mu)^2 + y^2 + z^2 );
    r2 = sqrt( (x-1+mu)^2 + y^2 + z^2 );
    % --- STATE DERIVATIVE --- %
    % initialize double
    Xdot = zeros(42,1);
    % position-state derivative
    Xdot(1,1) = vx;
    Xdot(2,1) = vy;
    Xdot(3,1) = vz;
    % velocity-state derivative
    Xdot(4,1) = 2*vy + x - ((1-mu)/r1^3)*(mu+x) + (mu/r2^3)*(1-mu-x);
    Xdot(5,1) = -2*vx + y - ((1-mu)/r1^3)*y - (mu/r2^3)*y;
    Xdot(6,1) = -((1-mu)/r1^3)*z - (mu/r2^3)*z;
    % --- A-MATRIX --- %
    % initialize A-matrix
    A11 = zeros(3,3);
    A12 = eye(3);
    A22 = 2*[0  1 0;
             -1 0 0;
             0  0 0];
    % construct U matrix
    Uxx = 1 - (1-mu)/r1^3 - mu/r2^3 + 3*((x+mu)^2 *(1-mu)/r1^5 ...
                + (x+mu-1)^2*mu/r2^5);
    Uyy = 1 - (1-mu)/r1^3 - mu/r2^3 + 3*y^2*((1-mu)/r1^5 + mu/r2^5);
    Uzz = -(1-mu)/r1^3 - mu/r2^3 + 3*z^2*((1-mu)/r1^5 + mu/r2^5);
    Uxy = 3*y*((x+mu)*(1-mu)/r1^5 + (x+mu-1)*mu/r2^5);
    Uxz = 3*z*((x+mu)*(1-mu)/r1^5 + (x+mu-1)*mu/r2^5);
    Uyz = 3*y*z*((1-mu)/r1^5 + mu/r2^5);
    Uderiv = [Uxx, Uxy, Uxz;
              Uxy, Uyy, Uyz;
              Uxz, Uyz, Uzz];
    % update A-matrix
    A = [A11,    A12;
         Uderiv, A22];
    % differential relation
    stmdot = A * stm;
    % store elements of A in Xdot(7,1) ~ onwards
    Xdot(7:42,1) = reshape(stmdot',36,1);
%     for row = 1:6
%         for col = 1:6
%             Xdot(6+col+(row-1)*6, 1) = stmdot(row,col);
%         end
%     end
end