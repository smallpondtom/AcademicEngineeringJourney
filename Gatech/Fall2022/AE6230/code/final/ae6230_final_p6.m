% AE6230 Final Problem 6
% Author: Tomoki Koike

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
plot_nat_freq = false;

zetas = [0.001 0.001; 1000 0.001; 0.001 1000; 1000 1000; 0.5 5];
[M,~] = size(zetas);
results = cell(M,1);

for j = 1:M
  params.zeta_m = zetas(j,1);
  params.zeta_k = zetas(j,2);

  %% (1)
  syms x real
  syms A_1 A_2 B_1 B_2 real 
  syms alpha_i l real positive 
  syms m k omega_i EI real positive
  syms zeta_k zeta_m rhoA real positive
  
  X(x) = (A_1*sin(alpha_i*x) + B_1*cos(alpha_i*x) + A_2*sinh(alpha_i*x) ...
    + B_2*cosh(alpha_i*x));
  dX(x) = diff(X,x);
  d2X(x) = diff(dX,x);
  d3X(x) = diff(d2X,x);
  
  bc1 = X(0) == 0;
  bc2 = EI*d2X(0) + k*dX(0) == 0;
  bc3 = d2X(l) == 0;
  bc4 = EI*d3X(l) + m*omega_i^2*X(l) == 0;
  
  coeffs = [A_1 B_1 A_2 B_2].';
  bcs = [bc1; bc2; bc3; bc4];
  [H,~] = equationsToMatrix(bcs,coeffs);
  
  % Estimating the eigenvalues of the system
  detH = det(H);
  detH = subs(detH,[m k omega_i^2], ...
    [zeta_m*rhoA*l, zeta_k*EI/l, alpha_i^4*EI/rhoA]);
  detH = simplify(detH) * -l/2/EI^2/alpha_i^6;
  tmp = subs(detH,[zeta_m zeta_k l],[params.zeta_m params.zeta_k params.l]);
  tt = taylor(tmp,alpha_i,'order',50);  % Taylor series expansion approx
  vpa(tt,5);
  soln = double(vpasolve(tt,alpha_i));  % solve numerically
  soln_real = soln(imag(soln)==0);  % remove complex numbers
  soln_real_pos = soln_real(soln_real > 0);  % retain only the positive values
  
  % Solved eigenvalues and natural frequencies 
  alpha = soln_real_pos;  % eigenvlaues
  omega = alpha.^2 * sqrt(params.EI/params.rhoA);  % natural frequencies
  
  % Reference natural frequencies of the clamped-free and free-free cases
  omega_cf = [11.1186165363890	69.6791804281143	195.103722834585 ...
    382.325428203759	632.011327260117	944.115485898962	1318.64064724286];
  omega_ff = [70.7505407569746	195.026589994746	382.330094697270	...
    632.011067986229	944.115499593033	1318.64064654349	1755.58666008231];
  
  % Plotting the natural frequencies of the system and comparing
  % clamped-free and free-free cases
  if plot_nat_freq
    fig = figure(Renderer="painters");
    plot(omega,'.',MarkerSize=12,DisplayName="non-standard")
    hold on; grid on; grid minor; box on;
    plot(omega_cf,'*',MarkerSize=12,DisplayName="clamped-free")
    plot(omega_ff,'+',MarkerSize=12,DisplayName="free-free")
    hold off; legend(Location="northwest");
    xlabel('$i$','FontSize',14)
    ylabel('$\omega_i$',FontSize=14)
    exportgraphics(fig,"plots/p6/nat_freq.pdf",Resolution=300);
  end
  
  %%
  N = length(alpha);
  As = cell(N,1);
  H = subs(H,[m k omega_i^2],[zeta_m*rhoA*l, zeta_k*EI/l, alpha_i^4*EI/rhoA]);
  H = subs(H,[l EI rhoA zeta_m zeta_k], ...
    [params.l params.EI params.rhoA params.zeta_m params.zeta_k]);
  
  for i = 1:N
    tmp = subs(H,alpha_i,alpha(i))*coeffs == 0;
    tmp = subs(tmp,[B_1 B_2],[1 -1]);
    ans1 = vpasolve(tmp([2 3]),[A_1 A_2]); 
    ans2 = vpasolve(tmp([2 4]),[A_1 A_2]);
    ans3 = vpasolve(tmp([3 4]),[A_1 A_2]);
    As{i} = double(mean([ans1.A_1 ans1.A_2; ans2.A_1 ans2.A_2; ans3.A_1 ans3.A_2]));
  end
  
  Xf = matlabFunction(X);
  
  clear x A_1 A_2 B_1 B_2 alpha_i l;
  clear bc1 bc2 bc3 bc4 bcs X dX d2X d3X coeffs H tmp;
  clear zeta_k zeta_m rho A EI omega_i;
  
  %% (3)
  x = linspace(0.0,params.l,201);  % space discretization 
  phis = cell(N,1);  % preallocate mode shapes
  Xis = cell(N,1);
 
  coeffs = []; 
  for i = 1:N  
    B1i = 1.0;
    B2i = -1.0;
    A1i = As{i}(1); 
    A2i = As{i}(2);
    coeffs = [coeffs; A1i B1i A2i B2i];
  
    Xi = Xf(x,A1i,A2i,B1i,B2i,alpha(i));  % eigenfunction
    Xis{i} = Xi;
    
    % compute and store the ith mode shape
    phis{i} = Xi/max(abs(Xi));
  end
  
  s.coeffs = coeffs;
  s.X = Xis;
  s.phi = phis;
  s.zeta = [params.zeta_m params.zeta_k];
  s.alpha = alpha;
  s.omega = omega;
  s.x = x;
  results{j} = s;
  
  clearvars -except params zetas results plot_nat_freq M N;
  fprintf("iter: %d",j);
end

%% Plotting
cases = ['A' 'B' 'C' 'D' 'E'];
for i = 1:4
  fig = figure(Renderer="painters",Position=[0 0 900 500]); hold all; 
  grid on; grid minor; box on;    
  for j = 1:length(cases)
    plot(results{j}.x,results{j}.phi{i},'-', ...
      'LineWidth',2,DisplayName=cases(j));
  end
  hold off; legend(Location="southwest");
  xlabel('$x$ [m]','FontSize',14)
  ylabel("$\phi_"+num2str(i)+"(x)$ [m]",FontSize=14)
  exportgraphics(fig,"plots/p6/modeshapes"+num2str(i)+".pdf",Resolution=300);
end
