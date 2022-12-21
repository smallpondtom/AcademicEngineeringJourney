clear 
clc

c = 0.6811;
c1 = 0.2642;

% x0 = [0; 0; 0; u(0)];
x0 = [0, 0, c, c1+c];
t0 = 0; tf = 3;
mesh = linspace(t0, tf, 100);
solinit = bvpinit(mesh, x0);
opts = bvpset('RelTol',1e-5, 'AbsTol',1e-6,'Stats','on','Nmax',500);
sol = bvp4c(@ode,@bc,solinit, opts); 
%% 
plot(sol.x, sol.y(1,:));
%% 
plot(sol.x, sol.y(2,:));
%% 
plot(sol.y(1,:), sol.y(2,:));
%% 

function dxdt = ode(t, x)
    dxdt = zeros(4, 1);
    dxdt(1) = x(2);
    dxdt(2) = -x(2) - x(4);
    dxdt(3) = 0;
    dxdt(4) = -x(3) + x(4);
end

function res = bc(xa, xb)
    res(1) = xb(1) - 1;
    res(2) = xb(2) - 2;
    res(3) = xa(1);
    res(4) = xa(2);
end