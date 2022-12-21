
% sfun_double_pend.m									            %CHANGE
 
% S-function to describe the dynamics of  a
% Double pendulum on cart									%CHANGE

 
 function [sys,x0,str,ts] = sfun_pend3(t,x,u,flag)			%CHANGE
 
% t is time
% x is state
% u is input
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
sizes.NumContStates = 2;	%Set number of continuous-time state variables %CHANGE
sizes.NumDiscStates = 0;
sizes.NumOutputs = 2;	     %Set number of outputs						   %CHANGE
sizes.NumInputs = 0;		   %Set number of inputs					   %CHANGE

sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;		%Need at least one sample time
sys = simsizes(sizes); 
%
x0=[1;0];						% Set initial state						   %CHANGE

str=[];					 		% str is always an empty matrix
ts=[0 0];			 % ts must be a matrix of at least one row and two columns
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
sys= pendode(t,x);														   %CHANGE
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlOutput
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function sys = mdlOutputs(t,x,u)
%
% Compute y based on (t,x,u) and set it equal to sys

sys = x;														                  %CHANGE

