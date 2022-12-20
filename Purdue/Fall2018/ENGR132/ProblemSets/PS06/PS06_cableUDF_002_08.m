function [cable_length,cable_weight,total_cost] = PS06_cableUDF_002_08(bridge_height, distances_deck, num_strand) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENGR 132 
% Program Description 
% We are on a civil engineering team working on a pedestrian bridge. This
% is user defined function that has three inputs and three output to
% calculate the cable length, cable weight and total cost based on data
% input.
%
% Function Call
% [cable_length,cable_weight,total_cost] = PS06_cableUDF_002_08(bridge_height, distances_deck, num_strand)
%
% Input Arguments
% 1. Heights from the bridge deck to the cable tower anchorage
% 2. Distances between the tower base and the cable deck anchorage
% 3. Number of strands in the cable
%
% Output Arguments
% 1. Total Cable Length
% 2. Total Cable Weight
% 3. Total Estimated Cost
%
% Assignment Information
%   Assignment:       	PS 06, Problem 3
%   Team ID:			002-08
%   Team Member:		Ian Pitman, ipitman@purdue.edu
%   Team Member:		Eu Jin Lee, lee2219@purdue.edu
%   Team Member:		Tomoki Koike, koike@purdue.edu
%   Team Member:		Yi Zhou, zhou823@purdue.edu
%  	Contributor: 		Name, login@purdue [repeat for each]
%   My contributor(s) helped me:	
%     [ ] understand the assignment expectations without
%         telling me how they will approach it.
%     [ ] understand different ways to think about a solution
%         without helping me plan my solution.
%     [ ] think through the meaning of a specific error or
%         bug present in my code without looking at my code.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% ____________________
%% INITIALIZATION

strand_weight = 1.1; %weight of each strand
costPerKg = 25;     %cost per kg


%% ____________________
%% CALCULATIONS

cable_lengthvector = sqrt(bridge_height .^2 + distances_deck .^2);  %get the cable length by Pythagorean theorem 

cable_length = sum(cable_lengthvector);    %total cable length

cable_weight = sum(strand_weight * cable_lengthvector .* num_strand);    %weight of total cables 

total_cost = costPerKg * cable_weight;        %cost of all cables 


%% ____________________
%% COMMAND WINDOW OUTPUT
% [cable_length,cable_weight,total_cost] = PS06_cableUDF_002_08(bridge_height, distances_deck, num_strand) 
% 
% cable_length =
% 
%   675.4893
% 
% 
% cable_weight =
% 
%    3.1798e+04
% 
% 
% total_cost =
% 
%    7.9495e+05

%% ____________________
%% ACADEMIC INTEGRITY STATEMENT
% We have not used source code obtained from any other unauthorized
% source, either modified or unmodified.  Neither have we provided
% access to our code to another. The function we are submitting
% is our own original work.
