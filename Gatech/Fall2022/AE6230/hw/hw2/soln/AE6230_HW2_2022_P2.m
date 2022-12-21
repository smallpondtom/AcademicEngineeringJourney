%% This script solves HW2 Problem 2

%% Cristina Riso, criso@gatech.edu

clearvars
close all
clc


%% Problem parameters

% natural frequency (rad/s)
omega_n = 20.0*pi; 

% period of undamped motion (s)
T_n = 2.0*pi/omega_n;

% excitation length (s)
T_2 = 0.5;

% ramp lengths (s)
T_1 = T_n*[0.1, 0.5, 1.0, 1.5, 2.0, 2.5]; n_resp = length(T_1);


%% Q3 - Plot responses

% initial and final times, time step, number of times
t_i = 0.0; t_f = 1.5; dt = 0.0005; t = t_i:dt:t_f; n_t = length(t);

% allocate normalized response (-)
x_over_x_s = zeros(n_resp,n_t);

% allocate maximum normalized responses during pulse (-)
x_over_x_s_max = zeros(1,n_resp);

% loop the ramp lengths
for i = 1:n_resp
    
    % extract current ramp length
    T_1_i = T_1(i);

    % compute normalized response
    for j = 1:n_t
        
        % ramp up
        if t(j) < T_1_i
            x_over_x_s(i,j) = omega_n*t(j)-sin(omega_n*t(j));
        end
        
        % costant value
        if t(j) >= T_1_i && t(j) < T_1_i+T_2
            x_over_x_s(i,j) = omega_n*T_1_i+sin(omega_n*(t(j)-T_1_i))-sin(omega_n*t(j));
        end
        
        % ramp down
        if t(j) >= T_1_i+T_2 && t(j) < 2.0*T_1_i+T_2
            x_over_x_s(i,j) = 2.0*omega_n*T_1_i+omega_n*T_2-omega_n*t(j)+sin(omega_n*(t(j)-T_1_i))-sin(omega_n*t(j))+sin(omega_n*(t(j)-T_1_i-T_2));
        end
        
        % back to zero
        if t(j) >= 2.0*T_1_i+T_2
            x_over_x_s(i,j) = sin(omega_n*(t(j)-T_1_i))-sin(omega_n*t(j))+sin(omega_n*(t(j)-T_1_i-T_2))-sin(omega_n*(t(j)-2.0*T_1_i-T_2));
        end
        
    end
    
    % multiply normalized response by constants (m)
    x_over_x_s(i,:) = x_over_x_s(i,:)/(T_1_i*omega_n);
    
    % maximum normalized amplitude during pulse
    x_over_x_s_max(i) = 1.0+1.0/(pi*T_1(i)/T_n)*abs(sin(pi*T_1(i)/T_n));    
    
    % open figure
    fig1 = figure(1000+i); hold all;
    set(fig1,'Position',[0 0 1200 900]);
    
    % plot normalized response
    plot(t,x_over_x_s(i,:),'LineWidth',2); hold all;
    plot([t(1) t(end)],[0.0 0.0],'k--','LineWidth',1);
    plot([t(1) t(end)],[1.0 1.0],'k--','LineWidth',1);
    plot([t(1) t(end)],[x_over_x_s_max(i) x_over_x_s_max(i)],'k--','LineWidth',1);
    
    % set axes and ticks
    ax = gca; ax.FontSize = 28;
    
    % set labels
    ylabel('$x(t)/x_s$ (-)','Interpreter','latex'); xlabel('$t$ (s)','Interpreter','latex'); axis([0.0 t(end) -2.0 2.0]);
    
    % get figure handle
    f = gcf;
    
    % export figure
    exportgraphics(f,strcat('x_over_x_0_T1_',num2str(T_1_i),'.pdf'),'Resolution',300)

end


%% Q5 - Plot response spectrum

% range of values of T_1/T_n
T_1_over_T_n_range = 0.001:0.001:4.0;

% maximum normalized responses during pulse (-)
x_over_x_s_max_range = 1.0+1.0./(pi.*T_1_over_T_n_range).*abs(sin(pi*T_1_over_T_n_range)); 

% plot
fig1 = figure(1); hold all;
set(fig1,'Position',[0 0 1200 900]); ax = gca; ax.FontSize = 28; hold all;
plot(T_1_over_T_n_range,x_over_x_s_max_range,'LineWidth',2); 
plot(T_1/T_n,x_over_x_s_max,'ko','MarkerFaceColor','k','MarkerSize',10); 
ylabel('$x_{max}/x_s$ (-)','Interpreter','latex'); xlabel('$T_1/T_n$ (-)','Interpreter','latex'); 
f = gcf; exportgraphics(f,'x_max_over_x_s.pdf','Resolution',300);