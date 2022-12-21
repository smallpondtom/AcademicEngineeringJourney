function dzdt = disk_lagrange(t,z,R,g)
    % Preallocate output
    dzdt = zeros(10,1);

    % Unpack the variables
    q1 = z(1); q2 = z(2); q3 = z(3); q4 = z(4); q5 = z(5);
    qd1 = z(6); qd2 = z(7); qd3 = z(8); qd4 = z(9); qd5 = z(10);
    
    % Trigs
    s1 = sin(q1); s2 = sin(q2); c1 = cos(q1); c2 = cos(q2); t2 = tan(q2);

    % Kinematic differential equation
    dzdt(1) = qd1;
    dzdt(2) = qd2;
    dzdt(3) = qd3;
    dzdt(4) = qd4;
    dzdt(5) = qd5;

    % Dynamic differential equations
    % LHS matrix
    E = zeros(5,5);
    E(1,1) = R^2/2*(6 - 5*c2^2);
    E(1,3) = R/2*s2;
    E(1,4) = -c1*s2;
    E(1,5) = -s1*s2;
    E(2,2) = 5*R^2/4;
    E(2,4) = -s1*c2;
    E(2,5) = c1*c2;
    E(3,1) = s2;
    E(3,3) = 1;
    E(4,1) = R*c1*s2;
    E(4,2) = R*c2*s1;
    E(4,4) = -1;
    E(5,1) = R*s1*s2;
    E(5,2) = -R*c1*c2;
    E(5,5) = -1;

    % RHS
    dzdt(6) = -5*R/2*c2*s2*qd1*qd2 - R/2*c2*qd2*qd3;
    dzdt(7) = 5*R/4*s2*c2*qd1^2 + R/2*c2*qd1*qd3 + g*s2;
    dzdt(8) = -c2*qd1*qd2;
    dzdt(9) = R*s1*s2*qd1^2 + R*s1*s2*qd2^2 - 2*R*c1*c2*qd1*qd2;
    dzdt(10) = -R*c1*c2*qd1^2 - R*c1*s2*qd2^2 - 2*R*c2*s1*qd1*qd2;

    % Output
    dzdt(6:10) = E \ dzdt(6:10);
end