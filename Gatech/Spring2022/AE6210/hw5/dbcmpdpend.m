clear; close all; clc;

syms F_1x F_2x F_1y F_2y 
syms theta_1(t) theta_2(t) l m g

dtheta1 = diff(theta_1,t);
ddtheta1 = diff(dtheta1,t);
dtheta2 = diff(theta_2,t);
ddtheta2 = diff(dtheta2,t);
I = 1/12*m*l^2;

F_3x = m*(l*ddtheta1*cos(theta_1)-l*dtheta1^2*sin(theta_1) ...
    + l/2*ddtheta2*cos(theta_2)-l/2*dtheta2^2*sin(theta_2));
F_3y = -m*(l*ddtheta1*sin(theta_1)+l*dtheta1^2*cos(theta_1) ...
    + l/2*ddtheta2*sin(theta_2)+l/2*dtheta2^2*cos(theta_2)) - m*g;

% EOM of theta2
eom2 = I*ddtheta2 + F_3x*l/2*cos(theta_2) - F_3y*l/2*sin(theta_2) == 0;
eom2 = simplify(expand(eom2))
%%

eqn1 = F_1x - F_2x == m*(l/2*ddtheta1*cos(theta_1) - l/2*dtheta1^2*sin(theta_1));
eqn2 = F_2y - F_1y - m*g == m*(l/2*ddtheta1*sin(theta_1)+l/2*dtheta1^2*cos(theta_1));

eqn1 = subs(eqn1,F_2x,F_3x);
eqn2 = subs(eqn2,F_2y,F_3y);

F1x = solve(eqn1,F_1x);
F1y = solve(eqn2,F_1y);

eqn5 = I*ddtheta1 - (-F_1x*l/2*cos(theta_1)+F_1y*l/2*sin(theta_1) ...
    -F_2x*l/2*cos(theta_1)+F_2y*l/2*sin(theta_1)) == 0;

% EOM of theta1
eom1 = subs(eqn5,[F_1x F_1y F_2x F_2y],[F1x F1y F_3x F_3y]);
eom1 = simplify(expand(eom1))