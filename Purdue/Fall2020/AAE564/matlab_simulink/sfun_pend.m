
% sfun_pend.m
 
% S-function to describe the dynamics of the simple pendulum
% Input is a torque and output is pendulum angle
 
function [sys,x0,str,ts] = sfun_pend(t,x,u,flag)

% t is time
% x is state
% u is inout
% flag is a calling argument used by Simulink.
% The value of flag determines what Simulink wants to be executed.

switch flag

case 0			% Initialization
   [sys,x0,str,ts]=mdlInitializeSizes;
   
case 1			% Compute xdot
   sys=mdlDerivatives(t,x,u);
   
case 2		   % Not needed for continuous-time systems
   
case 3			% Compute output 
   sys = mdlOutputs(t,x,u);
   
case 4			% Not needed for continuous-time systems
   
case 9			% Not needed here

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlInitializeSizes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function [sys,x0,str,ts]=mdlInitializeSizes
%
% Create the sizes structure
sizes=simsizes;
sizes.NumContStates = 2;		%Set number of continuous-time state variables
sizes.NumDiscStates = 0;
sizes.NumOutputs = 1;			%Set number of outputs
sizes.NumInputs = 1;				%Set number of intputs
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;		%Need at least one sample time
sys = simsizes(sizes); 
%
x0=[0;0];							% Set initial state
str=[];					 			% str is always an empty matrix
ts=[0 0];					      % ts must be a matrix of at least one row and two columns
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlDerivatives
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function sys = mdlDerivatives(t,x,u)
%
% Compute xdot based on (t,x,u) and set it equal to sys
%
sys(1) = x(2);
sys(2) = (-2*sin(x(1))-0.4*x(2) + u)/2;
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlOutput
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function sys = mdlOutputs(t,x,u)
%
% Compute output  based on (t,x,u) and set it equal to sys
sys = x(1);

