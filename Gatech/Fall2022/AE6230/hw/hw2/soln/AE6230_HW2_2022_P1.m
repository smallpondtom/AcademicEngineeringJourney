%% This script solves HW2 Problem 1

% Cristina Riso, criso@gatech.edu

clearvars
close all
clc


%% Problem parameters

% excitation peak value (N)
F_0 = 1.0;

% excitation period (s)
T = 0.2;

% excitation fundamental frequency (rad/s)
omega_0 = 2.0*pi/T;

% frequency ratio (-)
omega_n_over_omega_0 = 5.0;

% natural frequency (rad/s)
omega_n = omega_n_over_omega_0*omega_0;

% viscous damping factor (-)
zeta = 0.05;

% stiffness constant (N/m)
k = 10.0;

% number of harmonics for discrete frequency spectrum plot
n_harmonics = 12;

% time (s)
t_1 = 0.0; t_2 = T; dt = T/200.0; t = t_1:dt:t_2; n_t = length(t);

% desired percentages of F_0
perc = [0.05, 0.025, 0.005];


%% Q1 - Fourier coefficients

% zeroth-order coefficient (N)
a_0 = F_0;

% allocate vector of Fourier coefficients (N)
a_p = zeros(1,n_harmonics);

% loop the non-zero harmonics
for p = 1:2:n_harmonics
    
    % compute Fourier coefficient (multiply by constants later)
    a_p(p) = 1.0/p^2;
    
end

% multiply by constants
a_p = -a_p*4.0*F_0/pi^2;

% absolute values of the Fourier coefficients
a_p_abs = abs(a_p);


%% Q2 - Discrete frequency spectrum for the excitation

% Note that a_0 is plotted to have a consistent definition of c_p but the
% amplitude of the zeroth-order term in the Fourier series is a_0/2. It is
% fine to plot a_0/2 directly.

% all contributions
fig = figure(1); set(fig,'Position',[0 0 1200 900]); hold all; ax = gca; ax.FontSize = 28;
plot([0 1:2:n_harmonics],[a_0 a_p_abs(1:2:n_harmonics)],'ko','MarkerFaceColor','k','MarkerSize',10);
xlabel('$p$','Interpreter','latex'); ylabel('$c_p=|a_p|$ (N)','Interpreter','latex'); 
xticks([0 1:n_harmonics]);
f = gcf; exportgraphics(f,'spectrum_F.pdf','Resolution',300);

% zoom for p >= 3
fig = figure(11); set(fig,'Position',[0 0 1200 900]); hold all; ax = gca; ax.FontSize = 28;
plot(3:2:n_harmonics,a_p_abs(3:2:n_harmonics),'ko','MarkerFaceColor','k','MarkerSize',10);
for i = 1:length(perc)
    plot([3 n_harmonics],[1.0 1.0]*perc(i)*F_0,'k--','LineWidth',1);
end
xlabel('$p$','Interpreter','latex'); ylabel('$c_p=|a_p|$ (N)','Interpreter','latex'); 
axis([3 n_harmonics 0.0 0.05]); xticks(3:2:n_harmonics);
f = gcf; exportgraphics(f,'spectrum_F_zoom.pdf','Resolution',300);


%% Q3 - Number of non-zero terms to be retained

% corresponding minimum number of non-zero harmonics
N = ceil(0.5+1.0./(pi*sqrt(perc)));

% corresponding number of non-zero terms (including the constant term)
n_terms = N+1;

% allocate table of amplitudes
a_p_abs_table = zeros(N(end),3); 

% loop the non-zero terms
for i = 1:N(end)
    
    % number of terms
    a_p_abs_table(i,1) = i+1;
    
    % maximum value of p
    a_p_abs_table(i,2) = 2*i-1;
    
    % amplitude of higher-order harmonic
    a_p_abs_table(i,3) = a_p_abs(2*i-1);
    
end


%% Q4 to Q7 - Representation of the excitation and steady-state response

% The code below is not optimized since Fourier series representation with
% additional terms could use the results from those with fewer terms. This
% is done to favor readibility for this small-scale problem.

% allocate Fourier series representations of F(t) (N)
F = zeros(length(perc),n_t);

% allocate steady-state responses x(t) (m)
x = zeros(length(perc),n_t);

% allocate vector of Fourier coefficients for the steady-state response (m)
x_p = zeros(1,2*N(end));

% open plot for the steady-state responses
fig = figure(3); set(fig,'Position',[0 0 1200 900]); hold all; ax = gca; ax.FontSize = 28;

% loop the convergence levels
for i = 1:length(perc)
    
    % set average value of excitation 
    F(i,:) = a_0/2.0;

    % set average value of the steady-state response (divide by k later)  
    x(i,:) = F(i,:); 
        
    % loop the non-zero harmonics
    for r = 1:N(i)
        
        % compute the frequency of this harmonic
        omega_p = (2*r-1)*omega_0;        
        
        % add contribution to the excitation
        F(i,:) = F(i,:)+a_p(2*r-1)*cos(omega_p*t);        
        
        % compute frequency ratio for this harmonic (-)
        omega_ratio = omega_p/omega_n;
        
        % evaluate frequency response function (multiply by 1/k later)
        H = 1.0/((1.0-omega_ratio^2)+2.0*1j*zeta*omega_ratio);
        
        % evaluate magnitude and phase lag
        H_abs = abs(H); H_phase = atan2(-imag(H),real(H));
        
        % add contribution to the response (divide by k later)
        x(i,:) = x(i,:)+a_p(2*r-1)*H_abs*cos(omega_p*t-H_phase);
        
        % store Fourier coefficients for the steady-state response
        if i == length(perc)
            
            % divide by k later
            x_p(2*r-1) = a_p(2*r-1)*H_abs;
            
        end
        
    end  
    
    % divide response by k
    x(i,:) = x(i,:)/k;  
    
    % plot true excitation and corresponding truncated Fourier series representation (different plots for readibility)   
    fig1 = figure(1000+i); hold all; set(fig1,'Position',[0 0 1200 900]); hold all; ax = gca; ax.FontSize = 28;
    plot(t,F(i,:),'-','LineWidth',2); plot([0.0 T/2.0, T],[0.0 F_0 0.0],'k-','LineWidth',1);
    xlabel('$t$ (s)','Interpreter','latex'); ylabel('$F(t)$ (N)','Interpreter','latex');
    f = gcf; exportgraphics(f,strcat('F_periodic_',num2str(N(i)+1),'_terms.pdf'),'Resolution',300); 
    
    % append steady-state response to plot
    figure(3); plot(t,x(i,:),'-','LineWidth',2);

end

hleg = legend('3 non-zero terms','4 non-zero terms','7 non-zero terms'); 
xlabel('$t$ (s)','Interpreter','latex'); ylabel('$x(t)$ (m)','Interpreter','latex');
f = gcf; exportgraphics(f,'x_periodic.pdf','Resolution',300);

% divide Fourier coefficients by k
x_p = x_p/k;

% amplitudes of Fourier coefficients
x_p_abs = abs(x_p);


%% Q8 - Discrete frequency spectrum for the response

% all contributions
fig = figure(4); set(fig,'Position',[0 0 1200 900]); hold all; ax = gca; ax.FontSize = 28; 
plot([0 1:2:2*N(end)],[a_0/k x_p_abs(1:2:2*N(end))],'ko','MarkerFaceColor','k','MarkerSize',10); 
xlabel('$p$','Interpreter','latex'); ylabel('$x_p=|a_p||H(i\omega)|$ (m)','Interpreter','latex');
xticks([0 1:n_harmonics]);
f = gcf; exportgraphics(f,'spectrum_x.pdf','Resolution',300);

% zoom for p >= 3
fig = figure(5); set(fig,'Position',[0 0 1200 900]); hold all; ax = gca; ax.FontSize = 28; 
plot(3:2:2*N(end),x_p_abs(3:2:2*N(end)),'ko','MarkerFaceColor','k','MarkerSize',10); 
xlabel('$p$','Interpreter','latex'); ylabel('$x_p=|a_p||H(i\omega)|$ (m)','Interpreter','latex'); 
xticks([0 1:n_harmonics]);
f = gcf; exportgraphics(f,'spectrum_x_zoom.pdf','Resolution',300);