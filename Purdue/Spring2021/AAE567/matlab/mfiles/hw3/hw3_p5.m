%% AAE 567 HW3 Problem5

% Housekeeping commands
clear all; close all; clc;
set(groot, 'defaulttextinterpreter','latex');
set(groot, 'defaultAxesTickLabelInterpreter','latex');
set(groot, 'defaultLegendInterpreter','latex');

% Define given vector
t = linspace(0, pi, 10000)
y = sin(t);

% Define the Vandermonde matrix
V = fliplr(vander(t));
V = V(:, 1:6);
%%
ahat = pinv(V)*y';
error2 = norm(y)^2 - dot(ahat, V'*y');
error = sqrt(error2);
%%
% Plotting
fig = figure("Renderer","painters", "Position",[60 60 900 650]);
    plot(t, y, '.', "MarkerSize", 3)
    hold on; grid on; box on; grid minor;
    plot(t, polyval(flip(ahat)', t), '--', 'LineWidth',2.5)
    title("Problem 5 Polynomial Optimization Problem of $\sin (t)$ - T. Koike")
    xlabel('t(k)')
    ylabel('y')
    legend('$sin(t)$', 'poly')
saveas(fig,"hw3_p5_sinDiscretePolyOpt.png")