%% James Webb Space Telescope Simulation Plots
% Author: Tomoki Koike
clear; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

global animation_on

%% Load data
load('simres.mat');
t = orbit.sol.sunJWST.t;
x_j = orbit.sol.sunJWST.x_j;
y_j = orbit.sol.sunJWST.y_j;
z_j = orbit.sol.sunJWST.z_j; 
vx_j = orbit.sol.sunJWST.vx_j;
vy_j = orbit.sol.sunJWST.vy_j;
vz_j = orbit.sol.sunJWST.vz_j;
r = orbit.sol.sunJWST.r; 
r1 = orbit.sol.sunJWST.r1;
r2 = orbit.sol.sunJWST.r2;

xi = orbit.sol.sunJWST.xi;
yi = orbit.sol.sunJWST.yi;
vxi = orbit.sol.sunJWST.vxi;
vyi = orbit.sol.sunJWST.vyi;

x_e = orbit.sol.earthJWST.x_e; 
y_e =orbit.sol.earthJWST.y_e;
z_e = orbit.sol.earthJWST.z_e;
vx_e = orbit.sol.earthJWST.vx_e;
vy_e = orbit.sol.earthJWST.vy_e;
vz_e = orbit.sol.earthJWST.vz_e;

%% Plot Simulation
 
% Sun-Earth frame
figure(1);
plot3(x_j,y_j,z_j,'-m')
grid on; grid minor; box on; hold on;
plot3(orbit.r12,0,0,'.g','MarkerSize',20);
hold off;
view([-18, 28])
xlabel('$x$')
ylabel('$y$')
zlabel('$z$')


% Inertial frame
figure(2);
plot3(0,0,0,'.r','MarkerSize',40);
hold on; grid on; grid minor; box on;
plot3(xi,yi,z_j,'-b')
plot3(x_e,y_e,z_e,'-.g')
hold off;
xlabel('$x$')
ylabel('$y$')
zlabel('$z$')

%% Animate Simulation

if animation_on == 1
    figure(3);
    plot3(0,0,0,'.r','MarkerSize',40);
    hold on;
    hh1 = line(xi(1),yi(1),z_j(1),'Marker','.','MarkerSize',20,'Color','b');
    hh2 = line(orbit.r12,0,0,'MarkerSize',40,'Marker','.','Color','g');
    hh3 = line(xi(1),yi(1),z_j(1),'LineStyle','-','Color','b');
    hh4 = line(orbit.r12,0,0,'LineStyle','-.','Color','g');
    
    xlabel('x'); ylabel('y'); zlabel('z');
    grid on; grid minor; box on;
    axis([-2E+08 2E+08 -2E+08 2E+08 -8E+05 8E+05]);
    view(3)
    % set(gcf,'WindowState','fullscreen')
    
    tic;     % start timing
    for i = 1:800:length(t)
       % Update XData, YData, and ZData
       set(hh1,'XData',xi(i),'YData',yi(i),'ZData',z_j(i));
       set(hh2,'XData',x_e(i),'YData',y_e(i),'ZData',z_e(i));
       set(hh3,'XData',xi(1:i),'YData',yi(1:i),'ZData',z_j(1:i));
       set(hh4,'XData',x_e(1:i),'YData',y_e(1:i),'ZData',z_e(1:i));
       drawnow;
    end
    fprintf('Animation (Smart update): %0.2f sec\n', toc);
    hold off;
end