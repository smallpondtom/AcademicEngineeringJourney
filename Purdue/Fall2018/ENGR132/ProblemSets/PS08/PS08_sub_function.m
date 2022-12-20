function [y_value] = PS08_sub_function(x_value)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program is designed to be a sub function for the simplex function
% by providing a known function to the simplex function code.
%
% Function Call
% PS08_sub_function(x_value)
%
% Input Arguments
% 1. x_value: the x value of the function
%
% Output Arguments
% 1. y_value: the coresponding y value for the given function of x
%
% Assignment Information
%   Assignment:       	PS 08, Problem 3
%   Author:             Tomoki Koike, koike@purdue.edu
%   Team ID:            002-08      
%  	Contributor: 		Name, login@purdue [repeat for each]
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ____________________
%% INITIALIZATION

% the nameArray for the academic integrity statement 
nameArray = "Tomoki Koike";


%% ____________________
%% CALCULATIONS

y_value = 2 * (x_value - 4)^2 - 5;

%% ____________________
%% COMMAND WINDOW OUTPUT



%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

% Call your academic integrity statement here
PS07_academic_integrity_koike(nameArray);



