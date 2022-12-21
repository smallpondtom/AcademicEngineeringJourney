% ISYE7750 HW6 Problem 6
% Author: Tomoki Koike

%% Housekeeping commands
clear; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');
sympref('FloatingPointOutput', false);  % fractions in symbolic

%% (a)
load hw06p6a.mat
[N,~] = size(x);
custpdf = @(x,nu) 1 / pi ./ (1 + (x - nu).^2);  % pdf

LLF = [];
nu_span = 0:0.0001:5;
llf_max = -1000;
nu_hat = 0;
for nu_j = nu_span
  tmp = 0;
  for i = 1:N
    tmp = tmp + log(custpdf(x(i),nu_j));
  end
  LLF = [LLF; tmp];
  % Find nu_mle
  if tmp > llf_max
    llf_max = tmp;
    nu_hat = nu_j;
  end
end

% Plotting the log likelihood function
fig = figure(Renderer="painters");
plot(nu_span,LLF,'-')
grid on; grid minor; box on; 
xlabel("$\nu$")
ylabel("$\ell(\nu | x_n)$")
saveas(fig,"plots/p6a-loglikefunc.png")

% Verification of the MLE
nu_mle = mle(x,"pdf",custpdf,LowerBound=[0],UpperBound=[5],start=[3]);

%% (b)
load hw06p6b.mat
[N,Q] = size(X);
nu0 = 3;

smn = mean(X);  % sample mean
smd = median(X);  % sample median
mle = [];  % MLE for each column


% fig = figure(Renderer="painters");
% plot(0,-150,'.',MarkerSize=0.01);
% hold on; grid on; grid minor; box on;

for q = 1:Q
  xq = X(:,q);
  nu_hat = 0;
  LLF = sum(log(custpdf(xq,nu_span)));
  [~,maxidx] = max(LLF);
  mle = [mle; nu_span(maxidx)];
end
  
% Plot log likelihood function
%   plot(nu_span,LLF,'-')

% hold off;
% xlabel("$\nu$")
% ylabel("$\ell(\nu | x_n)$")

vmn_mse = mean((smn - nu0).^2)
vmd_mse = mean((smd - nu0).^2)
vmle_mse = mean((mle - nu0).^2)

fig = figure();
plot(smn); hold on; 
yline(nu0,Color='red'); hold off;
ylabel("mean")
saveas(fig,"plots/p6b-sample_mean.png")

fig = figure();
plot(smd); hold on; 
yline(nu0,Color='red'); hold off;
ylabel("median")
saveas(fig,"plots/p6b-sample_median.png")

fig = figure();
plot(mle); hold on; 
yline(nu0,Color='red'); hold off;
ylabel("mle")
saveas(fig,"plots/p6b-sample_mle.png")

%% (c)
nu_span = linspace(0,5,250);
tmp = @(x,v) log(custpdf(x,v)) .* custpdf(x,nu0);
e = @(v) integral(@(x) tmp(x,v),-inf,inf);

Es = [];
for vi = nu_span
  Es = [Es; e(vi)];
end

fig = figure();
plot(nu_span,Es,'.',MarkerSize=8)
xlabel("$\nu$")
ylabel("$E[\ell(\nu | X)]$")
grid on; grid minor; box on;
saveas(fig,"plots/p6c-ellf.png")

%% (c)
fig = figure();
plot(0,-3.6,'.',MarkerSize=0.01)
hold on; grid on; grid minor; box on;
for q = 1:10
  xq = X(:,q);
  nu_hat = 0;
  nLLF = sum(log(custpdf(xq,nu_span)))/N;
  plot(nu_span,nLLF)

end
plot(nu_span,Es,'--',Color='red',LineWidth=1.5)
hold off;
xlabel("$\nu$")
ylabel("$\frac{1}{N}\sum_{n=1}^N \ell(\nu | x_n)$")
saveas(fig,"plots/p6c-nllf.png")