function dzdt = disk_newtonEuler(t,z,R,g)
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
    den = c2^2 + 5*s2^2;

    dzdt(6) = (-4*g*c2^2*s2 + 2*R*c2^2*t2*u2^2 - 3*R*u3*c2^2*u2 + 4*R*c2*s2*t2^2*u2^2 ...
        + 4*R*c2*s2*u1^2 - 4*g*s2^3 - 2*R*s2^2*t2*u2^2 - 3*R*u3*s2^2*u2) / R / den;
    dzdt(7) = -2*t2*u1*u2 + 3*u1*u3;
    dzdt(9) = (-3*R*c1*c2^2*t2^2*u1*u2 + 3*R*c1*u3*c2^2*t2*u1 - 2*R*c1*c2^2*u1*u2 ...
        + 4*g*s1*c2*s2 - 3*R*s1*c2*t2*u2^2 + 3*R*s1*u3*c2*u2 - 15*R*c1*s2^2*t2^2*u1*u2 ...
        + 15*R*c1*u3*s2^2*t2*u1 - 10*R*c1*s2^2*u1*u2 - 5*R*s1*s2*t2^2*u2^2 - 5*R*s1*s2*u1^2) / den;
    dzdt(10) = (-3*R*s1*c2^2*t2^2*u1*u2 + 3*R*s1*u3*c2^2*t2*u1 - 2*R*s1*c2^2*u1*u2 ...
        - 4*g*c1*c2*s2 + 3*R*c1*c2*t2*u2^2 - 3*R*c1*u3*c2*u2 - 15*R*s1*s2^2*t2^2*u1*u2 ...
        + 15*R*s1*u3*s2^2*t2*u1 - 10*R*s1*s2^2*u1*u2 + 5*R*c1*s2*t2^2*u2^2 + 5*R*c1*s2*u1^2) / den;
end