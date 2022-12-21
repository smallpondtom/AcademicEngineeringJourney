%% James Webb Space Telescope Simulation Verifications
% Author: Tomoki Koike
addpath("horizons_systems_data");

%% Data comparison with Horizons System (Sun - JWST) 
sj_data = readmatrix("sun_jwst_rawdata.txt",'Delimiter',',');
sj_data = sj_data(:,3:end);

figure(4);
plot3(0,0,0,'.r','MarkerSize',40,HandleVisibility='off');
hold on; grid on; grid minor; box on; 
plot3(sj_data(:,1),sj_data(:,2),sj_data(:,3),'-b',DisplayName="Horizons System")
plot3(xi,yi,z_j,'-r',"DisplayName","Sim")
plot3(x_e,y_e,z_e,'-.g',HandleVisibility='off')
hold off; legend('Location','northwest');

%% Sun - JWST Animation (Horizons Systems Data)
% figure(5);
% plot3(0,0,0,'.r','MarkerSize',40);
% hold on;
% plot3(x_e,y_e,z_e,'-.g')
% hh5(1) = line(sj_data(1,1),sj_data(1,2),sj_data(1,3),'Marker','.','MarkerSize',20,'Color','b');
% hh5(2) = line(sj_data(1,1),sj_data(1,2),sj_data(1,3),'LineStyle','-','Color','b');
% 
% xlabel('x'); ylabel('y'); zlabel('z');
% grid on; grid minor; box on;
% axis([-2E+08 2E+08 -2E+08 2E+08 -8E+05 8E+05]);
% view(3)
% 
% tic;     % start timing
% for i = 1:20:length(sj_data(:,1))
%    % Update XData, YData, and ZData
%    set(hh5(1),'XData',sj_data(i,1),'YData',sj_data(i,2),'ZData',sj_data(i,3));
%    set(hh5(2),'XData',sj_data(1:i,1),'YData',sj_data(1:i,2),'ZData',sj_data(1:i,3));
%    drawnow;
% end
% fprintf('Animation (Smart update): %0.2f sec\n', toc);
% hold off;

%% Data comparison with Horizons System (Earth - JWST) 
% ej_data = readmatrix("earth_jwst_rawdata.txt",'Delimiter',',');
% ej_data = ej_data(:,3:end);
% 
% figure(6);
% plot3(orbit.r12,0,0,'.g','MarkerSize',20);
% hold on; grid on; grid minor; box on; 
% plot3(x_j,y_j,z_j,'-m')
% plot3(ej_data(:,1)+orbit.r12,ej_data(:,2),ej_data(:,3),'-m')
% hold off;

%% Positions and velocities with respect to time 

% inertial frame
% JWST orbiting the Sun

% x and y
figure(7);
plot(t,xi,'DisplayName',"x")
hold on; grid on; grid minor; box on;
plot(t,yi,"DisplayName",'y')
hold off; legend;
xlabel('$t$ [km]')
ylabel('$x$ and $y$ position [km]')

% z
figure(8);
plot(t,z_j,'DisplayName','z')
grid on; grid minor; box on;
xlabel('$t$ [km]')
ylabel('$z$ [km]')

% vx 
figure(9);
plot(t,vxi,'DisplayName','v_x')
grid on; grid minor; box on;
xlabel('$t$ [km]')
ylabel('$v_x$ [km/s]')

% vy 
figure(10)
plot(t,vyi,'DisplayName','v_y')
grid on; grid minor; box on;
xlabel('$t$ [km]')
ylabel('$v_y$ [km/s]')

% vz
figure(11);
plot(t,vz_j,'DisplayName','v_z')
grid on; grid minor; box on;
xlabel('$t$ [km]')
ylabel('$v_z$ [km/s]')


%% Jacobi constant 
rho = vecnorm(r,2,2) / orbit.r12;
sig = vecnorm(r1,2,2) / orbit.r12;
psi = vecnorm(r2,2,2) / orbit.r12;

KE = 0.5*(vx_j.^2 + vy_j.^2 + vz_j.^2);
PE = (-(1 - orbit.eta2)./sig - orbit.eta2./psi ...
    - 0.5*((1-orbit.eta2).*sig.^2 + orbit.eta2*psi.^2));
J = KE + PE;

figure(12);
    plot(t,J,'-.b')
    grid on; grid minor; box on; 
    xlabel('$t [s]$')
    ylabel('Jacobi Constant [kJ]')