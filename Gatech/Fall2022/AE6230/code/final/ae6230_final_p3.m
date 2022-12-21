% AE6230 Final Problem 3
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic
clear ans;

%% Setup
params.rhoA = 0.25;  % [kg/m]
params.l = 1;  % [m]
params.EA = 20;  % [N-m^-2]
params.F0 = 5;  % [N]
params.x0 = params.l;  % [m]


%% Parameters
N = 4;
zetai = 0.02;
alphai = @(i) i*pi/params.l;
omegai = @(i) alphai(i) * sqrt(params.EA / params.rhoA);
omegadi = @(i) omegai(i) * sqrt(1 - zetai^2);
mi = params.rhoA*params.l / 2;

%% (4)
x = transpose(0:0.001:params.l);
x0_idx = find(x==params.x0);
t = 0:0.0001:0.5;
uvals = cell(N);

hi = @(i) exp(-zetai*omegai(i)*t) .* sin(omegadi(i)*t) / omegadi(i);
etai = @(i) params.F0/mi/omegai(i) * hi(i);
phii = @(i) cos(alphai(i) * x);
ui = @(i) phii(i) .* etai(i);

data = zeros(length(x),length(t));
for i = 1:N
  data = data + ui(i);
  uvals{i} = data;
end

fig = figure(Renderer="painters",Position=[0 0 700 800]); 
tile = tiledlayout(N,1,"TileSpacing","compact",Padding="compact");
for i = 1:N
  nexttile(i);
  plot(t,uvals{i}(x0_idx,:),DisplayName="$N="+num2str(i)+"$")
  grid on; grid minor; box on;
  legend; 
  ylim([-0.06,0.06])
end
xlabel(tile,'$t$',"Interpreter","latex")
ylabel(tile,'$u(l,t)$',"Interpreter","latex")
exportgraphics(fig,"plots/p3/right_end_axial_motion.pdf",Resolution=300);

%%
plot3DResults(x,t,uvals{1},"plots/p3/3d_n1.pdf",true);
plot3DResults(x,t,uvals{2},"plots/p3/3d_n2.pdf",true);
plot3DResults(x,t,uvals{3},"plots/p3/3d_n3.pdf",true);
plot3DResults(x,t,uvals{4},"plots/p3/3d_n4.pdf",true);

%% Functions
function plot3DResults(x,t,res,filename,save)
  fig = figure(Renderer="opengl",Position=[0 0 1800 1000]);
  tiledlayout(2,3,"TileSpacing","compact",Padding="tight");
  nexttile(1);
  s = surf(t,x,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  view([90, 0])
  xlabel("$t$")
  ylabel("$x$")
  zlabel("$u$")
  
  nexttile(4);
  s = surf(t,x,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  view([0, 0])
  xlabel("$t$")
  ylabel("$x$")
  zlabel("$u$")
  
  nexttile(2,[2 2]);
  s = surf(t,x,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  colorbar;
  view([-232.537498368885 35.2904898629964]);
  xlabel("$t$")
  ylabel("$x$")
  zlabel("$u$")
  if save
    exportgraphics(fig,filename,Resolution=300);
  end
end

