% AE6230 Final Problem 2
% Author: Tomoki Koike
% Credit: Dr. Cristina Riso MATLAB code "AE6230_HW4_2022_P1.m"

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic
clear ans;

%% Setup
params.rhoA = 0.5;  % [kg/m]
params.l = 1;  % [m]
params.EI = 5;  % [N-m^2]

%% (1)
syms x real
syms A_1 A_2 B_1 B_2 real 
syms alpha_i l real positive 

X(x) = A_1*sin(alpha_i*x) + B_1*cos(alpha_i*x) + A_2*sinh(alpha_i*x) + B_2*cosh(alpha_i*x);
dX(x) = diff(X,x);
d2X(x) = diff(dX,x);
d3X(x) = diff(d2X,x);

bc1 = d3X(0) == 0;
bc2 = dX(0) == 0;
bc3 = d2X(l) == 0;
bc4 = d3X(l) == 0;

coeffs = [A_1 B_1 A_2 B_2].';
bcs = [bc1; bc2; bc3; bc4];
[H,~] = equationsToMatrix(bcs,coeffs);
det(H);

tmp = subs(H*coeffs,[A_1 A_2 B_1],[0 0 1])==0;
Hs = solve(tmp(3),B_2);
solve(tmp(4),B_2);
Hsf = matlabFunction(Hs);
Xf = matlabFunction(X);

clear x A_1 A_2 B_1 B_2 alpha_i l;
clear bc1 bc2 bc3 bc4 bcs X dX d2X d3X coeffs H Hs tmp;

%% (2)
% color-blind-friendly colors
c1 = [0.0000, 0.4470, 0.7410];
c2 = [0.8500, 0.3250, 0.0980];

% define the alpha*l range
alphal = 0:0.00001:15;

% evaluate the two sides of the characteristic equation
side1 = -tanh(alphal); side2 = tan(alphal);

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
plot(alphal,side1,'LineWidth',2,DisplayName="$-\tanh(\alpha l)$"); 
plot(alphal(1:asymptotes(1)),side2(1:asymptotes(1)),'-', ...
  'LineWidth',2,'Color',c2,DisplayName="$\tan(\alpha l)$");
for i = 2:length(asymptotes)
    plot(alphal(asymptotes(i-1)+1:asymptotes(i)),side2(asymptotes(i-1)+1:asymptotes(i)), ...
      '-','LineWidth',2,'Color',c2,HandleVisibility='off');
end
plot(alphal(asymptotes(end)+1:end),side2(asymptotes(end)+1:end),'-', ...
  'LineWidth',2,'Color',c2,HandleVisibility='off');
ax = gca; ax.FontSize = 28; axis([alphal(1) alphal(end) -5 5]); yticks(-5.0:2.5:5.0);


% define characteristic equation 
char_eq = @(x) tanh(x)+tan(x);

% define first guesses
x_0 = [2.37 5.51 8.63 11.79];

% the first guesses are found by inspection considering that
% tanh(alpha*l) quickly approaches 1 before the first point
% where it intersects with tan(alpha*l) excluding alpha = 0

% it turns out that the first guesses determined with this 
% consideration are practically the same as the roots

% allocate vector to store the eigenvalues
alpha_i = zeros(1,length(x_0));

% loop the first guesses
for i = 1:length(x_0)
    
    % solve the characteristic equation for each first guess
    alpha_i(i) = fzero(char_eq,x_0(i))/params.l;
    
    % plot root for verification
    plot(alpha_i(i)*params.l,-tanh(alpha_i(i)*params.l),'ko','MarkerSize',8, ...
      'MarkerFaceColor','k',HandleVisibility='off');
    
end

% add legend
grid on; grid minor; box on; legend(Location="northwest"); hold off; 
xlabel('$\alpha l$ (-)'); 
ylabel('$-\tanh \alpha l, \tan \alpha l$ (-)');
saveas(fig,"plots/p2/charEqn_visual.png");

% comparison table between roots and first guesses
alpha_check = [alpha_i' x_0' ((alpha_i'-x_0')./x_0')*100];

%% (3)
omega_i = alpha_i.^2 * sqrt(params.EI / params.rhoA);

x = linspace(0.0,params.l,201);  % space discretization 
phis = cell(length(alpha_i),1);  % preallocate mode shapes
Xis = cell(length(alpha_i),1);

fig = figure(Renderer="painters"); hold all; 
grid on; grid minor; box on;
for i = 1:length(alpha_i)   
  B1i = 1.0;
  B2i = Hsf(alpha_i(i), params.l);
  A1i = 0; A2i = 0;

  Xi = Xf(x,A1i,A2i,B1i,B2i,alpha_i(i));  % eigenfunction
  Xis{i} = Xi;
  
  % compute and store the ith mode shape
  phis{i} = Xi/max(abs(Xi));
     
  % plot ith mode shape
  plot(x,phis{i},'-','LineWidth',2,DisplayName="$\phi_"+num2str(i)+"(x)$");
end
xlabel("$x$ [m]")
ylabel("$\phi(x)$ [m]")
set ( gca, 'xdir', 'reverse' )
legend(Location="southeast")
saveas(fig,"plots/p2/mode-shapes.png");