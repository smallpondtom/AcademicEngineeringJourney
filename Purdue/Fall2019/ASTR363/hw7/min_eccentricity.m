function [x,fval,exitflag,output,lambda,grad,hessian] = min_eccentricity(x0,lb,ub)
%% This is an auto generated MATLAB file from Optimization Tool.

%% Start with the default options
options = optimoptions('fmincon');
%% Modify options setting
options = optimoptions(options,'Display', 'off');
[x,fval,exitflag,output,lambda,grad,hessian] = ...
fmincon(@objective,x0,[],[],[],[],lb,ub,@constraint,options);
