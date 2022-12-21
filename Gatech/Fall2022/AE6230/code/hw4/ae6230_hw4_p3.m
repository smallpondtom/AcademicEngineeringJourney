% AE6230 HW4 Problem 3
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% Setup 
params.l = 1;
params.GJ = 5.0;  % [N-m^2]
params.rhoIp = 0.005;   % [kg-m]
params.zeta_i = 0.02;  % damping factor 
params.r0 = 1;  % [N]
params.omega0 = 125;  % [rad/s]
PI = pi;

%% (1)
% Distributed moment (symbolic)
syms x r_0 l pi i real positive
phi_i = sin((2*i-1)*pi.*x / 2 / l);
N0i = r_0 * int(phi_i,x,0,l);
N0i = subs(N0i,[r_0 l pi],[params.r0 params.l PI]);
N0i = matlabFunction(N0i);
clear PI pi;

%% (3)
N = 4;
alphai = @(i) (2*i-1)*pi / 2 / params.l;
omegai = @(i) alphai(i) * sqrt(params.GJ / params.rhoIp);
Hi = @(i) ( 1 ./ sqrt((omegai(i).^2 - params.omega0^2).^2 ...
              + 4*params.zeta_i^2*params.omega0^2) );
psii = @(i) atan2(2*params.zeta_i*params.omega0, omegai(i).^2-params.omega0^2);
% Ni = @(i,t) N0i(i) .* sin(params.omega0 * t);

vtable = zeros(N,5);
for i = 1:N
  vtable(i,1) = alphai(i);
  vtable(i,2) = omegai(i);
  vtable(i,3) = N0i(i);
  vtable(i,4) = Hi(i);
  vtable(i,5) = psii(i);
end

%% (4)
xgrid = transpose(0:0.001:params.l);
t = 0:0.0001:0.2;
thetavals = cell(N);
thetai = @(i) N0i(i)*Hi(i)*sin(alphai(i)*xgrid).*sin(params.omega0*t - psii(i));

data = zeros(length(xgrid),length(t));
for i = 1:N
  data = data + thetai(i);
  thetavals{i} = data;
end

fig = figure(Renderer="painters");
plot(t,thetavals{1}(end,:),DisplayName="$N=1$")
hold on; grid on; grid minor; box on;
plot(t,thetavals{2}(end,:),DisplayName="$N=2$")
plot(t,thetavals{3}(end,:),DisplayName="$N=3$")
plot(t,thetavals{4}(end,:),DisplayName="$N=4$")
hold off; legend;
xlabel("$t$")
ylabel("$\theta(l,t)$")
saveas(fig,"plots/p3/tip_twist.png");

%%
plot3DResults(xgrid,t,thetavals{1},"plots/p3/3d_n1.png",true);
plot3DResults(xgrid,t,thetavals{2},"plots/p3/3d_n2.png",true);
plot3DResults(xgrid,t,thetavals{3},"plots/p3/3d_n3.png",true);
plot3DResults(xgrid,t,thetavals{4},"plots/p3/3d_n4.png",true);

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
  zlabel("$\theta$")
  
  nexttile(4);
  s = surf(t,x,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  view([0, 0])
  xlabel("$t$")
  ylabel("$x$")
  zlabel("$\theta$")
  
  nexttile(2,[2 2]);
  s = surf(t,x,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  colorbar;
  view([-232.537498368885 35.2904898629964]);
  xlabel("$t$")
  ylabel("$x$")
  zlabel("$\theta$")
  if save
    saveas(fig,filename);
  end
end