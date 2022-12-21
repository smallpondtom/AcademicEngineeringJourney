%pendode.m

function xdot = pendode(t,x)
global W l J c u
xdot(1) = x(2);
xdot(2) = (-W*l*sin(x(1)) -c*x(2) + u)/J;