%% Lagrange

syms t real
syms q_1(t) q_2(t) q_3(t) q_4(t) q_5(t)
syms M R g real

c1 = cos(q_1);
s1 = sin(q_1);
c2 = cos(q_2);
s2 = sin(q_2);
t2 = tan(q_2);

u1 = -diff(q_2,t);
u2 = diff(q_1,t)*c2;
u3 = diff(q_1,t)*s2+diff(q_3,t);
u4 = diff(q_4,t);
u5 = diff(q_5,t);

% Angular velocity
wAC = [u1;u2;u3];

v1 = -R*u2*t2+u4*c1+u5*s1;
% v2 = -u4*c1*s1+u5*c1*s2;
v2 = s2*(-u4*s1 + u5*c1);
v3 = R*u1+u4*s1*c2-u5*c1*c2;

% Velocity
vAC = [v1;v2;v3];

% Moment of inertia
Ib = M*R^2/4 * [1,0,0; 0,1,0; 0,0,2];
%%
% Kinetic and potential Energy 
Tt = simplify(M*(vAC.')*vAC/2)  % translational
Tr = simplify((wAC.') * Ib * wAC / 2)  % rotational 
V = -M*g*R*(1-c2);
%%
% Lagrange 
L = simplify(Tt + Tr - V)
%%
% EOMs
vars = [diff(diff(q_1,t),t),...
        diff(diff(q_2,t),t),...
        diff(diff(q_3,t),t),...
        diff(diff(q_4,t),t),...
        diff(diff(q_5,t),t)];
eqn1 = simplify(diff(diff(L,diff(q_1,t)),t) - diff(L,q_1));
eqn2 = simplify(diff(diff(L,diff(q_2,t)),t) - diff(L,q_2));
eqn3 = simplify(diff(diff(L,diff(q_3,t)),t) - diff(L,q_3));
eqn4 = simplify(diff(diff(L,diff(q_4,t)),t) - diff(L,q_4));
eqn5 = simplify(diff(diff(L,diff(q_5,t)),t) - diff(L,q_5));
%%
collect(eqn1,vars)
collect(eqn2,vars)
collect(eqn3,vars)
collect(eqn4,vars)
collect(eqn5,vars)