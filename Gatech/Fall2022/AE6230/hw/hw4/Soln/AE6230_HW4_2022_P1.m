%% This script solves HW4 Problem 1

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

% beam out-of-plane bending stifness (N*m2)
EI = 5.0;

% beam mass per unit length (kg*m)
rhoA = 0.5;


%% Graphical inspection of the characteristic equation

% define the alpha*l range
alphal = 0:0.00001:15;

% evaluate the two sides of the characteristic equation
side1 = tanh(alphal); side2 = tan(alphal);

% the piece of code above looks for the approximate locations of the
% asymptotes of tan(alpha*l) to avoid plotting vertical lines

% find asymptotes for nicer plotting 
asymptotes = zeros(1,1000); k = 1;
for i = 1:length(alphal)-1
    if (side2(i) > side2(i+1))
        asymptotes(k) = i;
        k = k+1;
    end
end
asymptotes(k:end) = [];

% visualize the characteristic equation
fig = figure(100); hold all; set(fig,'Position',[0 0 1200 900]); 
plot(alphal,side1,'LineWidth',2); 
plot(alphal(1:asymptotes(1)),side2(1:asymptotes(1)),'-','LineWidth',2,'Color',c2);
for i = 2:length(asymptotes)
    plot(alphal(asymptotes(i-1)+1:asymptotes(i)),side2(asymptotes(i-1)+1:asymptotes(i)),'-','LineWidth',2,'Color',c2);
end
plot(alphal(asymptotes(end)+1:end),side2(asymptotes(end)+1:end),'-','LineWidth',2,'Color',c2);
ax = gca; ax.FontSize = 28; axis([alphal(1) alphal(end) -5 5]); yticks(-5.0:2.5:5.0);


%% Q2 - First four eigenvalues

% define characteristic equation 
char_eq = @(x) tanh(x)-tan(x);

% define first guesses
x_0 = [5.0, 9.0, 13.0, 17.0]*pi/4.0;

% the first guesses are found by inspection considering that
% tanh(alpha*l) quickly approaches 1 before the first point
% where it intersects with tan(alpha*l) excluding alpha = 0

% it turns out that the first guesses determined with this 
% consideration are practically the same as the roots

% allocate vector to store the eigenvalues
alpha = zeros(1,length(x_0));

% loop the first guesses
for i = 1:length(x_0)
    
    % solve the characteristic equation for each first guess
    alpha(i) = fzero(char_eq,x_0(i))/l;
    
    % plot root for verification
    plot(alpha(i)*l,tanh(alpha(i)*l),'ko','MarkerSize',8,'MarkerFaceColor','k');
    
end

% add legend
hleg = legend('$\tanh \alpha l$','$\tan \alpha l$','Interpreter','latex'); set(hleg,'Location','NorthWest');
xlabel('$\alpha l$ (-)','Interpreter','latex'); ylabel('$\tanh \alpha l, \tan \alpha l$ (-)','Interpreter','latex');
f = gcf; exportgraphics(f,'characteristic_eq.pdf','Resolution',300);

% comparison table between roots and first guesses
alpha_check = [alpha' x_0' ((alpha'-x_0')./x_0')*100];


%% Q3 - First three non-zero frequencies

% natural frequencies (rad/s)
omega = alpha.^2*sqrt(EI/rhoA);

% natural frequencies (Hz)
freq = omega/(2.0*pi);


%% Q4 and Q5 - Eigenfunctions and mode shapes with plots

% space discretization (m)
x = linspace(0.0,l,201);

% allocate matrix of mode shapes
phi = zeros(length(x),length(alpha));

% open plot
fig = figure(200); hold all; set(fig,'Position',[0 0 1200 900]); 

% loop the eigenvalues
for i = 1:length(alpha)
    
    % compute the ith eigenfunction
    X_i = sin(alpha(i)*x)+sinh(alpha(i)*x)*(sin(alpha(i)*l)/sinh(alpha(i)*l));
    
    % compute and store the ith mode shape
    phi(:,i) = X_i/max(abs(X_i));
    
    % plot ith mode shape
    plot(x,phi(:,i),'-','LineWidth',2);
    
end

ax = gca; ax.FontSize = 28; axis([x(1) x(end) -1 1]); yticks(-1.0:0.5:1.0);
hleg = legend('$\phi_1(x)$','$\phi_2(x)$','$\phi_3(x)$','$\phi_4(x)$','Interpreter','latex'); set(hleg,'Location','SouthWest');
xlabel('$x$ (m)','Interpreter','latex'); ylabel('$\phi(x)$ (m)','Interpreter','latex');
f = gcf; exportgraphics(f,'mode_shapes.pdf','Resolution',300);