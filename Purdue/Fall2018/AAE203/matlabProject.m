%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AAE 20300 Extra Credit Assignment 
% Name: TomokiKoike 
% Professor: Professor Ye
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 
% *DECLARATIONS*
g = 9.8; % gravitational acceleration (m/s^2)
m = 50; % mass of object (kg)

%% 
% *VELOCITY VS TIME*
figure
% initial value v(0)= sqrt(k/m), vp(0)= -k/m
for k = 250:250:1000 % spring constant (N/m)
    [t,v] = ode45(@(t,v) diffFcn1(t,v,m,k), [0,20], [sqrt(k/m);-k/m]);
    % plotting
    hold on
    plot(t,v(:,1),'-o');
    title('Spring-Mass System On Slope');
    xlabel('time (s)');
    ylabel('velocity (m/s)');
    grid on;
end
legend('k=250','k=500','k=750','k=1000','location','southwest');
hold off

%% 
% *ACCELERATION VS TIME*
figure
% initial value a(0)= -k/m, ap(0)= -(k/m)^(3/2)
for k = 250:250:1000 % spring constant (N/m)
    [t,v] = ode45(@(t,a) diffFcn2(t,a,m,k), [0,20], [-k/m;-(k/m)^(3/2)]);
    % plotting
    hold on
    plot(t,v(:,1),'-o');
    title('Spring-Mass System On Slope');
    xlabel('time (s)');
    ylabel('acceleration (m/s^2)');
    grid on;
end
legend('k=250','k=500','k=750','k=1000','location','southwest');
hold off

%% 
% *ACCELERATION VS VELOCITY* 
figure
% initial value a(0) = 0
for k = 250:250:1000 % spring constant (N/m)
    [v,a] = ode45(@(v,a) -k/m.*v, [0,20], 0);
    % plotting
    hold on
    plot(v,a(:,1),'-o');
    title('Spring-Mass System On Slope');
    xlabel('velocity (m/s)');
    ylabel('acceleration (m/s^2)');
    grid on;
end
legend('k=250','k=500','k=750','k=1000','location','southwest');
hold off

%% 
% *FUNCTION DEFINITIONS*

% declaring the differential equation (VELOCITY VS TIME)
function dvdt = diffFcn1(t,v,m,k)
dvdt = zeros(2,1);
dvdt(1) = v(2);
dvdt(2) = -k/m.*v(1);
end
% declaring the differential equation (ACCELERATION VS TIME)
function dadt = diffFcn2(t,a,m,k)
dadt = zeros(2,1);
dadt(1) = a(2);
dadt(2) = -k/m.*a(1);
end

% sample of the function for declaring the function including the 
% second order differential equation 

