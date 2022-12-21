
% sfun_double_pend_cart.m									          
 
% S-function to describe the dynamics of  a
% Double pendulum on cart									

 
 function [sys,x0,str,ts] = sfun_double_pend_cart(t,x,u,flag)			
 
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
sizes.NumContStates = 6;	%Set number of continuous-time state variables 
sizes.NumDiscStates = 0;
sizes.NumOutputs = 1;	     %Set number of outputs						   
sizes.NumInputs = 0;		   %Set number of inputs					   

sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = 1;		%Need at least one sample time
sys = simsizes(sizes); 
%
x0=[0;0;0;0;0;0];						% Set initial state				

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
sys= double_pend_on_cart_for_sfun(t,x);									
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mdlOutput
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function sys = mdlOutputs(t,x,u)
%
% Compute y based on (t,x,u) and set it equal to sys

sys = x;														          

