function dzdt = disk_kane(t,z,R,g)
    % Preallocate output
    dzdt = zeros(10,1);

    % Unpack the variables
    q1 = z(1); q2 = z(2); q3 = z(3); q4 = z(4); q5 = z(5);
    u1 = z(6); u2 = z(7); u3 = z(8); u4 = z(9); u5 = z(10);
    
    % Trigs
    s1 = sin(q1); s2 = sin(q2); c1 = cos(q1); c2 = cos(q2); t2 = tan(q2);

    % Kinematic differential equation
    dzdt(1) = u2 * sec(q2);
    dzdt(2) = -u1;
    dzdt(3) = -u2*t2 + u3;
    dzdt(4) = u4;
    dzdt(5) = u5;
    
    % Dynamic differential equation
    % LHS matrix 
    E = zeros(5,5);
    E(1,1) = 5*R;
    E(1,4) = 4*s1*c2;
    E(1,5) = -4*c1*c2;
    E(2,2) = R*(1 + 4*t2^2);
    E(2,4) = -4*c1*t2;
    E(2,5) = -4*s1*t2;
    E(3,3) = 1;
    E(4,1) = R*s1*c2;
    E(4,2) = -R*c1*t2;
    E(4,4) = 1;
    E(5,1) = R*c1*c2;
    E(5,2) = R*s1*t2;
    E(5,5) = -1;

    % RHS 

    dzdt(6) = -R*t2*u2^2 - 3*R*u2*u3 - 4*g*s2;
    dzdt(7) = 2*R*t2*(3 + 2*t2^2)*u1*u2 + 3*R*u1*u3;

%     dzdt(6) = -3*R*t2*u2^2 - 2*R*u2*u3 - 4*g*s2;
%     dzdt(7) = R*t2*(7 + 4*t2^2)*u1*u2 + 2*R*u1*u3;

    dzdt(9) = -R*s1*s2*u1^2 - R*s1*s2*(1 + t2^2)*u2^2 - R*c1*(2 + t2^2)*u1*u2;
    dzdt(10) = -R*c1*s2*u1^2 - R*c1*s2*(1 + t2^2)*u2*2 + R*s1*(2 + t2^2)*u1*u2;
    
    % Output
    dzdt(6:10) = E \ dzdt(6:10);
end