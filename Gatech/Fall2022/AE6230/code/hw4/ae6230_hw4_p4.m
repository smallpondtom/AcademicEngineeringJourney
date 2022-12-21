% AE6230 HW4 Problem 4
% Author: Tomoki Koike
% Reference: Dr. Cristina Riso AE6230_Fall2022_L22_Continuous_Bending.m

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
params.EI = 50;  % [N-m^2]
params.F0 = 1;  % [N]
params.x0 = params.l/2;  % [m]

%% (1)
syms x tau real
syms A_1 A_2 B_1 B_2 real 
syms alpha l omega_i real positive 

X(x) = A_1*sin(alpha*x) + B_1*cos(alpha*x) + A_2*sinh(alpha*x) + B_2*cosh(alpha*x);
dX(x) = diff(X,x);
d2X(x) = diff(dX,x);

bc1 = X(0) == 0;
bc2 = d2X(0) == 0;
bc3 = X(l) == 0;
bc4 = d2X(l) == 0;

coeffs = [A_1 B_1 A_2 B_2].';
bcs = [bc1; bc2; bc3; bc4];
[H,~] = equationsToMatrix(bcs,coeffs);
detH = det(H);

clear x A_1 A_2 B_1 B_2 alpha l;
clear bc1 bc2 bc3 bc4 bcs X dX d2X coeffs H;

%% (3)
N = 8;
alphai = @(i) i*pi/params.l;
omegai = @(i) alphai(i).^2 * sqrt(params.EI / params.rhoA);
N0i = @(i) params.F0 * sin(i*pi*params.x0 / params.l);

vtable = zeros(N,3);
for i = 1:N
  vtable(i,1) = alphai(i);
  vtable(i,2) = omegai(i);
  vtable(i,3) = N0i(i);
end

%% (4)
x = transpose(0:0.001:params.l);
x0_idx = find(x==params.x0);
t = 0:0.0001:0.1;
vvals = cell(N);

etai = @(i) N0i(i) .* sin(omegai(i) .* t);
phii = @(i) sin(alphai(i) * x);
vi = @(i) phii(i) .* etai(i);

data = zeros(length(x),length(t));
for i = 1:N
  data = data + vi(i);
  vvals{i} = data;
end

fig = figure(Renderer="painters",Position=[0 0 700 1000]); 
tile = tiledlayout(8,1,"TileSpacing","compact",Padding="tight");
for i = 1:N
  nexttile(i);
  plot(t,vvals{i}(x0_idx,:),DisplayName="$N="+num2str(i)+"$")
  grid on; grid minor; box on;
  legend; 
  ylim([-4,4])
end
xlabel(tile,'$t$',"Interpreter","latex")
ylabel(tile,'$v(x_0,t)$',"Interpreter","latex")
saveas(fig,"plots/p4/midpoint_bend.png");

%%
plot3DResults(x,t,vvals{1},"plots/p4/3d_n1.png",true);
plot3DResults(x,t,vvals{2},"plots/p4/3d_n2.png",true);
plot3DResults(x,t,vvals{3},"plots/p4/3d_n3.png",true);
plot3DResults(x,t,vvals{4},"plots/p4/3d_n4.png",true);
plot3DResults(x,t,vvals{5},"plots/p4/3d_n5.png",true);
plot3DResults(x,t,vvals{6},"plots/p4/3d_n6.png",true);
plot3DResults(x,t,vvals{7},"plots/p4/3d_n7.png",true);
plot3DResults(x,t,vvals{8},"plots/p4/3d_n8.png",true);

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
  zlabel("$v$")
  
  nexttile(4);
  s = surf(t,x,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  view([0, 0])
  xlabel("$t$")
  ylabel("$x$")
  zlabel("$v$")
  
  nexttile(2,[2 2]);
  s = surf(t,x,res,'FaceAlpha',0.8,'FaceColor','interp');
  s.EdgeColor = 'none';
  colorbar;
  view([-232.537498368885 35.2904898629964]);
  xlabel("$t$")
  ylabel("$x$")
  zlabel("$v$")
  if save
    saveas(fig,filename);
  end
end

