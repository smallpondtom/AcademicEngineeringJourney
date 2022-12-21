% ISYE 7750 HW7 Problem 1
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic
clear ans;

%% 
Na = 5;
Nb = 32; 
Nc = 15;
N = Na + Nb + Nc;
C = gamma(N+3) / gamma(Na+1) / gamma(Nb+1) / gamma(Nc+1);

ta = transpose(0:0.001:0.999);
tb = 0:0.001:0.999;
N = length(ta);
post = zeros(N);
for i = 1:N
  TA = ta(i);
  for j = 1:N
    TB = tb(j);
    if TA + TB > 1
      post(i,j) = nan;
    else
      post(i,j) = C * TA.^Na .* TB.^Nb .* (1 - TA - TB).^Nc;
    end
  end
end

plotDensity(ta,tb,post,"plots/p1-posterior.png",true);

%% Functions
function plotDensity(ta,tb,res,filename,save)
  fig = figure(Renderer="opengl",Position=[0 0 1800 1000]);
  tiledlayout(2,3,"TileSpacing","compact",Padding="tight");
  nexttile(1);
  s = surf(ta,tb,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  view([90, 0])
  xlabel("$\theta_a$")
  ylabel("$\theta_b$")
  zlabel("$f_\Theta(\theta | X)$")
  
  nexttile(4);
  s = surf(ta,tb,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  view([0, 0])
  xlabel("$\theta_a$")
  ylabel("$\theta_b$")
  zlabel("$f_\Theta(\theta | X)$")
  
  nexttile(2,[2 2]);
  s = surf(ta,tb,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  colorbar;
%   view([-232.537498368885 35.2904898629964]);
  xlabel("$\theta_a$")
  ylabel("$\theta_b$")
  zlabel("$f_\Theta(\theta | X)$")
  if save
    saveas(fig,filename);
  end
end