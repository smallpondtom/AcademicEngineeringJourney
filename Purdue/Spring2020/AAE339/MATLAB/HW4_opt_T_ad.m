function [x,fval,exitflag,output,lambda,grad,hessian] = opt_T_ad(x0,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fmincon');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
options = optimoptions(options,'PlotFcn', {  @optimplotfunccount @optimplotfval });
options = optimoptions(options,'HessianApproximation', 'bfgs');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@p2_objective,x0,[],[],[],[],lb,ub,[],options);
