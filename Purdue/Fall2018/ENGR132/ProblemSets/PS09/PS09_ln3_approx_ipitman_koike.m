function [estimate, abs_diff] = PS09_ln3_approx_ipitman_koike(num_terms)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Our program is going to estimate the value of ln(3) given the number of
% scalar terms
%
% Function Call
% [estimate, abs_diff] = PS09_ln3_approx_ipitman_koike(num_terms)
%
% Input Arguments
% 1. num_terms : number of terms as a scalar input argument
%
% Output Arguments
% 1. estimate
% 2. abs_diff
%
% Assignment Information
%   Assignment:  	    PS 09, Problem 1
%   Team ID:            002-08
%   Paired Partner:  Ian Pitman, ipitman@purdue.edu
%   Paired Partner:  Tomoki Koike, koike@purdue.edu
%   Contributor:        Name, login@purdue [repeat for each]
%   Our contributor(s) helped us:	
%     [ ] understand the assignment expectations without
%         telling us how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping us plan our solution.
%     [ ] think through the meaning of a specific error or
%         bug present in our code without looking at our code.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% ____________________
%% INITIALIZATION

% presetting the outputs
estimate = -99;  %the estimated value of ln3
abs_diff = -99;  %the absolute difference between the estimate and the 
                 %matlab calculated value of ln3

%% ____________________
%% CALCULATIONS

% start 
if round(num_terms) - num_terms == 1
    fprintf('Error, invalid n\n');
else
    estimate = 0;
    estimate_prior = 0;
    for index = 0:1:(num_terms - 1)
        estimate_prior = estimate;
        
        % breaking up the calculation for the estimation of ln3
        calc1 = 1/4^(index);   
        calc2 = (1/(2*(index)+1));
        % the actual calculation
        estimate = calc1*calc2;
        
        fprintf('index: %d\n',index);
        fprintf('nth term in summation: %.15f\n', estimate); 
        estimate = estimate_prior + estimate;
        fprintf('summation: %f\n',estimate);
    end 
    abs_diff = abs(log(3)-estimate);
    fprintf('The approximate for ln(3) is %f and the difference between\n', estimate); 
    fprintf('the difference between the approximation and matlab log(3) is %f \n', abs_diff);
end
%% ____________________
%% COMMAND WINDOW OUTPUT

% n=5
% num_terms =5;
% [estimate, abs_diff] = PS09_ln3_approx_ipitman_koike(num_terms)
% index: 0
% nth term in summation: 1.000000000000000
% summation: 1.000000
% index: 1
% nth term in summation: 0.083333333333333
% summation: 1.083333
% index: 2
% nth term in summation: 0.012500000000000
% summation: 1.095833
% index: 3
% nth term in summation: 0.002232142857143
% summation: 1.098065
% index: 4
% nth term in summation: 0.000434027777778
% summation: 1.098500
% The approximate for ln(3) is 1.098500 and the difference between
% the difference between the approximation and matlab log(3) is 0.000113 
% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% <Tomoki Koike>
% 
% estimate =
% 
%     1.0985
% 
% 
% abs_diff =
% 
%    1.1278e-04


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% n=10
% num_terms =10;
% [estimate, abs_diff] = PS09_ln3_approx_ipitman_koike(num_terms)
% index: 0
% nth term in summation: 1.000000000000000
% summation: 1.000000
% index: 1
% nth term in summation: 0.083333333333333
% summation: 1.083333
% index: 2
% nth term in summation: 0.012500000000000
% summation: 1.095833
% index: 3
% nth term in summation: 0.002232142857143
% summation: 1.098065
% index: 4
% nth term in summation: 0.000434027777778
% summation: 1.098500
% index: 5
% nth term in summation: 0.000088778409091
% summation: 1.098588
% index: 6
% nth term in summation: 0.000018780048077
% summation: 1.098607
% index: 7
% nth term in summation: 0.000004069010417
% summation: 1.098611
% index: 8
% nth term in summation: 0.000000897575827
% summation: 1.098612
% index: 9
% nth term in summation: 0.000000200773540
% summation: 1.098612
% The approximate for ln(3) is 1.098612 and the difference between
% the difference between the approximation and matlab log(3) is 0.000000 
% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% <Tomoki Koike>
% 
% estimate =
% 
%     1.0986
% 
% 
% abs_diff =
% 
%    5.8883e-08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%n=20
% num_terms=20;
% [estimate, abs_diff] = PS09_ln3_approx_ipitman_koike(num_terms)
% index: 0
% nth term in summation: 1.000000000000000
% summation: 1.000000
% index: 1
% nth term in summation: 0.083333333333333
% summation: 1.083333
% index: 2
% nth term in summation: 0.012500000000000
% summation: 1.095833
% index: 3
% nth term in summation: 0.002232142857143
% summation: 1.098065
% index: 4
% nth term in summation: 0.000434027777778
% summation: 1.098500
% index: 5
% nth term in summation: 0.000088778409091
% summation: 1.098588
% index: 6
% nth term in summation: 0.000018780048077
% summation: 1.098607
% index: 7
% nth term in summation: 0.000004069010417
% summation: 1.098611
% index: 8
% nth term in summation: 0.000000897575827
% summation: 1.098612
% index: 9
% nth term in summation: 0.000000200773540
% summation: 1.098612
% index: 10
% nth term in summation: 0.000000045413063
% summation: 1.098612
% index: 11
% nth term in summation: 0.000000010366025
% summation: 1.098612
% index: 12
% nth term in summation: 0.000000002384186
% summation: 1.098612
% index: 13
% nth term in summation: 0.000000000551895
% summation: 1.098612
% index: 14
% nth term in summation: 0.000000000128458
% summation: 1.098612
% index: 15
% nth term in summation: 0.000000000030043
% summation: 1.098612
% index: 16
% nth term in summation: 0.000000000007055
% summation: 1.098612
% index: 17
% nth term in summation: 0.000000000001663
% summation: 1.098612
% index: 18
% nth term in summation: 0.000000000000393
% summation: 1.098612
% index: 19
% nth term in summation: 0.000000000000093
% summation: 1.098612
% The approximate for ln(3) is 1.098612 and the difference between
% the difference between the approximation and matlab log(3) is 0.000000 
% I am submitting code that is my own original work. I have not used
% source code, either modified or unmodified, obtained from any
% unauthorized source. Neither have I provided access to my code to any
% peer or unauthorized source. Signed,
% <Tomoki Koike>
% 
% estimate =
% 
%     1.0986
% 
% 
% abs_diff =
% 
%    2.9754e-14


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT

% Call your academic integrity statement here
PS07_academic_integrity_koike("Tomoki Koike");