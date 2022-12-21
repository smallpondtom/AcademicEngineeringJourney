% AE6230 Final Problem 4
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic
clear ans;

%% Setup
params.rhoIp = 0.005;  % [kg-m]
params.l = 1;  % [m]
params.GJ = 5.0;  % [N-m^2]
params.M0 = 5;  % [N-m]
params.x0 = params.l * 2 / 3;  % [m]
T1 = 0.2;
T2 = 0.12;

%% Parameters
N = 5;
zetai = 0.02;
alphai = @(i) (2*i-1)*pi/2/params.l;
omegai = @(i) alphai(i) * sqrt(params.GJ / params.rhoIp);
omegadi = @(i) omegai(i) * sqrt(1 - zetai^2);
mi = params.rhoIp*params.l / 2;

%% (4)
x = transpose(0:0.001:params.l);
obs_idx = find(x==round(params.x0,3));
t = 0:0.0001:0.5;
thetavals = cell(N);

hi = @(i) exp(-zetai*omegai(i)*t) .* sin(omegadi(i)*t) / omegadi(i);
phii = @(i) sin(alphai(i) * x);
phiix0 = @(i) sin(alphai(i) * params.x0);
N0i = @(i) params.M0 * phiix0(i);

Hi = @(i,T) ( 1 - exp(-zetai * omegai(i) * (t-T)).*( cos(omegadi(i)*(t-T)) + ...
  zetai * omegai(i) / omegadi(i) .* sin(omegadi(i)*(t-T)) ) );

etai = @(i) ( N0i(i)/mi/omegai(i)^2 * ( Hi(i,0).*ustep(t,0) ...
  - 3/2*Hi(i,T1).*ustep(t,T1) + Hi(i,T1+T2).*ustep(t,T1+T2)/2 ) );
thetai = @(i) phii(i) .* etai(i);

data = zeros(length(x),length(t));
for i = 1:N
  data = data + thetai(i);
  thetavals{i} = data;
end

fig = figure(Renderer="painters",Position=[0 0 700 800]); 
tile = tiledlayout(N,1,"TileSpacing","compact",Padding="compact");
for i = 1:N
  ax = nexttile(i);
  plot(t,thetavals{i}(obs_idx,:),DisplayName="$N="+num2str(i)+"$")
  ax.FontSize = 10;
  if i ~= N
    xticklabels(ax,{});
  end
  grid on; grid minor; box on;
  legend; 
end
xlabel(tile,'$t$',FontSize=15,Interpreter="latex")
ylabel(tile,'$u(l,t)$',FontSize=15,Interpreter="latex")
exportgraphics(fig,"plots/p4/torsion.pdf",Resolution=300);

%%
plot3DResults(x,t,thetavals{1},"plots/p4/3d_n1.pdf",true);
plot3DResults(x,t,thetavals{2},"plots/p4/3d_n2.pdf",true);
plot3DResults(x,t,thetavals{3},"plots/p4/3d_n3.pdf",true);
plot3DResults(x,t,thetavals{4},"plots/p4/3d_n4.pdf",true);
plot3DResults(x,t,thetavals{4},"plots/p4/3d_n5.pdf",true);

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

function val = ustep(t,a)
  val = 1 .* (t >= a);
end