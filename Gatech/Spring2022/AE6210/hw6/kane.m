%% Kanes

clear; close all; clc;
syms t real
syms q_1(t) q_2(t) q_3(t) q_4(t) q_5(t)
syms u_1(t) u_2(t) u_3(t) u_4(t) u_5(t)
syms M R g real

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
% wAB = [u_1;u_2;u_2*t2];

% Partial velocities
v1 = [0; 0; R];
v2 = [-R*t2; 0; 0];
v3 = [0; 0; 0];
v4 = [c1; -s1*s2; s1*c2];
v5 = [s1; c1*s2; -c1*c2];

% Partial angular velocities
w1 = [1; 0; 0];
w2 = [0; 1; 0];
w3 = [0; 0; 1];
w4 = [0; 0; 0];
w5 = [0; 0; 0];

% Moment of inertia
I = M*R^2/4 * diag([1,1,2]);
%%
% Generalized active force
Rf = -M*g*[0; c2; s2];
F1 = (v1.') * Rf
F2 = (v2.') * Rf
F3 = (v3.') * Rf
F4 = (v4.') * Rf
F5 = (v5.') * Rf
%%
% Generalized inertia force
Tstar = collect(simplify(-I*alphaAC - cross(wAC,I*wAC)),M*R^2)
Fstar = simplify(-M*aAC)
Fstar1 = (w1.') * Tstar + (v1.') * Fstar
Fstar2 = (w2.') * Tstar + (v2.') * Fstar
Fstar3 = (w3.') * Tstar + (v3.') * Fstar
Fstar4 = (w4.') * Tstar + (v4.') * Fstar
Fstar5 = (w5.') * Tstar + (v5.') * Fstar
%%
% Equations of motion
eqn1 = simplify(expand(F1 + Fstar1))
eqn2 = simplify(expand(F2 + Fstar2))
eqn3 = simplify(expand(F3 + Fstar3))
eqn4 = simplify(expand(F4 + Fstar4))
eqn5 = simplify(expand(F5 + Fstar5))
%%
collect(eqn1,[u1d,u2d,u3d,u4d,u5d])
collect(eqn2,[u1d,u2d,u3d,u4d,u5d])
collect(eqn3,[u1d,u2d,u3d,u4d,u5d])
collect(eqn4,[u1d,u2d,u3d,u4d,u5d])
collect(eqn5,[u1d,u2d,u3d,u4d,u5d])