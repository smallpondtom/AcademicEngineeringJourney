function dudt = up2(t,u, omega)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PROJECT 1 (yp.m file)
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

%method 1
dudt = zeros(2,1);
dudt(1) = u(2);
dudt(2) =  cos(omega*t) - 1/5.*u(2) - (u(1) + 1/5*u(1).^3);

