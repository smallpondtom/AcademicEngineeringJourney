%% This script solves HW4 Problem 2

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc

% color-blind-friedly colors
c1 = [0.0000, 0.4470, 0.7410];
c2 = [0.8500, 0.3250, 0.0980];


%% Problem parameters

% beam length (m)
l = 1.0;

% number of modes to be retained
N = [1, 5, 10, 50];

% indices of modes 
i = 1:N(end);

% normalized space domain (-)
x_over_l = 0:0.0001:1.0; n_x = length(x_over_l);


%% Q3 - Verify convergence of initial twist angle graphically

% open plot
fig = figure(100); hold all; set(fig,'Position',[0 0 1200 900]); 

% loop the maximum number of modes
for j = 1:length(N)
    
    % initialize initial twist angle
    theta_0 = zeros(1,n_x);
   
    % loop the modes
    for n = 1:N(j)
        
        % sum current modal contribution
        theta_0 = theta_0+sin((2*n-1)*pi*x_over_l/2.0)/((2*n-1)^2)*(-1)^(n+1);
        
    end
    
    % multiply by constants
    theta_0 = theta_0*8.0/(pi^2);
    
    % note that each curve in the plot is NOT an individual modal
    % contribution but the overall initial twist angle obtained by
    % considering the first N modes
    
    % plot the approximate initial twist angle
    plot(x_over_l,theta_0,'-','LineWidth',2);
    
end

ax = gca; ax.FontSize = 28; axis([x_over_l(1) x_over_l(end) 0.0 1.0]); yticks(0:0.2:1.0);
hleg = legend('$N = 1$','$N = 5$','$N = 10$','$N = 50$','Interpreter','latex'); set(hleg,'Location','NorthWest'); 
ylabel('$\theta(x,0)/\bar{\theta}$ (-)','Interpreter','latex'); xlabel('$x/l$ (-)','Interpreter','latex');
f = gcf; exportgraphics(f,'theta_0.pdf','Resolution',300);