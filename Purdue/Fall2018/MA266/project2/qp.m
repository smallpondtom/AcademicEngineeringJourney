function dqdt = qp(t, q, L, R, C, omega)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PROJECT 2 (qp.m file)
% NAME: TOMOKI KOIKE
% CLASS: MA266-074
% PROFESSOR: DR. MARIANO
% 
% DESCRIPTION: THIS PROGRAM HAS THE DIFFERENTIAL EQUATION THAT WE
% ARE GOING TO SOLVE FOR IN ANOTHER PROGRAM
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%% DIFF EQN

L = 1;     %the inductance
C = 1/5;   %the capacitance 
R = 4;     %the resistance

%method 1
dqdt = zeros(2,1);
dqdt(1) = q(2);
dqdt(2) =  10/L*cos(omega*t) - R/L.*q(2) - 1/L/C.*q(1);
