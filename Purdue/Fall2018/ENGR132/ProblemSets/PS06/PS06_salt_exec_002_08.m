%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% Function Call
% 1. [cone_height, cone_weight] = PS06_salt_cone_koike_lee2219(cone_width);
% 2. [windrow_height,windrow_weight] = PS06_salt_windrow_ipitman_zhou823(windrow_width,windrow_length);
%
% Input Arguments
% 1. (a)diameter: the diameter or the width of the conical pile
% 2. (a)windrow_width: the diameter of the windrow pile
%    (b)windrow_length: the length of the windrow pile
%
% Output Arguments
% 1. (a)coneHeight: is the calculated height of the cone (scalar)
%    (b)coneWidth: is the calculated weight of the cone  (scalar)
% 2. (a)Windrow height (scalar)
%    (b)Windrow weight (scalar)
% Assignment Information
%   Assignment:			PS 06, Problem 2
%   Team ID:			002-08
%   Team Member:		Tomoki Koike, koike@purdue.edu
%   Team Member:		Eu Jin Lee, lee2219@purdue.edu
%   Team Member:		Yi Zhou, zhou823@purdue.edu
%   Team Member:		Ian Pitman, ipitman@purdue.edu
%   Contributor:		Name, login@purdue [repeat for each]
%   Our contributor(s) helped us:	
%     [ ] understand the assignment expectations without
%         telling us how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping us plan our solution.
%     [ ] think through the meaning of a specific error or
%         bug present in our code without looking at our code.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ____________________
%% INITIALIZATION

cone_width = 21.50;        %the width of the conical pile width (m)
angle_repose = 32;         %the angle of the natrually formed slope of
                           %salt pile, aka angle of repose (degrees)
density_salt = 80;         %the density of salt (lb/ft^3)
windrow_width = 18.35;     %the width of the windrow piles (m)
windrow_length = 45;       %the length of the windrow pile (m)
saltTotal = 24361;        %the total amount of salt (metric tons)    


%% ____________________
%% CALCULATIONS & FORMATTED TEXT

% calculating the height and the weight of the conical pile
[cone_height, cone_weight] = PS06_salt_cone_koike_lee2219(cone_width);
        
% claculating the number of conical piles to store all the salt
cone_number = saltTotal / cone_weight; 

fprintf("The number of conical piles to store all the salt is %.0f.\n", cone_number);

% calculating the height and the weight of the windrow pile
[windrow_height,windrow_weight] = PS06_salt_windrow_ipitman_zhou823(windrow_width,windrow_length);

% calculating the number of windrow piles to store to 
% store all the salt
windrow_number = saltTotal / windrow_weight;

fprintf("The number of windrow piles to store all the salt is %.0f.\n", windrow_number);



%% ____________________
%% COMMAND WINDOW OUTPUT

% Cone width 21.5m
% callout for the cone 
%[cone_height, cone_weight] = PS06_salt_cone_koike_lee2219(cone_width);

% callout for the windrow
%[windrow_height,windrow_weight] = PS06_salt_windrow_ipitman_zhou823(windrow_width,windrow_length);

% output
%The height of one conical pile is 6.72 meters. 
%The weight of one conical pile is 1062.3 metric tons. 
%The number of conical piles to store all the salt is 23.
%The height of one windrow pile is 5.73 meters 
%The weight of one windrow pile is 30314.4 metric tons 
%The number of windrow piles to store all the salt is 1.


%% ____________________
%% ANALYSIS

%% -- Q1
% Executing PS01 and PS06 we were able to observe that the former was
% faster to output the results. This is possibly because PS01 is only
% algebraic calculations within one program, whereas PS06 requires 
% the input and output interactions among the execution m-file and 
% the fucntion m-file.

%% -- Q2
% For the output of PS06_salt_cone the function in the command window
% this gives the printed results which is same as the function 
% execution file outputs. However, the difference is that the the 
% former also outputs the cone_height and the cone_weight values.

%% -- Q3
% This outputs the header for the PS06_salt_cone_koike_lee2219 program
% which is greatly helpful in that it gives the documentation
% of the output and input variables and whose code it is.


%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The function we are submitting
% is our own original work.
