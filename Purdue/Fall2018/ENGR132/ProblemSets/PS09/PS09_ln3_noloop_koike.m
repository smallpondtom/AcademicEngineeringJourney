function [approx_ln3, abs_diff] = PS09_ln3_noloop_koike(num_terms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% This program calculates the estimate of ln3 and the absolute 
% difference with the matlab calculated ln3 the without using a 
% loop command 
%
% Function Call
% [estimate, abs_diff] = PS09_ln3_noloop_koike(num_terms);
%
% Input Arguments
% 1. num_terms: the number of terms for the approximate summation
%
% Output Arguments
% 1. estimate: the approximate value of ln3
% 2. abs_diff: the absolute difference between the approximate and the 
% matlab calculated value for ln3.
%
% Assignment Information
%   Assignment:       	PS 09, Problem 2
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

% initialization of output
approx_ln3 = -99;
abs_diff = -99;
%% ____________________
%% CALCULATIONS

% start
if round(num_terms) - num_terms == 1 || num_terms<0
    fprintf('Error, invalid n\n');
else
    % the index for the summation
    index = 0:1:(num_terms-1);
    cal_ln3 = sum(1 ./ 4.^(index) .* (1 ./ (2*(index)+1)));
    approx_ln3 = cal_ln3;
    abs_diff = abs(log(3)-approx_ln3);
    fprintf('the approximate value of ln3 is %f and the absolute difference is %f', approx_ln3, abs_diff);
end

%% ____________________
%% COMMAND WINDOW OUTPUT

% test case 1 <n=8>
% num_terms = 8;
% [estimate, abs_diff] = PS09_ln3_noloop_koike(num_terms)
% The approximate value of ln3 is 1.098611 and the absolute difference is 0.000001
%
% estimate =
% 
%     1.0986
% 
% 
% abs_diff =
% 
%    1.1572e-06
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test case 2 <n=8>
% num_terms = 12;
% [estimate, abs_diff] = PS09_ln3_noloop_koike(num_terms)
% the approximate value of ln3 is 1.098612 and the absolute difference is 0.000000
% estimate =
% 
%     1.0986
% 
% 
% abs_diff =
% 
%    3.1038e-09
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test case 3 <n=24>
% num_terms = 24;
% [estimate, abs_diff] = PS09_ln3_noloop_koike(num_terms)
% the approximate value of ln3 is 1.098612 and the absolute difference is 0.000000
% estimate =
% 
%     1.0986
% 
% 
% abs_diff =
% 
%    6.6613e-16
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% test case 4 <n=-0.25>
% num_terms = -0.25;
% [estimate, abs_diff] = PS09_ln3_noloop_koike(num_terms)
% Error, invalid n
% 
% estimate =
% 
%    -99
% 
% 
% abs_diff =
% 
%    -99

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

% Call your academic integrity statement here
PS07_academic_integrity_koike("Tomoki Koike");