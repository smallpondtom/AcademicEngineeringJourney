function dudt = up(t,u,e)
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

% The equation below is the differential equation that we intend to 
% solve

dudt = [u(2); -u(1)-e*u(1)^3];


