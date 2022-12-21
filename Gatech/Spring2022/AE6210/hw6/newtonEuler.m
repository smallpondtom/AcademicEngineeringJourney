%% Newton-Euler

clear; close all; clc;
syms t real
syms q_1(t) q_2(t) q_3(t) q_4(t) q_5(t)
syms u_1(t) u_2(t) u_3(t) u_4(t) u_5(t)
syms M R g N real

% Sine and cosines
s1 = sin(q_1); c1 = cos(q_1); s2 = sin(q_2); c2 = cos(q_2); t2 = tan(q_2);

% Derivatives
u1d = diff(u_1,t); u2d = diff(u_2,t); u3d = diff(u_3,t);
u4d = diff(u_4,t); u5d = diff(u_5,t);

% Acceleration
a1 = -R*u2d*t2 + u4d*c1 + u5d*s1 + R*u_1*u_2*(2 + t2^2);
a2 = -u4d*s1*s2 + u5d*c1*s2 - R*u_1^2 - R*u_2^2*t2^2;
a3 = R*u1d + u4d*s1*c2 - u5d*c1*c2 + R*u_2^2*t2;
aAC = [a1;a2;a3];

% Angular acceleration
alpha1 = u1d + u_2*(u_3 - u_2*t2);
alpha2 = u2d - u_1*(u_3 - u_2*t2);
alpha3 = u3d;
alphaAC = [alpha1;alpha2;alpha3];

% Angular velocity
wAC = [u_1;u_2;u_3];
wAB = [u_1;u_2;u_2*t2];
wAB = formula(wAB);
wABss = [0,-wAB(3),wAB(2); wAB(3),0,-wAB(1); -wAB(2),wAB(1),0];

% Moment of inertia
I = M*R^2/4 * diag([1,1,2]);
%%
eqn1 = M*a1;
eqn2 = M*a2; % - (N - M*g)*c2;
eqn3 = M*a3; % - (N - M*g)*s2;
%%
T = I*alphaAC + wABss*I*wAC
T = formula(T);
eqn4 = T(1) + N*R*s2;
eqn5 = T(2);
eqn6 = T(3);
%%
syms s_1 s_2 s_3 s_4 s_5
eqn1 = subs(eqn1,[u1d u2d u3d u4d u5d],[s_1 s_2 s_3 s_4 s_5]);
eqn2 = subs(eqn2,[u1d u2d u3d u4d u5d],[s_1 s_2 s_3 s_4 s_5]);
eqn3 = subs(eqn3,[u1d u2d u3d u4d u5d],[s_1 s_2 s_3 s_4 s_5]);
eqn4 = subs(eqn4,[u1d u2d u3d u4d u5d],[s_1 s_2 s_3 s_4 s_5]);
eqn5 = subs(eqn5,[u1d u2d u3d u4d u5d],[s_1 s_2 s_3 s_4 s_5]);
eqn6 = subs(eqn6,[u1d u2d u3d u4d u5d],[s_1 s_2 s_3 s_4 s_5]);
%%
clear
syms u_1 u_2 u_3 u_4 u_5 N real
syms c_1 s_1 c_2 s_2 t_2 real
syms M R g real
E = [0, -M*R*t_2, 0, M*c_1, M*s_1, 0;
     0, 0, 0, -M*s_1*s_2, M*c_1*s_2, -c_2;
     M*R, 0, 0, M*s_1*c_2, -M*c_1*c_2, -s_2;
     M*R^2, 0, 0, 0, 0, 4*R*s_2;
     0, 1, 0, 0, 0, 0;
     0, 0, 1, 0, 0, 0
    ];
A = [-M*R*u_1*u_2*(2+t_2^2);
     M*R*u_1^2 + M*R*u_2^2*t_2^2 - M*g*c_2;
     -M*u_2^2*R*t_2 - M*g*s_2;
     M*R^2*t_2*u_2^2 - M*R^2*u_2*(u_3 - t_2*u_2) - 2*M*R^2*u_2*u_3;
     3*u_1*u_3 - 2*t_2*u_1*u_2;
     0];
simplify(E \ A)